#include "plain_cipher.h"
#include <memory.h>

namespace roobo {

	namespace cryptography {

		PlainCipher::PlainCipher(void)
		{
		}


		PlainCipher::~PlainCipher(void)
		{
		}


		bool PlainCipher::Encrypt(roobo::Buffer * input){
			if(!input|| input->size() == 0){
				return false;
			}

			return true;
		}

		bool PlainCipher::Decrypt(roobo::Buffer * input){

			if(!input || input->size() == 0){
				return false;
			}

			return true;
		}
	}
}