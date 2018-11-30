/*
* mutex.h
*
*  Created on: 2016年7月19日
*      Author: zhouyuanjiang
*/

#ifndef ROOBO_MUTEX_H_
#define ROOBO_MUTEX_H_

#include "platform.h"
#include <pthread.h>
#include <errno.h>
#include "log.h"

namespace roobo {

	class Mutex {


	private:
		pthread_mutex_t mutex_;
		pthread_mutexattr_t attr_;

	public:

		Mutex(){

			if(pthread_mutexattr_init(&attr_)){
				log_d("pthread_mutexattr_init failed, errno = %d, msg = %s", errno, strerror(errno));
			}

			// PTHREAD_MUTEX_DEFAULT
			// PTHREAD_MUTEX_RECURSIVE
			if(pthread_mutexattr_settype(&attr_, PTHREAD_MUTEX_DEFAULT)){
				log_d("pthread_mutexattr_settype failed, errno = %d, msg = %s", errno, strerror(errno));
			}

			if(pthread_mutex_init(&mutex_, &attr_)){
				log_d("pthread_mutex_init failed, errno = %d, msg = %s", errno, strerror(errno));
			}
		}

		void Lock()  {
#ifdef DEBUG_MUTEX
			log_d("Mutex pre-Lock 0x%08x", this);
#endif
			if(pthread_mutex_lock(&mutex_)){
				log_d("pthread_mutex_lock failed, errno = %d, msg = %s", errno, strerror(errno));
			}
#ifdef DEBUG_MUTEX
			log_d("Mutex post-Lock 0x%08x", this);
#endif
		}

		void Unlock() {
#ifdef DEBUG_MUTEX
			log_d("Mutex pre-Unlock 0x%08x", this);
#endif
			if(pthread_mutex_unlock(&mutex_)){
				log_d("pthread_mutex_unlock failed, errno = %d, msg = %s", errno, strerror(errno));
			}
#ifdef DEBUG_MUTEX
			log_d("Mutex pre-Unlock 0x%08x", this);
#endif
		}

		~Mutex(){
			pthread_mutex_destroy(&mutex_);
		}
	};

}
#endif /* ROOBO_MUTEX_H_ */
