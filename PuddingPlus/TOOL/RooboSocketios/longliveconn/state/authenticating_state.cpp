#include "authenticating_state.h"

#include <stddef.h>
#include "../../common/log.h"
#include "../event/cmd_event.h"
#include "../event/message_event.h"
#include "../event/network_changed_event.h"
#include "../event/packet_received_event.h"
#include "../event/packet_timeout_event.h"
#include "../event/stream_state_changed_event.h"

namespace roobo {

	namespace longliveconn {

		AuthenticatingState::~AuthenticatingState(void)
		{
		}

		void AuthenticatingState::SetCipherProperly(AuthResult * auth_result){

			if(NULL == auth_result){
				log_e("SetCipherProperly result is NULL");
				return;
			}

			if(auth_result->encryption_algorithm){
				llc_->SetEncryptionCipher(auth_result->encryption_algorithm, &auth_result->decryption_key);
			}

			if(auth_result->decryption_algorithm){
				llc_->SetDecryptionCipher(auth_result->decryption_algorithm, &auth_result->decryption_key);
			}
		}

		//
		// called when there is an event need to handle
		//
		int AuthenticatingState::OnEvent( Event & evt){

			int event_code = evt.GetEventCode();

			if(event_code == EVENT_PACKET_RECEIVED){

				PacketReceivedEvent * pre = (PacketReceivedEvent*)&evt;
				Packet * packet_received = pre->GetPacket();

				if(sub_state_ == AUTH_STATE_HANDSHAKE_SENT){

					Packet * packet_to_send = NULL;

					AuthResult * handshake_result = llc_->GetAuth()->OnHandshakeResp(packet_received, &packet_to_send);
					if(handshake_result == NULL){
						log_e("%s handshake result is NULL", __FILE__);
						machine_->TransitTo(STATE_DISCONNECTED);
						return -3;
					}

					SetCipherProperly(handshake_result);

					if(handshake_result->code == kAuthenticated){

						llc_->GetCurrentStream()->SetStreamMode(kActive);
						machine_->TransitTo(STATE_ESTABLISHED);

					} else if(handshake_result->code == kContinue) {
						llc_->GetCurrentStream()->SetStreamMode(kActiveOnce);
						int ret = 0;

						if(handshake_result->packet_to_send == NULL){
							log_e("%s ask to continue, but packet is null", __FILE__);
							machine_->TransitTo(STATE_DISCONNECTED);
							ret = -1;
						} else if(!llc_->SendPacket(packet_to_send)){
							log_e("%s SendPacket failed %d", __FILE__, __LINE__);
							machine_->TransitTo(STATE_DISCONNECTED);
							ret =  -2;
						}

						if(ret == 0){
							sub_state_ = AUTH_STATE_AUTH_SENT;
						} 
					} else {
						log_e("Auth failed");
						machine_->TransitTo(STATE_DISCONNECTED);
					}

					RB_FREE_MEM_ONLY(handshake_result);

				} else if(sub_state_ == AUTH_STATE_AUTH_SENT){

					AuthResult * auth_result = llc_->GetAuth()->OnAuthResp(packet_received);

					if(auth_result == NULL){
						log_e("Authentication resp check failed, auth_result = NULL");
						machine_->TransitTo(STATE_DISCONNECTED);
					} else if(auth_result->code != kAuthenticated){
						log_e("Authentication resp check failed, auth_code = %d", auth_result->code);
						machine_->TransitTo(STATE_DISCONNECTED);
					} else {
						machine_->TransitTo(STATE_ESTABLISHED);
					}

					RB_FREE_MEM_ONLY(auth_result);
				}

			} else if(event_code == EVENT_NETWORK_CHANGED){

				NetworkChangedEvent * network_changed_event = (NetworkChangedEvent *)&evt;
				llc_->SetNetworkInfo(*network_changed_event->GetNetworkInfo());

				if(!network_changed_event->GetNetworkInfo()->Available){
					machine_->TransitTo(STATE_DISCONNECTED);
				} 
			} else if(event_code == EVENT_PACKET_TIMEOUT){
				PacketTimeoutEvent * pte = (PacketTimeoutEvent*)&evt;
				if(!pte->IsUserPacket()){
					machine_->TransitTo(STATE_DISCONNECTED);
				}		
			} else if(event_code == EVENT_STREAM_STATE_CHANGED){
				StreamStateChangedEvent * ssce  = (StreamStateChangedEvent*) &evt;
				int state = ssce->GetStreamState();
				if(state == STREAM_EVENT_DISCONNECTED){
					machine_->TransitTo(STATE_DISCONNECTED);
				} else {
					log_d("AuthenticatingState unexpected...");
				}
			}

			return 0;
		}

		//
		// called when enter the state
		//
		int AuthenticatingState::OnEnter(){

			Packet * packet_to_send = llc_->GetAuth()->CreateHandshakePacket();
			if(NULL == packet_to_send){
				log_e("%s Auth CreateHandshakePacket returns NULL", __FUNCTION__);
				machine_->TransitTo(STATE_DISCONNECTED);
				return -1;
			}

			int err = llc_->SendPacket(packet_to_send);
			if(err <= 0){
				log_e("%s %d SendPacket failed %d", __FILE__, __LINE__, err);
				machine_->TransitTo(STATE_DISCONNECTED);
				return err;
			}	

			sub_state_ = AUTH_STATE_HANDSHAKE_SENT;

			return 0;
		}

		//
		// called when exit the state
		//
		int AuthenticatingState::OnExit(){
			Reset(); 
			llc_->GetAuth()->Reset();
			return 0;
		}
	}
}