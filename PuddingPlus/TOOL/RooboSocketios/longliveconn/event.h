
#ifndef ROOBO_EVENT_H_
#define ROOBO_EVENT_H_

#include "data_types.h"


#define EVENT_CMD					1	// Event wrap with a simple cmd
#define EVENT_NETWORK_CHANGED		2	// network has changed
#define EVENT_MESSAGE				3	// user sends message
#define EVENT_STREAM_STATE_CHANGED	4	// stream has event to share 
#define EVENT_PACKET_RECEIVED		5	// packet read from stream
#define EVENT_PACKET_TIMEOUT		6	// packet read from stream
#define EVENT_BAD_MAGIC_CODE		8   // magic code is bad
#define EVENT_UNKNOWN_PROTOCOL		9	// magic code is ok thought, protocol does not match

#define CMD_CONNECT			2 // try to connect to server now
#define CMD_PING			3 // time to send ping
#define CMD_SHUTDOWN		4 // shutdown long live conn
#define CMD_PACKET_TIMEOUT  5 // packet has timeouted
#define CMD_IO_EVENT		6 // packet has timeouted

namespace roobo {

	namespace longliveconn {

		class Event {

		public:

			virtual ~Event() {};

			//
			// return the event code
			//
			virtual int GetEventCode() = 0; 
		};

	}
}

#endif // ROOBO_EVENT_H_
