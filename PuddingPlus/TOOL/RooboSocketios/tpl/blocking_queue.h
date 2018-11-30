/*
* blocking_queue.h
*
*  Created on: 2016年7月21日
*      Author: zhouyuanjiang
*
*  BlockingQueue for producer and consumer pattern
*
*/

#ifndef ROOBO_BLOCKING_QUEUE_H_
#define ROOBO_BLOCKING_QUEUE_H_

#include "../common/guard.h"
#include "../common/mutex.h"
#include "../common/semaphore.h"
#include "../common/log.h"

#include "list.h"

namespace tpl {

	template <class T>

	class BlockingQueue{

	protected:
		roobo::Semaphore semphore_;
		roobo::Mutex mutex_;
		tpl::List<T> list_;
		volatile int _destructed;

	public:

		BlockingQueue(): _destructed(0){

		}

		virtual ~BlockingQueue(){
			_destructed = 1;
		}


		//
		// Offer an item into the queue
		//
		void Offer(T & item){
			roobo::Guard guard(&mutex_);
			list_.push_front(item);
			semphore_.Post();
		}

		//
		// Take item from quque, would block if queue is empty
		//
		T Take(){
			semphore_.Wait();
			roobo::Guard guard(&mutex_);
			T item = list_.retrieve_back();
			return item;
		}

		//
		// Take item with timeout
		//
		bool TimedTake(int timeout_ms, T * item){

			if(NULL == item){
				return false;
			}

			roobo::TimedWaitResult result =  semphore_.TimedWait(timeout_ms);
			
			if(result == roobo::kSuccess){
				roobo::Guard guard(&mutex_);
				*item = list_.retrieve_back();
				return true;
			}

			return false;
		}
	};
}


#endif /* ROOBO_BLOCKING_QUEUE_H_ */
