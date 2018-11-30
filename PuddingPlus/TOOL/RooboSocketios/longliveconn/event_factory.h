#ifndef ROOBO_EVENT_FACTORY_H_
#define ROOBO_EVENT_FACTORY_H_

#include "event.h"
#include "packet.h"

namespace roobo {

	namespace longliveconn {

		class EventFactory
		{

		protected:
			static EventFactory *  _instance;
			EventFactory(void);

		public:

			// TODO: multiple threading unsafe
			static EventFactory * GetInstance(){ 
				return _instance;
			}

			virtual ~EventFactory(void);

			//
			// Obtain Stream Changed event
			//
			Event * ObtainEvent(int stream_state);

			//
			// Obtain Cmd Event
			//
			Event * ObtainEvent(int cmd, void * params);

			//
			// Obtain PacketReceived Event
			//
			Event * ObtainEvent(Packet * packet);


			//
			// Obtain Message Event
			//
			Event * ObtainEvent(Packet * packet, PacketSendFlag flags);

			//
			// Obtain Timedout Event
			//
			Event * ObtainEvent(bool is_user_packet, uint64_t sn);

			//
			// Obtain Network changed event
			//
			Event * ObtainEvent(NetworkInfo & network_info);

			//
			// Recycle event
			//
			void RecycleEvent(Event ** evt);

		};

	}
}

#endif // ROOBO_EVENT_FACTORY_H_