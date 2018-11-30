
#include "roobo_header.h"
#include "../common/log.h"
#include "../longliveconn/stream.h"
#include "../common/atomic.h"
#include <endian.h>
#include <stdio.h>
#include <stdlib.h>

#define ROOBO_HEADER_SIZE 18

namespace roobo {

	uint64_t RooboHeader::sn_seed_ = 0;

	RooboHeader::RooboHeader(uint64_t sn, uint8_t flags, uint8_t category, uint16_t body_len)
		: magic_code_(*((int*)&MAGIC)), protocol_version_(PROTOCOL_VERSION), flags_(flags), 
		category_(category), format_(MSG_FMT_JSON), sn_(sn), body_len_(body_len)
	{

	}

	RooboHeader::RooboHeader(uint8_t flags, uint8_t category, uint16_t body_len)
		: magic_code_(*((int*)&MAGIC)), protocol_version_(PROTOCOL_VERSION), flags_(flags), 
		category_(category), format_(MSG_FMT_JSON), sn_(GetSn()), body_len_(body_len)
	{

	}

	RooboHeader::RooboHeader(void)
		: magic_code_(*((int*)&MAGIC)), protocol_version_(PROTOCOL_VERSION), format_(MSG_FMT_JSON)
	{

	}


	RooboHeader::RooboHeader(uint64_t sn)
		: magic_code_(*((int*)&MAGIC)), protocol_version_(PROTOCOL_VERSION), format_(MSG_FMT_JSON), sn_(sn)
	{

	}

	RooboHeader::RooboHeader(const RooboHeader & header){ 
		memcpy(&magic_code_, &header.magic_code_, GetSize());
	}


	RooboHeader::RooboHeader(const void * data, int size){
		if(NULL == data || size < GetSize()){
			log_e("RooboHeader::Parse data is null or size is too small %d", size);
		} else {
			memcpy(&magic_code_, data, GetSize());
		}
	}

	RooboHeader::~RooboHeader(void)
	{
	}


	uint64_t RooboHeader::GetSn(){
		return add_and_fetch(&RooboHeader::sn_seed_, 2);
	}

	// Parse header
	bool RooboHeader::Parse(const void * data, int size){

		if(NULL == data || size < GetSize()){
			log_e("RooboHeader::Parse data is null or size is too smalle");
			return false;
		}

		memcpy(&magic_code_, data, GetSize());

		// compare magic
		if(strncmp(MAGIC, (const char*)&magic_code_, 4)){
			log_e("magic code mismatch expect %s, acutal [0x%08x]", MAGIC, magic_code_);
			return false;
		}

#ifdef __APPLE__
        body_len_ = ntohs(body_len_);
        
#else
        
		body_len_ = be16toh(body_len_);
#endif
		if( GetBodyLen() <0 ) {
			log_e("Body length is negative %d", GetBodyLen());
			return false;
		}

		return true;
	}

	void RooboHeader::Deserialize(Buffer * buffer){
		if(!buffer || buffer->size() < GetSize()){
			return;
		}	  
		memcpy(&magic_code_, buffer->data(), GetSize());
	}

	void RooboHeader::Serialize(Buffer * buffer){

		if(NULL == buffer){
			return;
		}

		buffer->EnsureCapacity(GetSize());	  
		buffer->GrowSize(GetSize());
		memcpy(buffer->data(), &magic_code_, GetSize() - 2);

		// log_d("RooboHeader::Serialize body size is %d", body_len_);

		uint16_t * p = (uint16_t*)(buffer->data() + (GetSize() - 2));

#ifdef __APPLE__
        *p = htons(body_len_);
#else
		*p = htobe16(body_len_);
#endif
		//log_d("RooboHeader::Serialize htobe16 body size is %d",  *p);
		p = NULL;
	}


	// Get fxied header size
	int RooboHeader::GetSize() {
		return ROOBO_HEADER_SIZE;
	}

	// Wether this is a ping packet
	bool RooboHeader::IsHeartbeat(){
		return (category_ == CATEGORY_HEART_REQ || category_ == CATEGORY_HEART_RESP);
	}

	uint16_t RooboHeader::GetBodyLen() {
		return body_len_;
	}

	void RooboHeader::SetBodyLen(uint16_t len){
		body_len_ = len;
	}

	void RooboHeader::Clear(){
		memset(&magic_code_, 0, GetSize());
	}

	void RooboHeader::SetFlags(int flag){
		flags_ = flag;
	}

	uint8_t RooboHeader::GetCategory(){
		
		return category_;
	}
	void RooboHeader::Dump(){
		uint32_t hi = HI64(sn_);
		uint32_t lo = LO64(sn_);
		log_d("DUMP RooboHeader sn 0x%08x%08x category 0x%02x, msg_fmt 0x%02x, flags 0x%02x, body_len %d", hi, lo, category_, format_, flags_, body_len_);
	}
}