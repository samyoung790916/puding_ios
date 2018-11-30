#ifndef ROOBO_MESSAGE_EVENT_H_
#define ROOBO_MESSAGE_EVENT_H_

#include "../event.h"
#include "../../longliveconn/packet.h"
#include "../../common/log.h"

namespace roobo {

	namespace longliveconn {

		//
		// User sends a message
		//
		class MessageEvent : public Event
		{

		protected:
			Packet * packet_;
			PacketSendFlag flags_;

		public:
			MessageEvent(Packet * packet, PacketSendFlag flags) {
				flags_ = flags;
				packet_ = packet;
			}

			virtual ~MessageEvent(void);

			Packet * GetPacket() { return packet_; }

			virtual int GetEventCode(){return EVENT_MESSAGE;}

			PacketSendFlag GetFlags(){return flags_;}
		};
	}
}
#endif // ROOBO_MESSAGE_EVENT_H_
