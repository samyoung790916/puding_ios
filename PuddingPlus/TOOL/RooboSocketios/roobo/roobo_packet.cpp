#include "roobo_packet.h"
#include "roobo_header.h"
#include "../common/log.h"




namespace roobo {

#ifdef TRACK_ROOBO_PACKET

#define GUARD_KPT_ID() Guard g(&rb_pkt_mutex)

	static int rb_pkt_cnt = 0;
	static Mutex rb_pkt_mutex;

	void pkt_inc(){
		GUARD_KPT_ID();
		rb_pkt_cnt++;
		if(rb_pkt_cnt > 10 || rb_pkt_cnt < -10){
			log_d("packet leak !!!! %d", rb_pkt_cnt);
		}
	}

	void pkt_dec(){
		GUARD_KPT_ID();
		rb_pkt_cnt--;
		if(rb_pkt_cnt > 10 || rb_pkt_cnt < -10){
			log_d("packet leak !!!! %d", rb_pkt_cnt);
		}
	}

#endif


	RooboPacket::RooboPacket()  
	{
		header_ = new RooboHeader();

#ifdef TRACK_ROOBO_PACKET
		pkt_inc();
#endif

	}


	RooboPacket::RooboPacket(uint64_t sn, uint8_t flags, uint8_t category, void * body, uint16_t body_len){
		uint16_t actual_len = body == NULL ? 0: body_len;
		header_ = new RooboHeader(sn, flags, category, actual_len);
		body_.Assign(body, body_len);
	}

	RooboPacket::RooboPacket(uint8_t flags, uint8_t category, void * body, uint16_t body_len){
		uint16_t actual_len = body == NULL ? 0: body_len;
		header_ = new RooboHeader(flags, category, actual_len);
		body_.Assign(body, body_len);
	}

	//
	// Convert packet from binary
	//
	RooboPacket::RooboPacket(void * data, int len){

		if(data != NULL && len > 0){
			header_ = new RooboHeader(data, len);
			int h_size = header_->GetSize();
			char * p = ((char*)data) + h_size;
			body_.Assign(p, len - h_size);
		}


		// log_d("%s %d body size is %d %d", __FILE__, __LINE__, header_->GetSize(), body_.size());

#ifdef TRACK_ROOBO_PACKET
		pkt_inc();
#endif

	}



	RooboPacket::RooboPacket(const RooboPacket & packet){

		RooboPacket * tmp = (RooboPacket*)&packet;
		RooboHeader * arg_header = (RooboHeader*)tmp->GetHeader();
		if(arg_header){
			header_ = new RooboHeader((RooboHeader)(*arg_header));
		} else {
			header_ = NULL;
		}

		body_.Assign(tmp->GetBody().data(), tmp->GetBody().size());

#ifdef TRACK_ROOBO_PACKET
		pkt_inc();
#endif

	}


	RooboPacket & RooboPacket::operator = ( RooboPacket & packet){

		if(this == &packet){
			return *this;
		}

		RooboPacket *p = (RooboPacket*)&packet;

		if(packet.GetHeader() == NULL){
			RB_FREE(header_);
		}else {
			*((RooboHeader*)header_) = *((RooboHeader*)p->GetHeader());
		}

		body_.Assign(p->GetBody().data(), p->GetBody().size());

		return *this;
	}


	RooboPacket::~RooboPacket(void)
	{
		RB_FREE(header_);

#ifdef TRACK_ROOBO_PACKET
		pkt_dec();
#endif

		//mark();
	}


	void RooboPacket::Deserialize(Buffer * buffer){

		if(NULL == buffer){
			log_e("%s buffer is null", __FILE__);
			return;
		}

		((RooboHeader*)header_)->Deserialize(buffer);
		int header_size = header_->GetSize();
		this->body_.Assign((buffer->data() + header_size), buffer->size() - header_size);
	}


	void RooboPacket::Serialize(Buffer * buffer){

		if(NULL == buffer){
			log_e("%s buffer is null", __FILE__);
			return;
		}

		header_->SetBodyLen(body_.size());
		((RooboHeader*)header_)->Serialize(buffer);

		buffer->Append(body_.data(), body_.size());
	}


	uint64_t RooboPacket::GetSn(){
		if(NULL != header_){
			return ((RooboHeader*)header_)->sn_;
		} 
		return 0;
	}
}