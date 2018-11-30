#ifndef ROOBO_CIPHER_FACTORY_H_
#define ROOBO_CIPHER_FACTORY_H_

#include "cipher.h"
#include "../common/buffer.h"
#include "../common/guard.h"
#include "../common/mutex.h"
#include "../longliveconn/data_types.h"

namespace roobo {

	namespace cryptography {

		class CipherFactory
		{

		protected:
			static CipherFactory * instance;
			CipherFactory(void);

		public:

			virtual ~CipherFactory(void);	

			Cipher * GetCipher(longliveconn::CipherAlgorithm algorithm, Buffer * key);	

			void RecycleCipher(Cipher ** cipher){
				if(cipher && *cipher){
					delete * cipher;
					*cipher = 0;
				}
			}

			static CipherFactory * GetInstance(){
				return instance;
			}
		};

	}
}

#endif // ROOBO_CIPHER_FACTORY_H_

