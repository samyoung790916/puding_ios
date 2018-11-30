#ifndef ROOBO_RSA_CIPHER_H_
#define ROOBO_RSA_CIPHER_H_

#include "cipher.h"

#include "../thirdparty/cryptography/mbedtls/include/mbedtls/rsa.h"
#include "../thirdparty/cryptography/mbedtls/include/mbedtls/entropy.h"
#include "../thirdparty/cryptography/mbedtls/include/mbedtls/ctr_drbg.h"
#include "../thirdparty/cryptography/mbedtls/include/mbedtls/pk.h"

namespace roobo {
	namespace cryptography {

		class RSACipher : public Cipher
		{

		private:
			mbedtls_pk_context pk_;
			mbedtls_entropy_context entropy_;
			mbedtls_ctr_drbg_context ctr_drbg_;

			bool Init(roobo::Buffer * key);

		public:
			
			explicit RSACipher(roobo::Buffer * key);

			virtual ~RSACipher(void);

			//
			// Encrypt data, update with base64 encoded bytes
			//
			virtual bool Encrypt(roobo::Buffer * input);

			virtual bool Decrypt(roobo::Buffer * input);

			virtual longliveconn::CipherAlgorithm GetName() {return longliveconn::CA_RSA;}
		};

	}

}

#endif // ROOBO_RSA_CIPHER_H_


