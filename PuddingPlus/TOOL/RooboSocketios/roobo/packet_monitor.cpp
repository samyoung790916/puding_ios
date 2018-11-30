#include "packet_monitor.h"
#include "../common/log.h"
#include "../longliveconn/event_factory.h"
#include "../roobo/roobo_packet_factory.h"

namespace roobo {

	/**
	TimerManager * timer_manager_;

	longliveconn::LongLiveConn * llc_;

	longliveconn::StateMachine * machine_;

	//  key packet sn and delivery task map
	tpl::Map<uint64_t, DeliveryTask> sn_task_map_; // map for normal packet

	// associates timer id and packet sn
	tpl::Map<int, uint64_t> tid_sn_map_;

	tpl::SmartPtr<TimerCallback> * timer_callback_;
	*/


	PacketMonitor::PacketMonitor(tpl::SmartPtr<TimerCallback> * timer_callback, longliveconn::LongLiveConn * llc, longliveconn::StateMachine * machine)
		:timer_manager_(TimerManager::GetInstance()), llc_(llc), machine_(machine), timer_callback_(timer_callback)
	{
		assert(timer_manager_ != NULL);
		assert(llc_ != NULL);
		assert(machine_ != NULL);
		assert(timer_callback_ != NULL);
	}


	PacketMonitor::~PacketMonitor(void)
	{
		RemoveAllPackets();

		llc_ = NULL;
		timer_manager_ = NULL;
		machine_ = NULL;
		timer_callback_ = NULL;
	}


	//
	// Notify that packet is sent, the packet may be recycled
	//
	bool PacketMonitor::OnPacketSent(uint64_t sn, bool succeeded){

		uint32_t hi = HI64(sn);
		uint32_t lo = LO64(sn);

		log_d("OnPacketSent 0x%08x%08x, success = %d", hi, lo, succeeded);
        log_d("长连接命令发送是否成功 ============================= %d", succeeded);
        

		//DeliveryTask * task = NULL;
		DeliveryTask * task = sn_task_map_.Get(sn);

		if(task == NULL){
			log_d("BUG, packet must Add task first 0x%08x%08x", hi, lo);
			return false;
		}

		bool f_resend = task->resend();
		bool f_report = task->report();
		bool f_expect_ack = task->expect_ack();


		task->send_count++;	

		if(!f_resend){
			// Packet do not need to resend, recycle it
			longliveconn::Packet * packet = task->packet;
			RooboPacketFactory::GetInstance()->RecyclePacket(&packet);
		}

		bool task_finished = false;

		if(succeeded){
			if(f_expect_ack){ 
				tpl::SmartPtr<TimerCallback> callback(*timer_callback_);
				int tid = timer_manager_->AddOnceTimer(callback, PACKET_TIMEOUT, NULL);		
				task->action_timer_id = tid;
				tid_sn_map_.Put(tid, sn);

			} else {
				task_finished = true;
			}
		} else {
			if(!f_resend || (f_resend && task->send_count >= kMaxResendCount)){
				task_finished = true;
			} 
		}

		if(task_finished){

			if(f_report){
				mark();
				llc_->ReportPacketResult(sn, succeeded ? longliveconn::kPR_OK : longliveconn::kPR_Failed, NULL);
			}

			if(f_resend){ // resend packets exceeds maximun resend count

				tid_sn_map_.Remove(task->task_timer_id);
				timer_manager_->RemoveTimer(task->task_timer_id);

				longliveconn::Packet * packet = task->packet;
				RooboPacketFactory::GetInstance()->RecyclePacket(&packet);
			}

			sn_task_map_.Remove(sn);
		} 

		return true;
	}



	PacketType PacketMonitor::OnPacketReceived(longliveconn::Packet * packet){

		if(NULL == packet){
			return kInvalidPacket;
		}

		PacketType p_type = kPushPacket;
		uint64_t sn = packet->GetSn();
		uint32_t hi = HI64(sn);
		uint32_t lo = LO64(sn);

		log_d("OnPacketReceived 0x%08x%08x", hi, lo);

	
		// DeliveryTask * task = NULL;
		DeliveryTask * task = sn_task_map_.Get(sn);

		if(NULL == task){
			log_d("PacketMonitor::OnPacketReceived pushd packet");
			return p_type;
		}

		p_type = kNormalPacketAck;

		longliveconn::PacketSendFlag flags = task->flags;

		bool f_resend = HAS_FLAG(flags, roobo::longliveconn::kResendOnFailure);
		bool f_report = HAS_FLAG(flags, roobo::longliveconn::kResultReport);

		tid_sn_map_.Remove(task->action_timer_id);

		timer_manager_->RemoveTimer(task->action_timer_id);
		log_d("f_resend %s", f_resend);
		log_d("f_report %s", f_report);
		if(f_resend){

			longliveconn::Packet * user_packet = task->packet;

			tid_sn_map_.Remove(task->task_timer_id);

			timer_manager_->RemoveTimer(task->task_timer_id);

			RooboPacketFactory::GetInstance()->RecyclePacket(&user_packet);
		}

		// RB_FREE(task);

		sn_task_map_.Remove(sn);

		log_d("GetCategory %d", packet->GetHeader()->GetCategory());
		if(f_report || packet->GetHeader()->GetCategory() == 0xe1){
			mark();
			llc_->ReportPacketResult(sn, longliveconn::kPR_OK, (RooboPacket*)packet);
			p_type = kUserPacketAck;
		}

		return p_type;
	}


