#include "utils.h"
#include "log.h"
#include <time.h>

#ifdef __APPLE__
#include <mach/clock.h>
#include <mach/mach.h>
#endif

namespace roobo {

	long get_monotonic_time(){
        
#ifdef __APPLE__
     
        clock_serv_t cclock;
        mach_timespec_t mts;
        host_get_clock_service(mach_host_self(), SYSTEM_CLOCK, &cclock);
        clock_get_time(cclock, &mts);
        mach_port_deallocate(mach_task_self(), cclock);
        return mts.tv_sec * 1000 + mts.tv_nsec /1000000;
#else
		struct timespec ts = {0};
		clock_gettime(CLOCK_MONOTONIC, &ts);
		return ts.tv_sec * 1000 + ts.tv_nsec / 1000000;
#endif
	}

	void dump_hex(void * data, int len, const char * file, int line, const char * msg){

		static char hexs [16] = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};

		if(data == NULL || len <= 0 || file == NULL || msg == NULL){
			return;
		}

		char * p = (char*)data;

		char * str = new char[len * 2 + 1];

		str[len * 2 ] = '\0';

		for(int i = 0; i< len; i++){
			int v = (int)(unsigned char)p[i];
			str[2 * i + 1] =   hexs[v % 16];
			str[2 * i] = hexs[(v >> 4)];
		}

		log_d("%s %s:%d len %d %s", msg, file, line, len, str);

		delete[] str;
	}

		// Fill string with randmized decimal digits and letters 
	void rand_digit_and_letter(char * str, int size){
		
		static int rand_range[] = {48, 57, 65, 90, 97, 122};

		if(NULL == str){
			return;
		}
		
		for(int i = 0; i < size; i++){
			 
			int array_index = rand() % 3;

            int floor = rand_range[array_index * 2];

            int ceil = rand_range[array_index * 2 + 1];
 
			str[i] = floor + ( rand() % (ceil - floor) );
		}
	}


	void rand_bytes(unsigned char * data, int offset, int size){

		if(data == NULL){
			return;
		}

		for(int i = 0; i<size; i++){
			data[offset + i ] = rand() & 0xFF;
		}
	}
}