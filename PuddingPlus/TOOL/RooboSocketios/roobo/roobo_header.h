#ifndef ROOBO_ROOBO_HEADER_H_
#define ROOBO_ROOBO_HEADER_H_
#include "../longliveconn/header.h"
#include "roobo_types.h"
#include "../common/buffer.h"

namespace roobo {

#pragma pack(1)

	class RooboHeader : public longliveconn::Header
	{

	protected:	

		uint32_t magic_code_;	// magic code
		uint8_t protocol_version_; // in case of protocol upgrade
		uint8_t flags_;			 // error, additional information 
		uint8_t category_; // business category 
		uint8_t format_; // body data format
		uint64_t sn_;		// packet unique sn
		uint16_t body_len_; // body length (exclude length of head)

		static uint64_t sn_seed_;

		uint64_t GetSn();

		friend class RooboPacket;

	public:

		RooboHeader(uint64_t sn, uint8_t flags, uint8_t category, uint16_t body_len);

		RooboHeader(uint8_t flags, uint8_t category, uint16_t body_len);

		RooboHeader(void);

		RooboHeader(const void * data, int size);

		RooboHeader(const RooboHeader & header);

		explicit RooboHeader(uint64_t sn);

		virtual ~RooboHeader(void);

		// Get fxied header size
		virtual int GetSize();

		// Parse header
		virtual bool Parse(const void * data, int size);

		// Wether this is a ping packet
		virtual bool IsHeartbeat();

		virtual uint16_t GetBodyLen(); 

		virtual void SetBodyLen(uint16_t len);

		virtual void Clear();

		virtual void Deserialize(Buffer * buffer);

		virtual void Serialize(Buffer * buffer);

		virtual void SetFlags(int flag);
		
		virtual uint8_t GetCategory();

		virtual void Dump();
	};

#pragma pack()

}
#endif // ROOBO_ROOBO_HEADER_H_
