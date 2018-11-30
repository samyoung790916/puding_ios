#include "timer.h"
#include "utils.h"
#include "log.h"
#include "atomic.h"
#include "tpl/smart_ptr.h"

namespace roobo {

	TimerManager * TimerManager::instance_ = new TimerManager();

	tpl::SmartPtr<TimerManager> kTimerManagerPtr(TimerManager::GetInstance());

	void * TimerThreadFunc(void * params){
		TimerManager * timer_manager = (TimerManager*)params;
		timer_manager->Run();
		return NULL;
	}

	TimerManager::TimerManager() 
		: thread_(TimerThreadFunc), shutdown_(false),timer_id_seed_(1)
	{
		thread_.Start(this);
	}

	TimerManager::~TimerManager(){
		log_d("TimerManger destructor");
		this->Shtudown();
	}

	void TimerManager::CancelTimer(int id){

		TimerCommand command ;
		command.cmd = kCancel;
		command.id = id; 

		this->cmd_queue_.Offer(command);

		// log_d("TimerManager::CancelTimer id %d", id);
	}


	int TimerManager::AddTimer(tpl::SmartPtr<TimerCallback> & callback, TimerManager::TimerType timer_type, int timeout_ms, void * context){
        return 0;

		// TODO: id collision after overflow
		int id = add_and_fetch(&timer_id_seed_, 1);

		TimerCommand command;
		command.callback = callback;
		command.context = context;
		command.cmd = kAdd;
		command.id = id;
		command.type = timer_type;
		command.timeout = timeout_ms;

		this->cmd_queue_.Offer(command);

		return id;
	}

	int TimerManager::AddOnDemandTimer(tpl::SmartPtr<TimerCallback> & callback, void * context){

		int id = AddTimer(callback, kFireOnDemand, 0, context);

		// log_d("TimerManager::tpl::SmartPtr id %d context 0x%08x", id, context);

		return id;
	}

	int TimerManager::AddOnceTimer(tpl::SmartPtr<TimerCallback> & callback,  int timeout_ms, void * context){

		int id = AddTimer(callback, kFireOnce, timeout_ms, context);

		// log_d("TimerManager::AddOnceTimer id %d context 0x%08x, timeout %d", id, context, timeout_ms);

		return id;
	}


	int TimerManager::AddRepeatTimer(tpl::SmartPtr<TimerCallback> & callback, int timeout_ms, void * context){

		int id = AddTimer(callback, kRepeat, timeout_ms, context);

		// log_d("TimerManager::AddRepeatTimer id %d context 0x%08x", id, context);

		return id;
	}



	bool TimerManager::ResetTimer(int id, int timeout_ms){

		// log_d("TimerManager::ResetTimer id %d ", id);

		TimerCommand command ;
		command.cmd = kReset;
		command.id = id;
		command.timeout = timeout_ms;

		this->cmd_queue_.Offer(command);

		return true;
	}

	void TimerManager::RemoveTimer(int id){

		TimerCommand command ;
		command.cmd = kRemove;
		command.id = id;
		this->cmd_queue_.Offer(command);

		// log_d("TimerManager::RemoveTimer id %d ", id);

	}

	void TimerManager::RemoveTimerInternal(int id){

		TimerCommand command ;
		command.cmd = kRemove;
		command.id = id;
		this->cmd_queue_.Offer(command);

		// log_d("TimerManager::RemoveTimerInternal id %d ", id);
	}

	void TimerManager::CheckTimers(){

		long now = get_monotonic_time();

		for(int i = 0; i< task_vector_.Size(); i++){

			if(task_vector_[i].triggered){
				continue;
			}

			long due = task_vector_[i].GetDue();
			long diff = now - due;

			if(diff >= 0){		

				TimerTask & task = task_vector_[i];

				if(task.type != kRepeat){ // kRepeat timer never set flag to true excpet kCancel
					task.triggered = true;
				}

				task_vector_[i].last_trigger_time = get_monotonic_time();

				// log_d("%s id %d context 0x%08x", __PRETTY_FUNCTION__, task.id, task.context);

				TimeoutArgs timeout_args;
				timeout_args.timer_id = task.id;
				timeout_args.context = task.context;

				TimerCallback * callback = task.callback.Get();

				if(callback != NULL){
					callback->OnTimeout(timeout_args);					
				} 

				if(task.type == kFireOnce || callback == NULL){
					RemoveTimerInternal(task.id);
				}
			}
		} 
	}

