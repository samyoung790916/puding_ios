#include "rsa_cipher.h"
#include <string.h>
#include "../common/log.h"
#include "../thirdparty/cryptography/mbedtls/include/mbedtls/base64.h"


namespace roobo {
	namespace cryptography {

#define MAX_RSA_PUB_KEY_SIZE 1024
#define MAX_RSA_BUF_SIZE 1024

		RSACipher::RSACipher(roobo::Buffer * key)
		{
			Init(key);
		}

		bool RSACipher::Init(roobo::Buffer * key){

			mbedtls_pk_init( &pk_ );
			mbedtls_entropy_init( &entropy_ );
			mbedtls_ctr_drbg_init(&ctr_drbg_);

			if(key == NULL){
				mark();
				return false;
			}

			int ret = 0;

			const char * header = "-----BEGIN PUBLIC KEY-----\n";
			const char * footer = "\n-----END PUBLIC KEY-----";

			int header_len = strlen(header);
			int footer_len = strlen(footer);

			if((key->size() + header_len + footer_len + 1) > MAX_RSA_PUB_KEY_SIZE) {
				mark();
				return false;
			}

			unsigned char pubkey[MAX_RSA_PUB_KEY_SIZE] = {0};

			memcpy(&pubkey[0], header, header_len);
			memcpy((&pubkey[0]) + header_len, key->data(), key->size());
			memcpy((&pubkey[0]) + (header_len + key->size()), footer, footer_len);

			// log_d("merged pub key %s", pubkey);

			ret = mbedtls_pk_parse_public_key( &pk_, (const unsigned char *)pubkey, 
				(size_t) (key->size() + footer_len + header_len + 1));

			if( ret != 0 )
			{
				log_e( " failed\n  ! mbedtls_pk_parse_public_key returned -0x%04x\n", -ret );
			}

			const char * personalization = "roobo_app_specific";

			ret = mbedtls_ctr_drbg_seed( &ctr_drbg_, mbedtls_entropy_func, &entropy_,
				(const unsigned char *) personalization,
				strlen( personalization ) );
			if( ret != 0){
				log_e("mbedtls_ctr_drbg_seed failed, return %d\n", ret);

			}

			return true;

		}


		RSACipher::~RSACipher(void)
		{
			mbedtls_ctr_drbg_free(&ctr_drbg_);
			mbedtls_entropy_free( &entropy_ );
			mbedtls_pk_free(&pk_);
		}

		bool RSACipher::Encrypt(roobo::Buffer * input){

			if(input == NULL){
				return false;
			}

			int ret = 0;
			unsigned char buf[MAX_RSA_BUF_SIZE] = {0};
			size_t olen = MAX_RSA_BUF_SIZE;

			if( ( ret = mbedtls_pk_encrypt( &pk_, (const unsigned char*)input->data(), input->size(),
				buf, &olen, sizeof(buf),
				mbedtls_ctr_drbg_random, &ctr_drbg_ ) ) != 0 )
			{
				log_e( " failed\n  ! mbedtls_pk_encrypt returned -0x%04x\n", -ret );
				return false;
			}

			unsigned char base64_buf[MAX_RSA_BUF_SIZE * 2] = {0};

			size_t base64_out_len = 0;

			// TODO: evil, violates SRP 
			ret = mbedtls_base64_encode(base64_buf, MAX_RSA_BUF_SIZE * 2, &base64_out_len, buf, olen);
			if(ret != 0){
				log_e( " failed\n  ! mbedtls_base64_encode returned -0x%04x\n", -ret );
				return false;
			}

			input->Assign(base64_buf, base64_out_len);

			return true;
		}

		bool RSACipher::Decrypt(roobo::Buffer * input){
			return false;
		}
	}
}