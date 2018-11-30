#ifndef ROOBO_CIPHER_H_
#define ROOBO_CIPHER_H_


#if defined(ANDROID) || defined(__ANDROID__)
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <linux/socket.h>
#include <sys/socket.h>
#endif

#include "../common/buffer.h"
#include "../longliveconn/data_types.h"

namespace roobo{

	namespace cryptography {

		class Cipher
		{

		public:

			virtual ~Cipher(void){}

			virtual bool Encrypt(roobo::Buffer * input) = 0;

			virtual bool Decrypt(roobo::Buffer * input) = 0;

			virtual longliveconn::CipherAlgorithm GetName() = 0;

		};

	}
}


#endif // ROOBO_CIPHER_H_

