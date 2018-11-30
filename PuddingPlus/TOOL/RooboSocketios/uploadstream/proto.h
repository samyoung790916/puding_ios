#ifndef _ROOBO_STREAM_PROTO_ABSTRACT_H_
#define _ROOBO_STREAM_PROTO_ABSTRACT_H_

#include "../common/buffer.h"
#include "roobo_stream.h"

namespace roobo {
	namespace stream {

		enum ChannelState
		{
			kChannelEstablished,
			kChannelAuthenticating,
			kChannelAuthFailed,
			kChannelClosed
		};


		class Proto{

		public:

			//
			// Called when socket data read
			//
			virtual ChannelState OnDataRead(const Buffer * buffer) = 0;

			//
			// For upper application to fetch data
			//
			virtual RBS_Data_Packet * ReadPacket(RBS_INT32 * err) = 0;

			virtual bool UploadData(const Buffer * buffer,  RBS_Payload payload, RBS_Flag flag) = 0;

			virtual void GetHandshakeData(Buffer * buffer) = 0;

			virtual void Reset() = 0;
		};
	}
}




#endif // _ROOBO_STREAM_PROTO_ABSTRACT_H_