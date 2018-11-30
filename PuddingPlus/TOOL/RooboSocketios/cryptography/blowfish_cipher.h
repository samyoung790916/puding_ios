#ifndef ROOBO_BLOWFISH_CIPHER_H_
#define ROOBO_BLOWFISH_CIPHER_H_

#include "cipher.h"

namespace roobo{

	namespace cryptography {

		class BlowfishCipher : public Cipher
		{

		protected: 

			bool DoEncrypt(char* input, char * output, int size);
			char * key_;
			int key_size_;

		public:

			explicit BlowfishCipher(roobo::Buffer * key);

			~BlowfishCipher(void);

			virtual bool Encrypt(roobo::Buffer * input);

			virtual bool Decrypt(roobo::Buffer * input);

			virtual longliveconn::CipherAlgorithm GetName() {return longliveconn::CA_BLOWFISH; }

		};

	}
}
#endif // ROOBO_BLOWFISH_CIPHER_H_