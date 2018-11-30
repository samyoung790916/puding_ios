
#include "aes_cipher.h"
#include "../common/log.h"
#include "../common/utils.h"
#include "../thirdparty/cryptography/mbedtls/include/mbedtls/base64.h"

namespace roobo {
	namespace cryptography {

		AESCipher::AESCipher(roobo::Buffer * buffer)
		{
			init_success_ = Init(buffer);
		}

		AESCipher::~AESCipher(void)
		{
			mbedtls_aes_free(&aes_ctx_);
		}

		bool AESCipher::Init(roobo::Buffer * key){

			mbedtls_aes_init(&aes_ctx_);

			if(key == NULL){
				return false;
			}

			int num_bits = key->size() * 8;

			log_e("num_bits %d", num_bits);

			log_e("key :%s", key->data());

			int ret = mbedtls_aes_setkey_dec( &aes_ctx_, (const unsigned char*)key->data(), num_bits);
			if(ret != 0){
				log_e( "%s failed ! mbedtls_aes_setkey_dec returned -0x%04x\n", __PRETTY_FUNCTION__, -ret );
				return false;
			}

			memset(iv_, 0, 16 * sizeof(unsigned char));

			return true;
		}


		bool AESCipher::Encrypt(roobo::Buffer * input){
			if(input == NULL || !init_success_){
				return false;
			}


			return false;
		}

		bool AESCipher::Decrypt(roobo::Buffer * input){

			if(input == NULL || !init_success_){
				return false;
			}

			bool result = false;

			int ret = 0;

			unsigned char * output = new unsigned char[input->size()];

			do{

				size_t base64_out_len = 0;
				ret = mbedtls_base64_decode(output, input->size(), &base64_out_len, (const unsigned char*)input->data(), input->size());

				if(ret != 0) {
					log_e( "%s failed! mbedtls_base64_decode returned -0x%04x\n", __PRETTY_FUNCTION__, -ret );		
					break;
				}

				input->Assign(output, base64_out_len);
				
				//DUMP_HEX_EX("POST-BASE64DECODE", input->data(), input->size());

				if(input->size() % 16 != 0){
					log_e("%s data must be multiple times of 16", __PRETTY_FUNCTION__);				
					break;
				}

				unsigned char * out = output;
				unsigned char * in  = (unsigned char *)input->data();

				for(int i = 0; i < input->size(); i += 16) {

					ret = mbedtls_aes_crypt_cbc( &aes_ctx_, MBEDTLS_AES_DECRYPT, 16, iv_, in, out );
					if(ret != 0){
						log_e("%s mbedtls_aes_crypt_cbc failed", __PRETTY_FUNCTION__);				
						break;
					}

					out += 16;
					in += 16;
				}

				input->Assign(output, input->size());

				result = true;

			}while(false);

			RB_FREE_ARR(output);

			return result;
		}
	}
}