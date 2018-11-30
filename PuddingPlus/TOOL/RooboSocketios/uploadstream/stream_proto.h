#ifndef _ROOBO_STREAM_PROTO_H_
#define _ROOBO_STREAM_PROTO_H_

#include "roobo_stream.h"
#include "../common/buffer.h"
#include "proto.h"

namespace roobo {
	namespace stream {

		struct StreamState
		{			 
			RBS_PcmFormat pcm_format;

			RBS_Payload payload;
			RBS_Flag last_flag;

			RBS_Cipher_Algorithm cipher_algorithm;
			RBS_INT16 key_len;
			RBS_BYTE  * key;			
		};

		class StreamProto : public Proto
		{

		private:

			RBS_BYTE client_id_	[32];			// ��Ψһ��ʶ
			RBS_BYTE public_key_	[32];		// ��Ȩ��Ϣ
			RBS_UINT16	app_id_;				// Ӧ�ó���id
			RBS_UINT16	channel_id_;			// ����

			RBS_BYTE	secret_[16]; // random generated secret info

			struct RBS_ServerAddress * addresses_; // ��������ַ��Ϣ����
			RBS_INT32 address_size_; // ��������ַ����

			StreamState upload_stream_state_;
			StreamState download_stream_state_;

			ChannelState channel_state_;


			/*
			RBS_UINT32	payload_type;		//  PCM,�ı�����
			RBS_UINT32	serial_number;		//  ����, ͬһpayload������ͬһ��İ��Ĵ�����һ����
			RBS_UINT32	payload_length;		//  ������header����
			*/

			void InitHeader(RBS_Header * header, RBS_UINT32 payload_type, RBS_UINT32 serial_number, RBS_UINT32	payload_length);

		public:

			explicit StreamProto(RBS_Parameters * parameters);

			~StreamProto(void);

			//
			// Called when socket data read
			//
			virtual ChannelState OnDataRead(const Buffer * buffer);

			virtual RBS_Data_Packet * ReadPacket(RBS_INT32 * err);

			virtual bool UploadData(const Buffer * buffer,  RBS_Payload payload, RBS_Flag flag);

			virtual void GetHandshakeData(Buffer * buffer);

			virtual void Reset();

		};
	}
}
#endif // _ROOBO_STREAM_PROTO_H_

