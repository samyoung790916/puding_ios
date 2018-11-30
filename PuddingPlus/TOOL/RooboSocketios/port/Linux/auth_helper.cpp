#include "auth_helper.h"
#include <endian.h>
#include <unistd.h>
#include "../../roobo/roobo_packet_factory.h"
#include "../../roobo/roobo_packet.h"
#include "../../common/utils.h"
#include "../../roobo/roobo_types.h"
#include "../../cryptography/cipher_factory.h"
#include "../../network/multiplexio.h"
#include "../../thirdparty/jsmn/jsmn.h"
#include "../../common/utils.h"
#include "../../tpl/smart_ptr.h"

namespace roobo {
	namespace longliveconn {

		const char * AuthHelper::kAuthRequestFormat = "{\"type\":\"%s\",\"app\":{\"app\":\"%s\",\"via\":\"%s\",\"aver\":\"%s\",\"cver\":\"%s\",\"ch\":\"%s\"},\"production\":\"%s\",\"clientId\":\"%s\",\"secret\":\"%s\",\"nettype\":\"%s\",\"ipaddr\":\"127.0.0.1\"}";

		AuthHelper::AuthHelper(const roobo::ClientConfig & client_config, const roobo::AuthInfo & auth_info)
			: client_config_(client_config), auth_info_(auth_info), net_type_(kUnknown)
		{
			Reset();
		}

		AuthHelper::~AuthHelper(void)
		{

		}

		const char * AuthHelper::ConvertNetType(NetworkType net_type){

			if(net_type == k2G || net_type == k3G || net_type == k4G){
				return "Mobile";	
			} else if(net_type == kWiFi){
				return "Wifi";
			}  

			return "Other";
		}

		void AuthHelper::OnNetTypeChanged(NetworkType net_type){
			net_type_ = net_type;
		}

		//
		// callback when handshake required
		// @pamra context, context across handshake and auth process 
		//
		Packet * AuthHelper::CreateHandshakePacket(){

			Reset();

			roobo::Buffer key(auth_info_.GetPublicKey());
			key.ShrinkBack(1);

			// log_d("rand_key is %s", rand_key_);

			roobo::Buffer input(rand_key_);

			if(strcmp(auth_info_.GetAuthType(), AUTH_TYPE_USER) == 0){
				Guard guard(&token_mutex_);
				input = auth_info_.GetToken();
			}

			input.ShrinkBack(1);

			roobo::cryptography::Cipher * cipher = roobo::cryptography::CipherFactory::GetInstance()->GetCipher(CA_RSA, &key);
			tpl::SmartPtr<roobo::cryptography::Cipher> cipher_ptr(cipher);

			if(!cipher->Encrypt(&input)){
				mark();
				return NULL;
			}

			char terminator = '\0';
			input.Append(&terminator, 1);

			//DUMP_HEX_EX("ciphered text", input.data(), input.size());
			//log_d("ciphered text %s", input.data());

			char auth_str[256 + sizeof(ClientConfig)]= {0};
			//
			// "{"type":"%s","app":{"app":"%s","via":"%s","aver":"%s","cver":"%s","ch":"%s"},"production":"%s","clientId":"%s","secret":"%s","nettype":"%s","ipaddr":"127.0.0.1"}";
			//


			// TODO: do not hard code
			sprintf(auth_str, kAuthRequestFormat, 
				auth_info_.GetAuthType(),
				client_config_.GetApp(),
				client_config_.GetDevice(),
				client_config_.GetVersion(),
				client_config_.GetVersionCode(),
				client_config_.GetChannel(),
				client_config_.GetProduct(),
				auth_info_.GetClientId(),
				input.data(),
				ConvertNetType(net_type_));

			//log_d("auth string %s", auth_str);

			// uint8_t flags, uint8_t category, void * data, int len
			return roobo::RooboPacketFactory::GetInstance()->GetPacket(0, roobo::CATEGORY_REGISTER_REQ, auth_str, strlen(auth_str));
		}



