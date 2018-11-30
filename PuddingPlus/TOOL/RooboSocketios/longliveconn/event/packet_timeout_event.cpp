#include "packet_timeout_event.h"

namespace roobo {

	namespace longliveconn {

		PacketTimeoutEvent::PacketTimeoutEvent(bool is_user_packet, uint64_t sn)
			: is_user_packet_(is_user_packet), sn_(sn)
		{
		}


		PacketTimeoutEvent::~PacketTimeoutEvent(void)
		{
		}

	}
}
