#ifndef ROOBO_PACKET_FACTORY_H_
#define ROOBO_PACKET_FACTORY_H_
#include "../common/mutex.h"
#include "../common/guard.h"
#include "../longliveconn/data_types.h"
#include "roobo_packet.h"

namespace roobo {

	class RooboPacketFactory
	{

	protected:
		
		static RooboPacketFactory * _instance;

		RooboPacketFactory(void);

	public:

		virtual ~RooboPacketFactory(void);

		// TODO: multiple threading unsafe
		static RooboPacketFactory * GetInstance();

		RooboPacket * GetPacket();
		
		RooboPacket * GetPacket(void * data, int len);

		RooboPacket * GetPacket(uint8_t flags, uint8_t category, void * data, int len);

		RooboPacket * GetPacket(uint64_t sn, uint8_t flags, uint8_t category, void * data, int len);
		
		RooboPacket * GetPacket(RooboPacket * packet);

		void RecyclePacket(longliveconn::Packet ** packet);
	};
}

#endif // ROOBO_PACKET_FACTORY_H_