	int PacketMonitor::OnTimeout(TimeoutArgs * timeout_args)
	{
		if(NULL == timeout_args){
			mark();
			return -1;
		}

		int id = timeout_args->timer_id;
		void * context = timeout_args->context;

		uint64_t * p_sn = tid_sn_map_.Get(id);
		if(p_sn == NULL){
			log_d("PacketMonitor::OnTimeout ignore diry timeout %d", id);
			tid_sn_map_.Remove(id);
			return 0;
		}

		uint64_t sn = *p_sn;
		uint32_t hi = HI64(sn);
		uint32_t lo = LO64(sn);

		log_d("PacketMonitor::OnTimeout sn = 0x%08x%08x, timerid = %d, ctx = 0x%08x, ", hi, lo, id, context);

		DeliveryTask * task = sn_task_map_.Get(sn);
		if(task == NULL){
			tid_sn_map_.Remove(id);
			return 0;
		}

		longliveconn::PacketSendFlag flags = task->flags;

		bool f_resend = HAS_FLAG(flags, roobo::longliveconn::kResendOnFailure);
		bool f_report = HAS_FLAG(flags, roobo::longliveconn::kResultReport);

		bool task_finished = false;

		if(task->task_timer_id == id ){ // task has timeout
			mark();
			tid_sn_map_.Remove(task->task_timer_id);
			task_finished = true;

		} else{
			mark();
			tid_sn_map_.Remove(task->action_timer_id);

			// report of packet timeout
			longliveconn::Event * evt = longliveconn::EventFactory::GetInstance()->ObtainEvent(false, sn);
			machine_->PostEvent(evt);

			if(!f_resend || (f_resend && task->send_count >= kMaxResendCount)){
				task_finished = true;
			}
		}

		if(task_finished){

			if(f_resend){

				timer_manager_->RemoveTimer(task->task_timer_id);
				longliveconn::Packet * packet = task->packet;
				RooboPacketFactory::GetInstance()->RecyclePacket(&packet);

			} else {
				timer_manager_->RemoveTimer(task->action_timer_id);
			}
 
			sn_task_map_.Remove(sn);

			if(f_report){
				mark();
				llc_->ReportPacketResult(sn, longliveconn::kPR_Timeout, NULL);
			}
		}

		// TODO: consider the situation, user pakcet timeouts, while retrying packet has been sent
		// we report packet timeouts, but it may actually succeeds.

		return 0;
	}

	bool PacketMonitor::ResendPendingUserPackets(){

		bool result = true;

		tpl::Vector<longliveconn::Packet*> pending_user_packets;

		{
			tpl::MapIterator<uint64_t, DeliveryTask> it(sn_task_map_);
			tpl::Pair<uint64_t, DeliveryTask> * cursor = it.Next();

			while(cursor){

				DeliveryTask task = cursor->value();

				if(HAS_FLAG(task.flags, roobo::longliveconn::kResendOnFailure)){
					pending_user_packets.PushBack(task.packet);
				}

				cursor = it.Next();
			}	
		}

		// DoSendPacket will call OnPacketSent thus blocking on the smae
		for(int i = 0; i< pending_user_packets.Size(); i++){
			if(! llc_->DoSendPacket(pending_user_packets[i])){
				log_e("%s user Re-SendPacket failed", __FILE__);
				result = false;
				break;
			} else {
				log_e("%s user Re-SendPacket ok", __FILE__);
			}
		}

		return result;
	}

