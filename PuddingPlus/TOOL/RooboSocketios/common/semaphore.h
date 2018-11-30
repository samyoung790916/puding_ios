/*
 * semaphore.h
 *
 *  Created on: 2016年7月19日
 *      Author: zhouyuanjiang
 */

#ifndef ROOBO_SEMAPHORE_H_
#define ROOBO_SEMAPHORE_H_

#include "platform.h"
#include <semaphore.h>
#include <errno.h>
#include <sys/time.h>
#include <stdio.h>
#include "log.h"
#include "../common/utils.h"

#ifdef __APPLE__
#include <dispatch/dispatch.h>
#endif


namespace roobo {
    
    enum TimedWaitResult {
        kSuccess = 0 ,
        kTimeout = 1,
        kInvalid = 2
    };
    
    class Semaphore	{
        
    private:
        
#ifdef __APPLE__
        dispatch_semaphore_t sem_;
#else
        sem_t sem_;
#endif
        
    public:
        
        
        
        Semaphore(){
#ifdef __APPLE__
            sem_ = dispatch_semaphore_create(0);
#else
            sem_init (&sem_, 0, 0);
#endif
        }
        
        Semaphore(unsigned int value){
#ifdef __APPLE__
            sem_ = dispatch_semaphore_create(value);
#else
            sem_init (&sem_, 0, value);
#endif
        }
        
        virtual ~Semaphore(){
#ifdef __APPLE__
            //dispatch_release(sem_);
#else
            sem_destroy(&sem_);
#endif
        }
        
        void Wait(){
 #ifdef __APPLE__
            dispatch_wait(sem_, DISPATCH_TIME_FOREVER);
#else
            sem_wait(&sem_);
#endif
            
        }
        
        //
        // Wait with timeout
        // @param timeout_ms timeout in millisecond
        //
        TimedWaitResult TimedWait(int timeout_ms){
            
#ifdef __APPLE__
            dispatch_time_t timeout = dispatch_time(0, timeout_ms * 1000000);
            long ret = dispatch_wait(sem_, timeout);
            return ret == 0 ? kSuccess : kTimeout;
#else
            
            struct timespec ts;
            struct timeval tv;
            if(gettimeofday(&tv, NULL)){
                log_e("gettimeofday failed!!!");
            }
            
            long ns = (tv.tv_usec * 1000) +  (timeout_ms % 1000) * 1000000;
            int inc = ns / 1000000000;
            
            ts.tv_sec = inc + tv.tv_sec + timeout_ms / 1000;
            ts.tv_nsec = ns % 1000000000;
            
            int ret = sem_timedwait(&sem_, &ts);
            if(ret <  0){
                if(errno == ETIMEDOUT){
                    return kTimeout;
                }  
                log_d("%s err = %d, %s", __FILE__, errno,  strerror(errno));
            }
            
            return ret == 0 ? kSuccess: kInvalid;
            
#endif
            
        }
        
        //
        // Post signal
        //
        void Post(){
#ifdef __APPLE__
            dispatch_semaphore_signal(sem_);
#else
            sem_post(&sem_);
#endif
        }
    };
}

#endif /* ROOBO_SEMAPHORE_H_ */
