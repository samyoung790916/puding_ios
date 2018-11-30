#ifndef MY_PACKET_RECEIVED_EVENT_H_
#define MY_PACKET_RECEIVED_EVENT_H_

#include "../event.h"
#include "../../longliveconn/packet.h"

namespace roobo {

	namespace longliveconn {

		class PacketReceivedEvent : public Event
		{

		protected:
			Packet * packet_;

		public:

			explicit PacketReceivedEvent(Packet * packet) : packet_(packet){
			}

			virtual ~PacketReceivedEvent(void);

			Packet * GetPacket(){return packet_;}

			int GetEventCode() {return EVENT_PACKET_RECEIVED;}
		};

	}
}

#endif // MY_PACKET_RECEIVED_EVENT_H_

