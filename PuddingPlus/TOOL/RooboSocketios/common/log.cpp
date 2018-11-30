#include "log.h"
#include <stdio.h>
#include <stdarg.h>

#if defined(ANDROID) || defined(__ANDROID__)
#include <stdio.h>
#include <stdlib.h>
#include <android/log.h>
#endif

namespace roobo{

	Logger * Logger::_instance = new Logger(); 

	Logger * Logger::getInstance(){
		return _instance;
	}

#if defined(ANDROID) || defined(__ANDROID__)


	int ConvertToAndroidLevel(int level){
		if ( level =  LEVEL_NOTICE ) return  ANDROID_LOG_VERBOSE;
		if ( level =  LEVEL_DEBUG ) return   ANDROID_LOG_DEBUG;
		if ( level =  LEVEL_TRACE 	) return ANDROID_LOG_INFO;
		if ( level =  LEVEL_WARNING ) return ANDROID_LOG_WARN;
		if ( level =  LEVEL_ERROR 	) return ANDROID_LOG_ERROR;
		return ANDROID_LOG_DEBUG;
	}

	void Logger::log(int level, const char * fmt, ...){

		char __log_buf[1024] = {0};    
		va_list vargs;    
		va_start(vargs, fmt);    
		vsnprintf(__log_buf, sizeof(__log_buf) - 1, fmt, vargs);    
		va_end(vargs);

		__android_log_print(ConvertToAndroidLevel(level), "LLC-native",(const char*) __log_buf, NULL);
	}

#else


	void Logger::log(int level, const char * fmt, ...){
		
		char __log_buf[1024] = {0};    
		va_list vargs;    
		va_start(vargs, fmt);    
		vsnprintf(__log_buf, sizeof(__log_buf) - 1, fmt, vargs);    
		va_end(vargs);
		printf("%s\n", __log_buf);
	}

#endif


}
