#ifndef MY_AUTH_1_H_
#define MY_AUTH_1_H_

#include "../common/buffer.h"
#include "../common/log.h"
#include "packet.h"

namespace roobo {

	namespace longliveconn {

		enum AuthCode
		{
			kContinue			= 0, // 继续下一个步骤
			kAuthenticated		= 1, // 验证完成
			kAuthFailed			= 2,
			kServerIsBusy		= 3,
			kSeverServerError    = 4,
			kUnexpected          = 5,
		};


		struct AuthResult
		{
			AuthCode code;
			CipherAlgorithm encryption_algorithm; // NULL means do not change
			Buffer encryption_key;

			CipherAlgorithm decryption_algorithm;// NULL means do not change
			Buffer decryption_key;	//  
			Packet * packet_to_send; // Packet to send to server

			AuthResult() 
				: code(kAuthFailed), encryption_algorithm (CA_PLAIN), decryption_algorithm(CA_PLAIN), packet_to_send(NULL){
			}		
		};


		//
		// Responsible for handshake and authentication
		//
		class Auth {

		public:
			virtual ~Auth(){}

			//
			// callback when handshake required
			// @return the packet send to server
			//
			virtual Packet * CreateHandshakePacket() = 0;

			//
			// The handshake response received, verify the response, and send auth packet if ok
			// @param packetReceived
			// @param packetToSend
			// @return AuthResult: to guide what to do next
			//
			virtual AuthResult * OnHandshakeResp(Packet * packetReceived, Packet ** packetToSend) = 0;

			//
			// The auth response from server, check if authentication passed
			// @param packetReceived
			// @return AuthResult: to guide what to do next
			//
			virtual AuthResult * OnAuthResp(Packet * packetReceived) = 0;

			//
			// Got called when heartbeat packet is needed
			// @return heartbeat packet
			//
			virtual Packet * GetHeartbeat() = 0;

			//
			// Rest inner state for new auth request
			//
			virtual void Reset() = 0;

		};
	}
}

#endif // MY_AUTH_1_H_