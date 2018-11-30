#ifndef ROOBO_TEST_FILE_H_
#define ROOBO_TEST_FILE_H_

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <errno.h>
#include "../common/log.h"


class ComplexStruct
{
private:
	int * cnt;

public:

	uint64_t f0;
	uint64_t f1;
	uint64_t f2;
	uint64_t f3;
	uint64_t f4;


	ComplexStruct(int * count) : cnt(count){
		f0 = ((uint64_t)rand()) << 32 | rand();
		f1 = ((uint64_t)rand()) << 32 | rand();
		f2 = ((uint64_t)rand()) << 32 | rand();
		f3 = ((uint64_t)rand()) << 32 | rand();
		f4 = f0 + f1 + f2 + f3;
		*cnt = *cnt +1;
	}

	virtual ~ComplexStruct(){
		*cnt = *cnt -1;
	}

	bool IsValid(){
		return (f4 == (f0 + f1 + f2 + f3));
	}

	void dump(){
		log_d("0x%08x 0x%08x%08x 0x%08x%08x 0x%08x%08x 0x%08x%08x",
			this,
			(f0 >> 32), (f0 & 0xFFFFFFFF),
			(f1 >> 32), (f1 & 0xFFFFFFFF),
			(f2 >> 32), (f2 & 0xFFFFFFFF),
			(f3 >> 32), (f3 & 0xFFFFFFFF)
			);
	}
};


void testBlockQueue();

void testlist();

void testMap();

void blowfishCipherTest();

void testLongLiveApi();


#endif // ROOBO_TEST_FILE_H_