#ifndef PACKET_TIMEOUT_EVNET_H_
#define PACKET_TIMEOUT_EVNET_H_
#include "../event.h"

namespace roobo {

	namespace longliveconn {

		class PacketTimeoutEvent :	public Event
		{
		protected:
			bool is_user_packet_;
			uint64_t sn_;

		public:

			PacketTimeoutEvent(bool is_user_packet, uint64_t sn);

			virtual ~PacketTimeoutEvent(void);

			virtual int GetEventCode() {return EVENT_PACKET_TIMEOUT;}

			bool IsUserPacket(){return is_user_packet_;}

			u_int64_t GetSn(){return sn_;}
		};
	}
}

#endif // PACKET_TIMEOUT_EVNET_H_