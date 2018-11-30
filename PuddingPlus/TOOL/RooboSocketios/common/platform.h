/*
 * platform.h
 *
 *  Created on: July-19-2016
 *      Author: zhouyuanjiang
 */

#ifndef INCLUDE_PLATFORM_H_
#define INCLUDE_PLATFORM_H_

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <memory.h>

 
#include "unistd.h"
#include <sys/syscall.h>
#include <sched.h>

#if defined(__linux__)
#include <linux/futex.h>
#endif

#ifdef __ANDROID__
#include <malloc.h>

#define futex(uaddr, futex_op, val, timeout, uaddr2, val3) syscall(__NR_futex, uaddr, futex_op, val, timeout, uaddr2, val3)

__attribute__((weak)) int posix_memalign(void** pp, size_t align, size_t size)
{
    *pp = memalign(align, size);
    if (*pp == NULL) {
        return -1;
    }
    return 0;
}

#endif

 
#if defined(__arm__)

static __attribute__((unused)) inline const int16_t clip_int16(int a)
{
    int x;
    __asm__ ("ssat %0, #16, %1" : "=r"(x) : "r"(a));
    return x;
}

#else

static __attribute__((unused)) inline const int16_t clip_int16(int a)
{
    if ((a + 0x8000U) & (~0xFFFF)) {
        a = ((a >> 31) ^ 0x7FFF);
    }
    return a;
}

#endif


#if defined(__arm__)
    #define rb_abort() __asm__("bkpt 0")
#elif defined(__arm64__)
    #define rb_abort() __asm__("brk 0")
#elif defined(_MSC_VER)
    #define rb_abort() asm{"int 3"}
#else
    #define rb_abort() __asm__("int $3")
#endif


#if defined(_MSC_VER)

    #define barrier() __asm {nop}
    #define rmb() __asm {lfence}
    #define wmb() __asm {sfence}
    #define systid() ((uintptr_t) GetCurrentThreadId())

#else

    #if defined(__linux__)
        #define systid() ((uintptr_t) syscall(__NR_gettid))
    #elif defined(__APPLE__)
        #define systid() ((uintptr_t) syscall(SYS_thread_selfid))
    #endif

    #define barrier() __asm__ __volatile__("":::"memory")
    #if (defined(__arm__)) || (defined(__arm64__))
        #if (defined(__ARM_ARCH_7A__) || defined(__arm64__))
            #define rmb() __asm__ __volatile__ ("dsb sy":::"memory")
            #define wmb() __asm__ __volatile__ ("dsb sy":::"memory")
        #else
            #define rmb()
            #define wmb()
        #endif
    #else
        #define rmb() __asm__ __volatile__("lfence":::"memory")
        #define wmb() __asm__ __volatile__("sfence":::"memory")
    #endif

#endif


#endif /* INCLUDE_PLATFORM_H_ */
