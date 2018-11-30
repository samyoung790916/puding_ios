#ifndef __ROOBO_AUTH_INFO_H__
#define __ROOBO_AUTH_INFO_H__

#include "../longliveconn/data_types.h"
#include "../common/platform.h"

#define COPY_AUTH_INFO_FIELD(x, max) \
	int x##_len = strlen(x); \
	assert(x##_len > 0); \
	int x##_size = x##_len > max - 1 ? max - 1: x##_len;\
	memcpy(x##_, x, x##_size); \
	x##_[x##_size] = '\0'

#define AUTH_TYPE_USER "user"
#define AUTH_TYPE_DEVICE "device"

namespace roobo {

	class AuthInfo{

	public:

		const static int kMaxFieldSize = 64;

		const static int kMaxPublicKeySize = 512;


		/***
		* Construct AuthInfo for app
		* @param client_id
		* @param public_key
		* @param token
		* */
		AuthInfo(const char *  client_id, const char * public_key, const char * token) 
			: auth_type_(AUTH_TYPE_USER)
		{
			COPY_AUTH_INFO_FIELD(client_id, kMaxFieldSize);

			COPY_AUTH_INFO_FIELD(public_key, kMaxPublicKeySize);

			COPY_AUTH_INFO_FIELD(token, kMaxFieldSize);
		}

		/***
		* Construct AuthInfo for main control/robot
		* @param client_id
		* @param public_key
		* */
		AuthInfo(const char *  client_id, const char * public_key) 
			: auth_type_(AUTH_TYPE_DEVICE)
		{
			COPY_AUTH_INFO_FIELD(client_id, kMaxFieldSize);

			COPY_AUTH_INFO_FIELD(public_key, kMaxPublicKeySize);

			memset(token_, 0, sizeof(char) * kMaxFieldSize);
		}


		const char * GetAuthType() {
			return auth_type_;
		}

		const char *  GetClientId() {
			return client_id_;
		}

		const char * GetPublicKey(){
			return public_key_;
		}

		const char * GetToken(){
			return token_;
		}

		void SetToken(const char * token){

			if(token == NULL){
				return;
			}

			memset(token_, 0, sizeof(char) * kMaxFieldSize);

			int index = 0;

			while(token[index] != '\0' && index < kMaxFieldSize -1){
				token_[index] = token[index];
				index++;
			}
		}

		char token_[kMaxFieldSize];

		// auth type: for android/ios/winphone APP, use "user"
		// for puddings/croobo/J2/T1, use "device"
		const char * auth_type_;

		// client id
		char client_id_[kMaxFieldSize];

		char public_key_[kMaxPublicKeySize];
	};
}

#endif // __ROOBO_AUTH_INFO_H_