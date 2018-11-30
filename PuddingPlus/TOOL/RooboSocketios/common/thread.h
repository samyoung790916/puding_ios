/*
* thread.h
*
*  Created on: 2016年7月19日
*      Author: zhouyuanjiang
*/

#ifndef ROOBO_THREAD_H_
#define ROOBO_THREAD_H_

#include "platform.h"
#include <pthread.h>
#include <errno.h>
#include "log.h"

namespace roobo {

	enum ThreadState {
		kIdle = 0,
		kRunning = 1,
		kCompleted = 2,
		kError = 3
	};

	//
	// Thread function pointer
	//
	typedef void * (*ThreadFunc)(void * params);

	class Thread {

	private:

		pthread_t tid_;
		pthread_attr_t attr_;
		ThreadFunc function_pointer_;
		ThreadState state_;

	public:

		Thread(ThreadFunc function) :
			tid_(0), function_pointer_(function), state_(kIdle)
		{
			assert(function);
			memset(&attr_, 0, sizeof(pthread_attr_t));
		}

		virtual ~Thread(){
			//log_d("%s %s", __FILE__, __FUNCTION__);
			state_ = kCompleted;
		}

		long Start(void * params){

			if(state_ != kIdle){
				log_e("thread already started.");
				return -1;
			}

			int err = pthread_create(&tid_, NULL, function_pointer_, params);
			
			if(err != 0){
				log_d("pthread_create failed %s %s %d %d", __FILE__, __FUNCTION__, errno, err);
				state_ = kError;
				return err;
			}

			state_ = kRunning;
			log_d(" %s %s ok", __FILE__, __FUNCTION__);

			return 0;
		}

		int Join(){

			int ret = pthread_join(tid_, NULL);
			
			if(ret != 0){
				log_e("pthread_join failed %d", ret);
			}

			return ret;
		}

		//
		// Get State of the thread
		//
		ThreadState & GetState(){
			return state_;
		}
	};
}

#endif /* ROOBO_THREAD_H_ */
