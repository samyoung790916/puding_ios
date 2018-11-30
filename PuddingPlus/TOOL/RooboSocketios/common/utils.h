#ifndef ROOBO_UTILS_H_
#define ROOBO_UTILS_H_

namespace roobo {

#define DUMP_HEX(data, len) ::roobo::dump_hex((void*)data, len, __FILE__, __LINE__)
#define DUMP_HEX_EX(msg, data, len) ::roobo::dump_hex((void*)data, len, __FILE__, __LINE__, msg)

	//
	// Get system time since boot in millisecond
	//
	long get_monotonic_time();


	void dump_hex(void * data, int len, const char * file, int line, const char * msg = "dump_hex");

	// Fill string with randmized decimal digits and letters 
	void rand_digit_and_letter(char * str, int size);

	// Fill data with randomized data
	void rand_bytes(unsigned char * data, int offset, int size);
}

#endif // ROOBO_UTILS_H_