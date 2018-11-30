#ifndef _ROOBO_LINUX_AUTH_HELPER_H_
#define _ROOBO_LINUX_AUTH_HELPER_H_

#include "../../longliveconn/auth.h"
#include "../../roobo/client_config.h"
#include "../../roobo/auth_info.h"
#include "../../common/guard.h"

namespace roobo {
	namespace longliveconn {

		// Auth rand key fixed length
		const static int kAuthRandKeyLen = 16;

		class AuthHelper : public roobo::longliveconn::Auth
		{

		private:
			
			roobo::ClientConfig client_config_;
			roobo::AuthInfo auth_info_;
			roobo::Mutex token_mutex_;
			
			NetworkType net_type_;

			const char * ConvertNetType(NetworkType net_type);

			char rand_key_[kAuthRandKeyLen + 1];

			static const char * kAuthRequestFormat;

		public:

	
			AuthHelper(const roobo::ClientConfig & client_config, const roobo::AuthInfo & auth_info);


			virtual ~AuthHelper(void);

			//
			// callback when handshake required
			// @return the packet send to server
			//
			virtual Packet * CreateHandshakePacket();

			//
			// The handshake response received, verify the response, and send auth packet if ok
			// @param packetReceived
			// @param packetToSend
			// @return AuthResult: to guide what to do next
			//
			virtual AuthResult * OnHandshakeResp(Packet * packetReceived, Packet ** packetToSend);

			//
			// The auth response from server, check if authentication passed
			// @param packetReceived
			// @return AuthResult: to guide what to do next
			//
			virtual AuthResult * OnAuthResp(Packet * packetReceived);

			//
			// Got called when heartbeat packet is needed
			// @return heartbeat packet
			//
			virtual Packet * GetHeartbeat();

			//
			// Rest inner state for new auth request
			//
			virtual void Reset();

			void UpdateToken(const char * token);

			void OnNetTypeChanged(NetworkType net_type);
		};
	}
}
#endif // _ROOBO_LINUX_AUTH_HELPER_H_

