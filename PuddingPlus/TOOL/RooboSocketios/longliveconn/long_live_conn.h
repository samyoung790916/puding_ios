//
// header to export data structure and functional API
//

#ifndef ROOBO_LONGLIVE_CONN_H_
#define ROOBO_LONGLIVE_CONN_H_

#include "data_types.h"
#include "stream.h"
#include "auth.h"

namespace roobo {

	namespace longliveconn {

		class LongLiveConn {

		public:

			virtual ~LongLiveConn(){}

			//
			// Get current network info
			//
			virtual NetworkInfo * GetNetworkInfo() = 0 ;

			//
			// Set current network info
			//
			virtual void SetNetworkInfo( NetworkInfo & networkInfo) = 0;

			//
			// Get Current stream
			//
			virtual Stream * GetCurrentStream() = 0;

			//
			// Setup new connection
			//
			virtual void SetupStream() = 0;


			virtual void ReportPacketResult(uint64_t sn, PacketResult result, Packet * packet)  = 0;

			//
			// Schedule a send task and sent it
			//
			virtual bool SendPacket(Packet * packet) = 0;


			virtual bool SendPacket(Packet * packet, PacketSendFlag flags) = 0;

			//
			// inner use do send packet to stream 
			//
			virtual bool DoSendPacket(Packet * packet) = 0;


			//
			// set up a schedule to connect later
			//
			virtual int ScheduleNextConnect() = 0;

			//
			// Send pending user packets, including the ones attempted to send
			//
			virtual bool SendPendingPacket() = 0;

			//
			// Send heartbeat packet 
			//
			virtual bool Ping() = 0;

			//
			// remove
			////
			virtual void RemovePendingPackets() = 0;

			// cipher for reading data
			virtual void SetDecryptionCipher(CipherAlgorithm  algorithm, Buffer * key) = 0;

			// cipher for writting data
			virtual void SetEncryptionCipher(CipherAlgorithm  algorithm, Buffer * key) = 0;

			virtual Auth * GetAuth() = 0;

			virtual void Shutdown() = 0;

		};
	}
}
#endif // ROOBO_LONGLIVE_CONN_H_

