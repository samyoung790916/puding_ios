/*
* timer.h
*
*  Created on: 2016 7 21
*      Author: zhouyuanjiang
*/
#ifndef ROOBO_TIMER_H_
#define ROOBO_TIMER_H_

#include "thread.h"
#include "semaphore.h"
#include "../tpl/vector.h"
#include "../tpl/blocking_queue.h"
#include "../tpl/smart_ptr.h"

namespace roobo {

	struct TimeoutArgs
	{
		int timer_id;
		void * context;
	};

	class TimerCallback {

	public:
		//
		// OnTimeout callback
		// @param timeout_args
		//
		virtual int OnTimeout(const TimeoutArgs & timeout_args) = 0;

		virtual ~TimerCallback(){}
	};

	void * TimerThreadFunc(void * params);

	class TimerManager {

	protected:

		enum TimerType
		{
			kFireOnDemand = 0,
			kFireOnce = 1,
			kRepeat = 2,
		};

		enum Cmd {
			
			kAdd,
			
			kRemove,
			kSyncRemove, 
			kReset,
			kCancel,

			kShutdown,
		};

		struct DataItem
		{
			int id;
			int timeout;			
			TimerType type;			 // timer type
			void * context;
		};

		struct TimerTask : public DataItem
		{
			tpl::SmartPtr<TimerCallback> callback;
			long last_trigger_time;	 // last time timer trigger
			bool triggered;			 // whether the timer is triggered
			long GetDue(){
				return last_trigger_time + timeout;
			}

			TimerTask(){
				DataItem();
			}

			bool operator == (const TimerTask task){
				if(id == task.id){
					return true;	
				}
				return false;
			}
		};

		struct TimerCommand : public DataItem
		{
			tpl::SmartPtr<TimerCallback> callback;
			Cmd cmd;
			Semaphore * semaphore;

			TimerCommand(){
				DataItem();
			}
		};

		Thread thread_;

		tpl::Vector<TimerTask> task_vector_;

		tpl::BlockingQueue<TimerCommand> cmd_queue_;

		volatile bool shutdown_;

		int timer_id_seed_;

		static TimerManager * instance_;

		int GetLeastTimeout();

		void CheckTimers();

		TimerTask * FindTask(int id);

		int AddTimer(tpl::SmartPtr<TimerCallback> & callback, TimerType timer_type, int timeout_ms, void * context);

		TimerManager();

		void RemoveTimerInternal(int id);

		void HandleCommand(TimerCommand * cmd);
 
	public:

		virtual ~TimerManager();

		static TimerManager * GetInstance(){return instance_;}

		int AddOnDemandTimer(tpl::SmartPtr<TimerCallback> & callback, void * context);

		int AddOnceTimer(tpl::SmartPtr<TimerCallback> & callback, int timeout_ms, void * context);

		int AddRepeatTimer(tpl::SmartPtr<TimerCallback> & callback, int timeout_ms, void * context);

		bool ResetTimer(int id, int timeout_ms);

		void RemoveTimer(int id);

		void CancelTimer(int id);

		void Run();

		void Shtudown();
	};

}
#endif /* ROOBO_TIMER_H_ */
