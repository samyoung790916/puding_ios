#ifndef ROOBO_LONG_LIVE_CONN_API_H_
#define ROOBO_LONG_LIVE_CONN_API_H_

#include "roobo_packet.h"
#include "../longliveconn/data_types.h"

//
// 1: callback to notify packet ack
// 2: callback to notify state change
// 3: callback to delivery received packet 
//
// 4: API list
//	Init the LongLiveConn
//	NotifyNetworkChange
//  SendPacket
//	Shutdown
//
// Auth implementation on Java side
//

namespace roobo {

	class LongLiveConnApi {

	public:

		virtual ~LongLiveConnApi(){}

		// Received a packet
		virtual void OnPacket(RooboPacket * packet) = 0;

		// State has changed
		virtual void OnStateChange(roobo::longliveconn::StateName old_state, roobo::longliveconn::StateName new_state) = 0;

		// promot of packet send result
		virtual void OnPacketResult(uint64_t sn, roobo::longliveconn::PacketResult result, roobo::longliveconn::Packet * packet) = 0;

		// send a packet
		virtual bool SendPacket(RooboPacket * packet, longliveconn::PacketSendFlag flags) = 0;

		// notify about network change
		virtual void NotifyNetworkChange(bool available, longliveconn::NetworkType net_type, int sub_type) = 0;

		virtual void Shutdown() = 0;

		 
		virtual void UpdateToken(const char * token) = 0;
	};
}

#endif // ROOBO_LONG_LIVE_CONN_API_H_