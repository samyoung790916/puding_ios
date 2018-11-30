#include "connecting_state.h"

#include "../../common/log.h"
#include "../event/cmd_event.h"
#include "../event/message_event.h"
#include "../event/network_changed_event.h"
#include "../event/packet_received_event.h"
#include "../event/packet_timeout_event.h"
#include "../event/stream_state_changed_event.h"

namespace roobo {

	namespace longliveconn {

		ConnectingState::~ConnectingState(void)
		{
		}

		//
		// called when there is an event need to handle
		//
		int ConnectingState::OnEvent( Event & evt){

			int event_code = evt.GetEventCode();

			if(event_code == EVENT_CMD){
				CmdEvent *cmd_event = (CmdEvent*) & evt;
				if(cmd_event->GetCmd() ==  CMD_CONNECT){
					// machine_->TransitTo(STATE_CONNECTING);
				}
			}else if(event_code == EVENT_NETWORK_CHANGED){

				NetworkChangedEvent * network_changed_event = (NetworkChangedEvent *)&evt;
				llc_->SetNetworkInfo(*network_changed_event->GetNetworkInfo());

				//if(!network_changed_event->GetNetworkInfo()->Available){
				machine_->TransitTo(STATE_DISCONNECTED);
				//} 
			}  else if(event_code == EVENT_STREAM_STATE_CHANGED){
				StreamStateChangedEvent * ssce  = (StreamStateChangedEvent*) &evt;
				int state = ssce->GetStreamState();
				if(state == STREAM_EVENT_CONNECTED){
					machine_->TransitTo(STATE_AUTHENTICATING);
				} else {
					machine_->TransitTo(STATE_DISCONNECTED);
				}
			} else if(event_code == EVENT_PACKET_TIMEOUT){
				PacketTimeoutEvent * pte = (PacketTimeoutEvent*)&evt;
				if(!pte->IsUserPacket()){
					machine_->TransitTo(STATE_DISCONNECTED);
				}		
			}  

			return 0;
		}

		//
		// called when enter the state
		//
		int ConnectingState::OnEnter(){

			llc_->SetupStream();

			int r = llc_->GetCurrentStream()->Connect();

			if(r != 0 ){
				log_e("Stream->Connect failed %d", r);
				machine_->TransitTo(STATE_DISCONNECTED);
			} else {
				log_e("Stream->Connect ok");
			}

			return 0;
		}

		//
		// called when exit the state
		//
		int ConnectingState::OnExit(){
			return 0;
		}
	}
}