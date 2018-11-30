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

			RBS_BYTE client_id_	[32];			// 端唯一标识
			RBS_BYTE public_key_	[32];		// 鉴权信息
			RBS_UINT16	app_id_;				// 应用厂商id
			RBS_UINT16	channel_id_;			// 渠道

			RBS_BYTE	secret_[16]; // random generated secret info

			struct RBS_ServerAddress * addresses_; // 服务器地址信息队列
			RBS_INT32 address_size_; // 服务器地址个数

			StreamState upload_stream_state_;
			StreamState download_stream_state_;

			ChannelState channel_state_;


			/*
			RBS_UINT32	payload_type;		//  PCM,文本命令
			RBS_UINT32	serial_number;		//  串号, 同一payload，并且同一组的包的串号是一样的
			RBS_UINT32	payload_length;		//  不包含header本身
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

