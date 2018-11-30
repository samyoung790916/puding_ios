#include "cipher_factory.h"
#include "blowfish_cipher.h"
#include "rsa_cipher.h"
#include "aes_cipher.h"
#include "plain_cipher.h"
#include <string.h>

namespace roobo {

	namespace cryptography {

		CipherFactory::CipherFactory(void)
		{
		}

		CipherFactory::~CipherFactory(void)
		{
		}


		Cipher * CipherFactory::GetCipher(longliveconn::CipherAlgorithm  algorithm, Buffer * key){
			if(algorithm == longliveconn::CA_BLOWFISH){
				return new BlowfishCipher(key);
			} else if(algorithm == longliveconn::CA_RSA){
				return new RSACipher(key);
			} else if(algorithm == longliveconn::CA_AES) {
				return new AESCipher(key);
			}

			return new PlainCipher();
		}

		CipherFactory * CipherFactory::instance = new CipherFactory();

	}
}