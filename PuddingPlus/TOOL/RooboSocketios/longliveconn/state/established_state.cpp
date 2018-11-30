#include "established_state.h"


#include "../../common/log.h"
#include "../event/cmd_event.h"
#include "../event/message_event.h"
#include "../event/network_changed_event.h"
#include "../event/packet_received_event.h"
#include "../event/packet_timeout_event.h"
#include "../event/stream_state_changed_event.h"

namespace roobo {

	namespace longliveconn {

		EstablishedState::~EstablishedState(void)
		{
		}


		//
		// called when there is an event need to handle
		//
		int EstablishedState::OnEvent( Event & evt){

			int event_code = evt.GetEventCode();

			if(event_code == EVENT_NETWORK_CHANGED){

				NetworkChangedEvent * network_changed_event = (NetworkChangedEvent *)&evt;
				llc_->SetNetworkInfo(*network_changed_event->GetNetworkInfo());
				machine_->TransitTo(STATE_DISCONNECTED);

			}  else if(event_code == EVENT_STREAM_STATE_CHANGED){

				StreamStateChangedEvent * ssce  = (StreamStateChangedEvent*) &evt;
				int state = ssce->GetStreamState();
				if(state == STREAM_EVENT_DISCONNECTED){
					machine_->TransitTo(STATE_DISCONNECTED);
				} else {
					log_d("EstablishedState unexpected...");
				}

			} else if(event_code == EVENT_CMD){

				CmdEvent *cmd_event = (CmdEvent*)&evt;
				if(cmd_event->GetCmd() ==  CMD_PING){
					if(!llc_->Ping()){
						log_e("Failed to send ping");
						machine_->TransitTo(STATE_DISCONNECTED);
					}
				}

			} else if(event_code == EVENT_PACKET_TIMEOUT){

				PacketTimeoutEvent * pte = (PacketTimeoutEvent*)&evt;
				if(!pte->IsUserPacket()){
					machine_->TransitTo(STATE_DISCONNECTED);
				}	

			} else if(event_code == EVENT_MESSAGE){

				MessageEvent * msg_event = (MessageEvent*)&evt;

				log_d("%s 0x%08x, flags %d", __FILE__, msg_event->GetPacket(), msg_event->GetFlags());

				if(!llc_->DoSendPacket(msg_event->GetPacket())){
					machine_->TransitTo(STATE_DISCONNECTED);
				}
			}

			return 0;
		}

		//
		// called when enter the state
		//
		int EstablishedState::OnEnter(){
			if(!llc_->SendPendingPacket()){
				machine_->TransitTo(STATE_DISCONNECTED);
			}
			return 0;
		}

		//
		// called when exit the state
		//
		int EstablishedState::OnExit(){
			return 0;
		}
	}
}