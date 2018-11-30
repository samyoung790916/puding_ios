#ifndef ROOBO_ROOBO_PACKET_H_
#define ROOBO_ROOBO_PACKET_H_

#include "../longliveconn/packet.h"
#include "../common/mutex.h"
#include "../common/guard.h"

namespace roobo {

	class RooboPacket : public roobo::longliveconn::Packet
	{

	public:

		RooboPacket();

		// Convert packet from binary
		RooboPacket(void * data, int len);

		RooboPacket(uint64_t sn, uint8_t flags, uint8_t category, void * body, uint16_t body_len);

		RooboPacket(uint8_t flags, uint8_t category, void * body, uint16_t body_len);

		RooboPacket(const RooboPacket & packet);

		RooboPacket & operator = (RooboPacket & packet);

		virtual ~RooboPacket(void);

		virtual void Deserialize(Buffer * buffer);

		virtual void Serialize(Buffer * buffer);

		virtual uint64_t GetSn();

	};

}


#endif // ROOBO_ROOBO_PACKET_H_

