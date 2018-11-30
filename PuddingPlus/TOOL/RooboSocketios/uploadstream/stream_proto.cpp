#include "stream_proto.h"
#include <memory.h>
#include "../common/platform.h"
#include "../common/log.h"

namespace roobo {
	namespace stream {

		StreamProto::StreamProto(RBS_Parameters * parameters)
			: channel_state_(kChannelAuthenticating)
		{

			assert(parameters != NULL);

			this->app_id_ = parameters->app_id;
			this->channel_id_ = parameters->channel_id;
			memcpy(client_id_, parameters->client_id, sizeof(RBS_BYTE) * 32);
			memcpy(public_key_, parameters->public_key, sizeof(RBS_BYTE) * 32);	

			upload_stream_state_.pcm_format = parameters->upload_pcm_format;
			download_stream_state_.pcm_format = parameters->download_pcm_format;

			Reset();
		}

		StreamProto::~StreamProto(void)
		{

		}

		ChannelState StreamProto::OnDataRead(const Buffer * buffer)
		{
			mark();

			int rbs_header_size = sizeof(RBS_Header);

			if(buffer == NULL || buffer->size() < rbs_header_size){
				mark();
				return channel_state_;
			}

			if(channel_id_ == kChannelAuthenticating){ // Expecting auth resp
				
				if(buffer->size() >= rbs_header_size){
					RBS_AuthResp auth_resp;
					memcpy(&auth_resp.header.protocol_version, buffer->data(), sizeof(RBS_AuthResp) - 1);
					
					if(auth_resp.header.magic_number != RBS_STREAM_MAGIC){
						log_e("%s bad magic number", __PRETTY_FUNCTION__, auth_resp.header.magic_number);
						return kChannelAuthFailed;
					}

					if(auth_resp.header.payload_type != RBS_PAYLOAD_AUTH_RESP){
						log_e("%s expecting payload RBS_PAYLOAD_AUTH_RESP while %d received", __PRETTY_FUNCTION__, auth_resp.header.payload_type);
						return kChannelAuthFailed;
					}
				}
			}

			return channel_state_;
		}

		RBS_Data_Packet * StreamProto::ReadPacket(RBS_INT32 * err){
			return NULL;
		}


		bool StreamProto::UploadData(const Buffer * buffer,  RBS_Payload payload, RBS_Flag flag)
		{
			if(buffer == NULL){
				return false;
			}

			// TODO encod data

			return true;
		}

		void StreamProto::GetHandshakeData(Buffer * buffer)
		{
			if(buffer == NULL){
				return;
			}

			/*
			struct RBS_Header header;	 // 包头

			struct RBS_PcmFormat upload_pcm_format;	  // 上行的PCM格式
			struct RBS_PcmFormat download_pcm_format; // 下行需要的PCM格式

			RBS_UINT16  platform;				// 平台
			RBS_UINT16	channel_id;				// 渠道
			RBS_UINT16	app_id;					// 应用厂商id

			RBS_BYTE	client_id		[32];	// 端唯一标识
			RBS_BYTE	secret			[16];	// 用公钥加密的16字节随机数
			RBS_BYTE	reserved		[16];	// 保留字段
			*/

			RBS_AuthReq req;

			InitHeader(&req.header, RBS_PAYLOAD_AUTH_REQ, 0,sizeof(req) - sizeof(req.header));

			req.app_id = this->app_id_;
			req.channel_id = this->channel_id_;

			memcpy(req.client_id, client_id_, sizeof(RBS_BYTE) * 32);

			req.download_pcm_format = download_stream_state_.pcm_format;
			req.upload_pcm_format = upload_stream_state_.pcm_format;

			buffer->Assign(&req.header.protocol_version, sizeof(req));
		}

		void StreamProto::Reset()
		{
			channel_state_ = kChannelAuthenticating;
		}

		void StreamProto::InitHeader(RBS_Header * header, RBS_UINT32 payload_type, RBS_UINT32 serial_number, RBS_UINT32	payload_length){
			if(header == NULL){
				return;
			}

			header->magic_number = RBS_STREAM_MAGIC;
			header->protocol_version = 1;
			header->payload_type = payload_type,
				header->serial_number = serial_number;
			header->payload_length = payload_length;
		}
	}
}