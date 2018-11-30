#include "blowfish_cipher.h"
#include "../common/log.h"
#include "../common/utils.h"
#include "../thirdparty/cryptography/opensslbf/blowfish.h"
#include <memory.h>


#if defined(ANDROID) || defined(__ANDROID__)
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <linux/socket.h>
#include <sys/socket.h>
#endif

namespace roobo{

	namespace cryptography {

		BlowfishCipher::BlowfishCipher(roobo::Buffer * key)
		{
			key_size_ = key->size();
			key_ = new char[key_size_];
			memcpy(key_, key->data(), key_size_ * sizeof(char));	
		}

		bool BlowfishCipher::DoEncrypt(char* input, char * output, int size){
			if (input == NULL || size == 0 || size % 8 != 0) {
				return false;
			}

			::BF_KEY bfKey;
			::BF_set_key(&bfKey, key_size_, (const unsigned char*)key_);
			unsigned char ivec[8] = {0};

			::BF_cbc_encrypt((unsigned char*)input, (unsigned char*)output, size, &bfKey, ivec, BF_ENCRYPT);

			return true;
		}



		bool BlowfishCipher::Encrypt(roobo::Buffer * input){

			if(NULL == input ){
				return false;
			}

			int rem = input->size() % 8;
			if(rem > 0){
				//DUMP_HEX_EX("PRE-PADDING", input->data(), input->size());
				int n_pading = 8 - rem;
				input->EnsureCapacity(input->size() + n_pading);

				char * p = input->data() + input->size();
				memset(p, 0, n_pading);
				input->GrowSize(n_pading);

				//DUMP_HEX_EX("POST-PADDING", input->data(), input->size());
			}

			::roobo::Buffer output(input->size());

			bool ret = this->DoEncrypt(input->data(), output.data(), input->size()); 
			input->Assign(output.data(), input->size());

			//log_d("POST ENCRYPT, ret = %d", ret);
			// DUMP_HEX(input->data(), input->size());

			return ret;
		}

		bool BlowfishCipher::Decrypt(roobo::Buffer * input) {

			if(NULL == input || input->size() % 8 != 0){
				return false;
			}

			int size = input->size();

			//DUMP_HEX_EX("PRE-DECRYPT", input->data(), input->size());

			::roobo::Buffer output(input->size());

			::BF_KEY bfKey;
			::BF_set_key(&bfKey, key_size_, (const unsigned char*)key_);
			unsigned char ivec[8] = {0};

			::BF_cbc_encrypt((unsigned char*)input->data(), (unsigned char*)output.data(), size, &bfKey, ivec, BF_DECRYPT);

			input->Assign(output.data(), input->size());

			//DUMP_HEX_EX("POST-DECRYPT", input->data(), input->size());

			return true;
		}

		BlowfishCipher::~BlowfishCipher(void){
			RB_FREE_ARR(key_);
		}
	}
}