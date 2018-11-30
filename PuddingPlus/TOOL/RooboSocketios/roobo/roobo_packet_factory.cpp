
#include "roobo_packet_factory.h"
#include "../common/utils.h"

namespace roobo {

	RooboPacketFactory * RooboPacketFactory::_instance = new RooboPacketFactory();

	RooboPacketFactory::RooboPacketFactory(void)
	{
		 
	}

	RooboPacketFactory::~RooboPacketFactory(void)
	{

	}

	RooboPacketFactory * RooboPacketFactory::GetInstance(){
		return _instance;
	}



	RooboPacket * RooboPacketFactory::GetPacket(){
		RooboPacket * packet = new RooboPacket();
		return packet;
	}


	RooboPacket * RooboPacketFactory::GetPacket(void * data, int len){
		RooboPacket * packet = new RooboPacket(data, len);
		return packet;
	}


	RooboPacket * RooboPacketFactory::GetPacket(RooboPacket * packet){
		if(NULL == packet){
			return NULL;
		}

		RooboPacket * packet_obj = new RooboPacket();
		*packet_obj =  *packet;
		return packet_obj;
	}

	RooboPacket * RooboPacketFactory::GetPacket(uint8_t flags, uint8_t category, void * data, int len){
		return new RooboPacket(flags, category, data, len);
	}

	RooboPacket * RooboPacketFactory::GetPacket(uint64_t sn, uint8_t flags, uint8_t category, void * data, int len){
		return new RooboPacket(sn, flags, category, data, len);
	}


	void RooboPacketFactory::RecyclePacket(longliveconn::Packet ** packet){
		if(NULL == packet || NULL == *packet){
			return;
		}

		/*
		uint64_t sn = (*packet)->GetSn();
		uint32_t hi = HI64(sn);
		uint32_t lo = LO64(sn);
		log_d("%s delete packet 0x%08x%08x ", __FILE__, hi, lo);
		*/

		delete *packet;
		*packet = NULL;
	}
}