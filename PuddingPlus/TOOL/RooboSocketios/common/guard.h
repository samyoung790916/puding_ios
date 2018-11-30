/*
* guard.h
*
*  Created on: 2016年7月21日
*      Author: zhouyuanjiang
*/

#ifndef ROOBO_GUARD_H_
#define ROOBO_GUARD_H_

#include "platform.h"
#include "mutex.h"
#include "log.h"

namespace roobo {

	class Guard {

	private:
		Mutex * mutex_;

	public:
		explicit Guard(Mutex * mutex){
			assert(mutex);
			mutex_ =  mutex;
			mutex_->Lock();
		}

		~Guard(){
			mutex_->Unlock();
			mutex_ = NULL;
		}
	};
}
#endif /* ROOBO_GUARD_H_ */
