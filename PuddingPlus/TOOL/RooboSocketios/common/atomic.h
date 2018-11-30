#ifndef ROOBO_ATOMIC_H_
#define ROOBO_ATOMIC_H_

#include "platform.h"

#define fetch_and_add __sync_fetch_and_add

#define fetch_and_sub __sync_fetch_and_sub

#define add_and_fetch __sync_add_and_fetch

#define sub_and_fetch __sync_sub_and_fetch

#endif // ROOBO_ATOMIC_H_
