#include "disconnected_state.h"


#include "../../common/log.h"
#include "../event/cmd_event.h"
#include "../event/message_event.h"
#include "../event/network_changed_event.h"
#include "../event/packet_received_event.h"
#include "../event/packet_timeout_event.h"
#include "../event/stream_state_changed_event.h"

namespace roobo {

	namespace longliveconn {

		//
		// called when enter the state
		//
		int DisconnectedState::OnEnter(){

			llc_->RemovePendingPackets();

			Stream * stream = llc_->GetCurrentStream();
			if(stream){
				stream->Close();
			}

			llc_->GetCurrentStream()->SetStreamMode(kActiveOnce);

			if(llc_->GetNetworkInfo()->Available){ // network is available, schedule next connect		
				log_d("Network is available, schedule connect");
				llc_->ScheduleNextConnect();
			} else {
				log_d("Network is unavailable ... ");
			}

			return 0;
		}

		//
		// called when there is an event need to handle
		//
		int DisconnectedState::OnEvent( Event & evt){

			int event_code = evt.GetEventCode();

			if(event_code == EVENT_CMD){
				CmdEvent *cmd_event = (CmdEvent*)&evt;
				if(cmd_event->GetCmd() ==  CMD_CONNECT){
					machine_->TransitTo(STATE_CONNECTING);
				}
			} else if(event_code == EVENT_NETWORK_CHANGED){

				NetworkChangedEvent * network_changed_event = (NetworkChangedEvent *)&evt;
				llc_->SetNetworkInfo(*network_changed_event->GetNetworkInfo());
				
				if(network_changed_event->GetNetworkInfo()->Available){
					machine_->TransitTo(STATE_CONNECTING);
				} else {
					// no network availabe, no need to connect
					// llc_->GetCurrentStream()->Close();
				}
			} else if(event_code == EVENT_MESSAGE){
				if(this->llc_->GetNetworkInfo()->Available){
					machine_->TransitTo(STATE_CONNECTING);
				}
			}

			return 0;
		}


		//
		// called when exit the state
		//
		int DisconnectedState::OnExit(){
			return 0;
		}

		DisconnectedState::~DisconnectedState(void)
		{
		}
	}
}