#ifndef ROOBO_LLC_DATA_TYPES_H__
#define ROOBO_LLC_DATA_TYPES_H__

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <string.h>

#define RB_FREE_MEM_ONLY(x) if(x != NULL){delete x;}

#define RB_FREE(x) if(x != NULL){delete x; \
	x = NULL;}

#define RB_FREE_ARR(x) if(x != NULL) {delete[] x; \
	x = NULL;}

#define SERVER_ADDRESS_MAX_LEN 256

#define HAS_FLAG(v, f) ( (v & f) == f )

#define HI64(x) (uint32_t(x >> 32))
#define LO64(x) (uint32_t(x & 0xFFFFFFFF))

#define CONNECT_TIMEOUT			   10000	// socket connet timeout in millisecond
#define PACKET_TIMEOUT			    5000	// normal packet timeout in millisecond
#define USER_PACKET_TIMEOUT		   10000	// user packet timeout in millisecond
#define PING_TIMEOUT			   30000	// ping timeout in millisecond

namespace roobo {

	namespace longliveconn {

		enum NetworkType{
			kUnknown =   1,
			k2G =		 2,
			k3G =		 3,
			k4G =		 4,
			kWiFi	=    5,
			kEthernet   = 6
		};
 
		enum CipherAlgorithm {
			CA_PLAIN = 0,				// no encryption at all
			CA_BLOWFISH = 1,			// Blowfish CBC
			CA_AES = 2,
			CA_RSA = 3
		};


		struct NetworkInfo {
			bool Available; // If network is available
			NetworkType  NetType;	// NetType Unknown, Ethernet, Wi-Fi, 2G, 3G, 4G,
			int  SubType;	// more detailed 

			NetworkInfo() :Available(false),  NetType(kUnknown), SubType(0){

			}

			NetworkInfo(bool available, NetworkType net_type) :Available(available),  NetType(net_type), SubType(0){

			}
		};

		enum PacketResult
		{
			kPR_OK = 0,
			kPR_Timeout = 1,
			kPR_Failed = 2
		};

		enum PacketSendFlag{
			kNone      =	0,
			kExpectAck =		1 << 0, // There will be response/ack for the packet
			kResendOnFailure =	1 << 1, // If failure re-send once established again
			kResultReport =		1 << 2 // Report of send result: success, failure, timeout etc
		};

		inline PacketSendFlag operator|(PacketSendFlag a, PacketSendFlag b)
		{return static_cast<PacketSendFlag>(static_cast<int>(a) | static_cast<int>(b));}

		// LongLiveConnection state
		enum StateName{
			STATE_DISCONNECTED  = 0, // Disconnected from server
			STATE_CONNECTING  = 1, // Connecting to server
			STATE_AUTHENTICATING = 2, // Doing handshake and authentication
			STATE_ESTABLISHED = 3, // Connection established
			STATE_INVALID = -1
		};


		class ServerAddress{

		public:
			char address[SERVER_ADDRESS_MAX_LEN];
			int port;

		public:
			ServerAddress(){
				memset(address, 0, sizeof(char) * SERVER_ADDRESS_MAX_LEN);
				port = 0;
			}

			ServerAddress(const char * str, int port1){
				memset(address, 0, sizeof(char) * SERVER_ADDRESS_MAX_LEN);
				this->port = port1;
				int i = 0;
				for(; i<SERVER_ADDRESS_MAX_LEN - 1; i++){
					address[i] = str[i];
					if(str[i] == '\0'){
						break;
					}
				}

				if(i == SERVER_ADDRESS_MAX_LEN - 1){
					address[SERVER_ADDRESS_MAX_LEN -1 ] = '\0';
				}
			}


			ServerAddress(const char * str, int host_len,  int port){

				memset(address, 0, sizeof(char) * SERVER_ADDRESS_MAX_LEN);

				this->port = port;

				int i = 0;

				for(; i < SERVER_ADDRESS_MAX_LEN - 1 && i < host_len; i++){
					address[i] = str[i];
					if(str[i] == '\0'){
						break;
					}
				}

				if(i == SERVER_ADDRESS_MAX_LEN - 1){
					address[SERVER_ADDRESS_MAX_LEN -1 ] = '\0';
				}
			}

			ServerAddress & operator= (ServerAddress & sa){
				port = sa.port;
				int i = 0;
				for(; i<SERVER_ADDRESS_MAX_LEN; i++){
					address[i] = sa.address[i];
				}
				return *this;
			}

			ServerAddress (const ServerAddress & sa){
				port = sa.port;
				int i = 0;
				for(; i<SERVER_ADDRESS_MAX_LEN; i++){
					address[i] = sa.address[i];
				}
			}

			void dump(){
				//log_d("%s:%d", address, port);
			}
		};


	}
}


#endif // ROOBO_LLC_DATA_TYPES_H__