#include "../longliveconn/stream.h"

namespace roobo {

	namespace longliveconn {

		const char * StreamCodeToString(int code){
			if( code == 1 ) return "STREAM_EVENT_CONNECTED";
			if( code == 2 ) return "STREAM_EVENT_DISCONNECTED";
			if( code == 3 ) return "STREAM_EVENT_PACKET_READ";
			if( code == 4 ) return "STREAM_EVENT_BAD_MAGIC";
			if( code == 5 ) return "STREAM_EVENT_DECRYPT_FAILED";
			return "UNKNOWN_STREAM_EVENT_CODE";
		}
	}
}