		//
		// The handshake response received, verify the response, and send auth packet if ok
		//
		AuthResult * AuthHelper::OnHandshakeResp(Packet * packetReceived, Packet ** packetToSend){

			roobo::longliveconn::AuthResult * ar = new roobo::longliveconn::AuthResult();

			if(packetReceived == NULL){
				log_e("OnHandshakeResp packet is null");
				return ar;
			}

			roobo::Buffer & buffer = packetReceived->GetBody();

			char terminator = '\0';
			buffer.Append(&terminator, 1);

			// log_d("OnHandshakeResp %s", buffer.data());

			jsmn_parser json_parser;

			const unsigned int number_of_tokens = 15;
			const int token_buf_size = 1024;

			jsmntok_t tokens[number_of_tokens];

			jsmn_init(&json_parser);

			int token_count = jsmn_parse(&json_parser, buffer.data(), strlen(buffer.data()), tokens, number_of_tokens);
			if(token_count <= 0){
				log_d("HandshakeResp data is not in json format");
				return ar;
			}

			int auth_result_index =- 1; // token index
			int auth_result = 0;
			char auth_result_text[token_buf_size] = {0};

			int crypt_text_index = -1; // token index
			char crypt_text[token_buf_size] = {0};

			for(int i = 0; i< token_count; i++){

				int token_size = tokens[i].end - tokens[i].start;

				if(token_size > token_buf_size){
					log_e("token size is too  large %d", token_size);
					continue;
				}

				if(i == auth_result_index && tokens[i].type == JSMN_STRING){
					memcpy(auth_result_text, buffer.data() + tokens[i].start, token_size);
					auth_result = atoi(auth_result_text);
				} else if(i == crypt_text_index && tokens[i].type == JSMN_STRING){
					memcpy(crypt_text, buffer.data() + tokens[i].start, token_size);
				} else {

					char tmp[token_buf_size] = {0};

					memcpy(tmp, buffer.data() + tokens[i].start, token_size);

					if(strcmp("result", tmp) == 0 && tokens[i].type == JSMN_STRING){
						auth_result_index = i + 1;	
					} else if (strcmp("crypt", tmp) == 0 && tokens[i].type == JSMN_STRING){
						crypt_text_index = i + 1;
					}
				}
			}

			// log_d("crypt text %s, result %d", crypt_text, auth_result);

			if(auth_result != 0){
				return ar;
			}

			roobo::Buffer cipher_key(rand_key_);
			cipher_key.ShrinkBack(1);


			int token_len = strlen(auth_info_.GetToken());

			if(strcmp(auth_info_.GetAuthType(), AUTH_TYPE_USER) == 0){
				Guard guard(&token_mutex_);
				cipher_key.Assign((void*)auth_info_.GetToken(), token_len /*kAuthRandKeyLen*/ );	
			}

			roobo::cryptography::Cipher * cipher = roobo::cryptography::CipherFactory::GetInstance()->GetCipher(CA_AES, &cipher_key);
			tpl::SmartPtr<roobo::cryptography::Cipher> cipher_ptr(cipher);

			roobo::Buffer crypt_buff(crypt_text);
			crypt_buff.ShrinkBack(1);

			if(!cipher->Decrypt(&crypt_buff)){
				log_e("Failed to decode crypt text");
				return ar;
			}

			DUMP_HEX_EX("CIPHER_KEY", crypt_buff.data(), crypt_buff.size());

			ar->code = roobo::longliveconn::kAuthenticated;
			ar->decryption_algorithm = ar->encryption_algorithm = roobo::longliveconn::CA_BLOWFISH;
			ar->decryption_key = ar->encryption_key = crypt_buff;

			return ar;
		}


		//
		// The auth response from server, check if authentication passed
		//
		AuthResult  * AuthHelper::OnAuthResp(Packet * packetReceived){
			return NULL;
		}

		Packet * AuthHelper::GetHeartbeat(){
			long time = roobo::get_monotonic_time();
			return roobo::RooboPacketFactory::GetInstance()->GetPacket(0, roobo::CATEGORY_HEART_REQ, &time, sizeof(time));
		}

		//
		// Rest inner state for new auth request
		//
		void AuthHelper::Reset(){
			rand_digit_and_letter(rand_key_, kAuthRandKeyLen);
			rand_key_[kAuthRandKeyLen] = '\0';
		}

		void AuthHelper::UpdateToken(const char * token){
			if(NULL == token){
				return;
			}

			Guard guard(&token_mutex_);
			auth_info_.SetToken(token);
		}
	}
}
