#ifndef _ROOOBO_AES_CIPHER_H_
#define _ROOOBO_AES_CIPHER_H_

#include "cipher.h"

#include "../thirdparty/cryptography/mbedtls/include/mbedtls/aes.h"

namespace roobo {
	namespace cryptography {

		class AESCipher : public Cipher
		{

		private:

			mbedtls_aes_context aes_ctx_;
		    unsigned char iv_[16];
			bool init_success_;

			bool Init(roobo::Buffer * key);

		public:

			explicit AESCipher(roobo::Buffer * key);

			virtual ~AESCipher(void);

			virtual bool Encrypt(roobo::Buffer * input);

			virtual bool Decrypt(roobo::Buffer * input);

			virtual longliveconn::CipherAlgorithm GetName() {return longliveconn::CA_AES;}
		};

	}
}

#endif // _ROOOBO_AES_CIPHER_H_
