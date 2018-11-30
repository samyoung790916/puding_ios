#ifndef STREAM_STATE_CHANGED_EVENT_H_
#define STREAM_STATE_CHANGED_EVENT_H_

#include "../event.h"
#include "../stream.h"

namespace roobo {

	namespace longliveconn {

		class StreamStateChangedEvent : public Event
		{
		protected :
			int stream_state_;

		public:

			explicit StreamStateChangedEvent(int stream_state) : stream_state_(stream_state){

			}

			virtual ~StreamStateChangedEvent(void);

			virtual int GetEventCode() {return EVENT_STREAM_STATE_CHANGED;}

			int GetStreamState() {return stream_state_; }
		};
	}
}
#endif // STREAM_STATE_CHANGED_EVENT_H_