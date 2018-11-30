#include "event_factory.h"

#include "event/cmd_event.h"
#include "event/message_event.h"
#include "event/network_changed_event.h"
#include "event/packet_received_event.h"
#include "event/packet_timeout_event.h"
#include "event/stream_state_changed_event.h"

namespace roobo {

	namespace longliveconn {

		EventFactory * EventFactory::_instance = new EventFactory();

		EventFactory::EventFactory(void)
		{
		}

		EventFactory::~EventFactory(void)
		{
		}

		//
		// Obtain Stream Changed event
		//
		Event * EventFactory::ObtainEvent(int stream_state){
			return new StreamStateChangedEvent(stream_state);
		}


		//
		// Obtain Cmd Event
		//
		Event * EventFactory::ObtainEvent(int cmd, void * params){
			return new CmdEvent(cmd, params);
		}

		//
		// Obtain PacketReceived Event
		//
		Event * EventFactory::ObtainEvent(Packet * packet){
			return new PacketReceivedEvent(packet);
		}

		//
		// Obtain Message Event
		//
		Event * EventFactory::ObtainEvent(Packet * packet, PacketSendFlag flags){
			return new MessageEvent(packet, flags);
		}

		//
		// Obtain Network changed event
		//
		Event * EventFactory::ObtainEvent(NetworkInfo & network_info){
			return new NetworkChangedEvent(&network_info);
		}

		//
		// Obtain packet timedout event
		//
		Event * EventFactory::ObtainEvent(bool is_user_packet, uint64_t sn){
			return new PacketTimeoutEvent(is_user_packet, sn);
		}

		//
		// Recycle event
		//
		void EventFactory::RecycleEvent(Event ** evt){

			if(!evt || !*evt){
				return;
			}

			delete *evt;
			*evt = NULL;
		}
	}
}