	int TimerManager::GetLeastTimeout(){

		int least = 30000;

		long now = get_monotonic_time();

		for(int i = 0; i< task_vector_.Size(); i++){

			if((task_vector_[i].triggered) ){
				continue;
			}

			long due = task_vector_[i].GetDue();
			long diff = now - due;

			if(diff >= 0){
				least = 0;
			}

			if(diff < 0){
				diff = -diff;
				if(diff < least){
					least = diff;
				}
			}
		}

		if(least < 0){
			least = 0;
		}

		return least;
	}

	TimerManager::TimerTask * TimerManager::FindTask(int id){	
		for(int i = 0; i<task_vector_.Size(); i++){
			if(task_vector_[i].id == id){
				return &task_vector_[i];
			}
		}
		return NULL;
	}

	void TimerManager::HandleCommand(TimerCommand * cmd){

		if(cmd == NULL){
			return;
		}

		if(cmd->cmd == kShutdown){

			shutdown_ = true;

		} else if(cmd->cmd == kAdd){ // kAdd 

			TimerTask task;

			task.id = cmd->id;
			task.timeout = cmd->timeout;
			task.type = cmd->type;
			task.context = cmd->context;
			task.callback = cmd->callback;

			task.last_trigger_time = get_monotonic_time();

			if(task.type == kFireOnDemand){
				task.triggered = true;
			} else if(task.type == kFireOnce){
				task.triggered = false;
			} else if(task.type == kRepeat){
				task.triggered = true;
			}

			task_vector_.PushBack(task);

		} else if(cmd->cmd == kRemove || cmd->cmd == kSyncRemove || cmd->cmd == kReset || cmd ->cmd == kCancel){

			TimerTask * task = FindTask(cmd->id);

			if(task != NULL){

				if(cmd->cmd == kRemove || cmd->cmd == kSyncRemove){ // kRemove
					TimerTask task_to_remove = * task;
					if(!task_vector_.Remove(task_to_remove)){
						log_d("%s %d task is not found, timer_id %d", __PRETTY_FUNCTION__, __LINE__, cmd->id);
					}

					if(cmd->cmd == kSyncRemove){
						log_d("%s %d kSyncRemove timer id, post %d", __PRETTY_FUNCTION__, __LINE__, cmd->id);
						cmd->semaphore->Post();
					}

				} else if(cmd->cmd == kReset){ // kReset

					task->timeout = cmd->timeout;
					task->triggered = false;
					task->last_trigger_time = get_monotonic_time();

				} else if(cmd->cmd == kCancel){ // kCancel

					task->triggered = true;
				}

			} else {

				// log_d("%s timer is not found id %d", __PRETTY_FUNCTION__, cmd->id);

				if(cmd->cmd == kSyncRemove){
					log_d("%s %d kSyncRemove timer id, post %d", __PRETTY_FUNCTION__, __LINE__, cmd->id);
					cmd->semaphore->Post();
				}
			}
		}  
	}

	void TimerManager::Run(){

		TimerCommand cmd;
		long leastimeout = 0;

		while(!shutdown_){

			leastimeout = GetLeastTimeout();

			if(!cmd_queue_.TimedTake(leastimeout, &cmd)){
				CheckTimers();
				continue;
			}

			HandleCommand(&cmd);

			CheckTimers();
		}

		// TODO delete pending packets
	}


	void TimerManager::Shtudown(){

		if(shutdown_){
			return;
		}

		shutdown_ = true;

		TimerCommand  cmd ;
		cmd.cmd = kShutdown;

		// TODO: with caution, it may block
		cmd_queue_.Offer(cmd);

		thread_.Join();
	}
}