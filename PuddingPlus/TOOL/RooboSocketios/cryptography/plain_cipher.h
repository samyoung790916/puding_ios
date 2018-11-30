#ifndef ROOBO_PLAIN_CIPHER_H_
#define ROOBO_PLAIN_CIPHER_H_

#include "cipher.h"

namespace roobo {

	namespace cryptography {

		class PlainCipher : public Cipher
		{
		public:

			PlainCipher(void);

			virtual ~PlainCipher(void);

			virtual bool Encrypt(roobo::Buffer * input);

			virtual bool Decrypt(roobo::Buffer * input);

			virtual longliveconn::CipherAlgorithm GetName() {return longliveconn::CA_PLAIN; }
		};
	}
}
#endif // ROOBO_PLAIN_CIPHER_H_