	//
	// Look for the packet already sent, mark them as failed
	//
	void PacketMonitor::RemovePendingPackets(){


		tpl::Vector<uint64_t> tasks_to_remove;
		tpl::Vector<int> tid_to_remove;
		tpl::Map<uint64_t, uint64_t> result_report;

		tpl::MapIterator<int, uint64_t> it(tid_sn_map_);
		tpl::Pair<int, uint64_t> * cursor = it.Next();

		while(cursor){

			uint64_t sn = cursor->value();
			uint32_t hi = HI64(sn);
			uint32_t lo = LO64(sn);

			DeliveryTask * task = sn_task_map_.Get(cursor->value());

			if(task == NULL){

				mark();

				log_d("missed sn 0x%08x%08x", hi, lo);
				tid_to_remove.PushBack(cursor->key());

				cursor = it.Next();				
				continue;
			}

			longliveconn::PacketSendFlag flags = task->flags;

			bool f_resend = HAS_FLAG(flags, roobo::longliveconn::kResendOnFailure);
			bool f_report = HAS_FLAG(flags, roobo::longliveconn::kResultReport);

			// packet does not require resending, or packet exceeds max resend count
			if(!f_resend || ( f_resend && task->send_count >= kMaxResendCount)){

				tasks_to_remove.PushBack(sn);

				if(f_report){
					if(!result_report.ContainsKey(sn)){
						llc_->ReportPacketResult(sn, roobo::longliveconn::kPR_Failed, NULL);
						result_report.Put(sn,sn);
					}
				}
			}

			cursor = it.Next();
		}


		for(int i = 0; i< tasks_to_remove.Size() ;i++){

			uint64_t sn = tasks_to_remove[i];

			DeliveryTask * task = sn_task_map_.Get(sn);
			if(task == NULL){
				mark(); 
				continue;
			}

			timer_manager_->RemoveTimer(task->action_timer_id);

			tid_sn_map_.Remove(task->action_timer_id);

			if(HAS_FLAG(task->flags, roobo::longliveconn::kResendOnFailure)){
				timer_manager_->RemoveTimer(task->task_timer_id);
				tid_sn_map_.Remove(task->task_timer_id);
			}

			// RB_FREE(task);

			sn_task_map_.Remove(sn);
		}

		for(int i = 0; i< tid_to_remove.Size(); i++){
			timer_manager_->RemoveTimer(tid_to_remove[i]);
			tid_sn_map_.Remove(tid_to_remove[i]);
		}
	}



	void PacketMonitor::RemoveAllPackets(){

		{
			tpl::MapIterator<uint64_t, DeliveryTask> it(sn_task_map_);
			tpl::Pair<uint64_t, DeliveryTask> * cursor = it.Next();

			while(cursor){

				DeliveryTask record = cursor->value();

				if(record.send_count > 0 ){
					timer_manager_->RemoveTimer(record.action_timer_id);
					tid_sn_map_.Remove(record.action_timer_id);
				}

				if(HAS_FLAG( record.flags, roobo::longliveconn::kResendOnFailure)){

					timer_manager_->RemoveTimer(record.task_timer_id);	
					tid_sn_map_.Remove(record.task_timer_id);

					longliveconn::Packet * packet = record.packet;
					RooboPacketFactory::GetInstance()->RecyclePacket(&packet);
				}

				cursor = it.Next();
			}

			sn_task_map_.Clear();
		}


		tpl::Vector<int> tid_to_remove;

		tpl::MapIterator<int, uint64_t> it(tid_sn_map_);
		tpl::Pair<int, uint64_t> * cursor = it.Next();

		while(cursor){
			timer_manager_->RemoveTimer(cursor->key());
			cursor = it.Next();
		}

		tid_sn_map_.Clear();
	}

	//
	// Add user packet task
	//
	void PacketMonitor::AddPacketTask(longliveconn::Packet * packet, longliveconn::PacketSendFlag flags){

		if(NULL == packet){
			mark();
			return;
		}

		uint64_t sn = packet->GetSn();

		DeliveryTask * task_holder =  sn_task_map_.Get(sn);

		uint32_t hi = HI64(sn);
		uint32_t lo = LO64(sn);

		if(task_holder != NULL){
			log_d("AddPacketTask already added sn = 0x%08x%08x, ignore", hi, lo);
			return;
		}

		log_d("AddPacketTask added sn = 0x%08x%08x", hi, lo);

		DeliveryTask task;
		task.packet = packet;
		task.flags = flags;
		task.send_count = 0;
		task.sn = sn;

		if(HAS_FLAG(flags, roobo::longliveconn::kResendOnFailure)){
			tpl::SmartPtr<TimerCallback> callback(*timer_callback_);
			task.task_timer_id = timer_manager_->AddOnceTimer(callback, USER_PACKET_TIMEOUT, NULL);
			tid_sn_map_.Put(task.task_timer_id, sn);
		}

		sn_task_map_.Put(sn, task);
	}
}
