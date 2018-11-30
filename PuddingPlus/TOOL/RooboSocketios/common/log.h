/*
* log.h
*
*  Created on: 2016年7月19日
*      Author: zhouyuanjiang
*/

#ifndef INCLUDE_LOG_H_
#define INCLUDE_LOG_H_

#include "platform.h"



#define LEVEL_NOTICE 	4
#define LEVEL_DEBUG 	3
#define LEVEL_TRACE 	2
#define LEVEL_WARNING 	1
#define LEVEL_ERROR 	0

#define mark() log_d("%s %d", __PRETTY_FUNCTION__, __LINE__)

namespace roobo {

	class Logger {

	private:
		static Logger * _instance;
		Logger() : level_(LEVEL_NOTICE) {
		}

	protected:
		int level_;

	public:
		static Logger * getInstance();

		void setLevel(int level){
			level_ = level;
		}

		virtual ~Logger(){
		}

		void log(int level, const char * fmt, ...);
	};
}


#ifndef _WIN32

#define log_n(fmt, args...) 	::roobo::Logger::getInstance()->log(LEVEL_NOTICE, fmt, ##args)
#define log_d(fmt, args...) 	::roobo::Logger::getInstance()->log(LEVEL_DEBUG, fmt, ##args)
#define log_t(fmt, args...) 	::roobo::Logger::getInstance()->log(LEVEL_TRACE, fmt, ##args)
#define log_w(fmt, args... ) 	::roobo::Logger::getInstance()->log(LEVEL_WARNING, fmt, ##args)
#define log_e(fmt, args...) 	::roobo::Logger::getInstance()->log(LEVEL_ERROR, fmt, ##args)

#else

#include <stdio.h>
#define log_n 	printf
#define log_d 	printf
#define log_t 	printf
#define log_w 	printf
#define log_e 	printf

#endif

#endif /* INCLUDE_LOG_H_ */
