#include "roobo_long_live_conn.h"

#include "../longliveconn/state/authenticating_state.h"
#include "../longliveconn/state/connecting_state.h"
#include "../longliveconn/state/disconnected_state.h"
#include "../longliveconn/state/established_state.h"

#include "../longliveconn/event_factory.h"
#include "../longliveconn/event/cmd_event.h"
#include "../longliveconn/event/message_event.h"
#include "../longliveconn/event/network_changed_event.h"
#include "../longliveconn/event/packet_received_event.h"
#include "../longliveconn/event/packet_timeout_event.h"
#include "../longliveconn/event/stream_state_changed_event.h"

#include "roobo_packet_factory.h"
#include "roobo_packet.h"

#include "../tpl/smart_ptr.h"


namespace  roobo {

	const int  kNumberOfStates = 4;

	const int  kReconnectArraySize = 20;

	const int  kShutdownWaittimeout = 800;

	unsigned short RooboLongLiveConn::reconnect_intervals_[kReconnectArraySize] = {1, 1, 2, 2, 3, 4, 6, 8, 12, 18, 20, 24, 28, 32, 36, 40, 48, 56, 58, 60};

	void * RooboThreadFunc(void * params){

		RooboLongLiveConn * conn = (RooboLongLiveConn*)params;
		conn->Run();

		return NULL;
	}

	RooboLongLiveConn::RooboLongLiveConn(const tpl::Vector<longliveconn::ServerAddress> & addresses, LongLiveConnApi * api, longliveconn::Auth *auth) 
		: api_(api),  addresses_ (addresses), state_(NULL), auth_(auth), quit_(false), conn_interval_index_(0), address_index_(0)
	{
 
		event_queue_ = new tpl::BlockingQueue<longliveconn::Event*>();

		thread_ = new Thread(RooboThreadFunc);

		packet_ = new RooboPacket();
	}

	bool RooboLongLiveConn::Init(tpl::SmartPtr<TimerCallback> * smart_ptr_container){

		if(smart_ptr_container == NULL ){
			return false;
		}

		smart_ptr_container_ = smart_ptr_container;

		longliveconn::State * as = new longliveconn::AuthenticatingState(this, this);
		longliveconn::State * cs = new longliveconn::ConnectingState(this, this);
		longliveconn::State * ds = new longliveconn::DisconnectedState(this, this);
		longliveconn::State * es = new longliveconn::EstablishedState(this, this);

		longliveconn::StateName as_name = as->GetName();
		state_map_.Put(as_name, as );

		longliveconn::StateName cs_name = cs->GetName();
		state_map_.Put(cs_name, cs);

		longliveconn::StateName ds_name = ds->GetName();
		state_map_.Put(ds_name, ds);

		longliveconn::StateName es_name = es->GetName();
		state_map_.Put(es_name,es);

		stream_ = new network::TcpStream(this, packet_, &addresses_, CONNECT_TIMEOUT);

		timer_manager_ =  TimerManager::GetInstance();

		tpl::SmartPtr<TimerCallback> smart_ptr = *smart_ptr_container_;

		connect_timer_id_ = timer_manager_->AddOnDemandTimer(smart_ptr, NULL);

		ping_timer_id_ = timer_manager_->AddRepeatTimer(smart_ptr, PING_TIMEOUT, NULL);

		packet_manager_ = new PacketMonitor(smart_ptr_container_, this, this);

		thread_->Start(this);

		return true;
	}

	RooboLongLiveConn::~RooboLongLiveConn(void)
	{
		mark();

		quit_ = true;

		packet_manager_->RemoveAllPackets();

		timer_manager_->RemoveTimer(ping_timer_id_);

		timer_manager_->RemoveTimer(connect_timer_id_);

		stream_->Close();

		RB_FREE(stream_);

		// TODO wait till thread quit, to avoid corruption
		RB_FREE(thread_);

		RB_FREE(event_queue_);

		longliveconn::StateName  state_names [ kNumberOfStates ]  = {longliveconn::STATE_AUTHENTICATING, 
			longliveconn::STATE_CONNECTING, longliveconn::STATE_DISCONNECTED, longliveconn::STATE_ESTABLISHED};

		for(int i = 0; i < kNumberOfStates; i++){
			longliveconn::State ** state = state_map_.Get(state_names[i]);
			RB_FREE( *state);
			state_map_.Remove(state_names[i]);
		}

		RB_FREE(packet_manager_);
	}

	//====================================================================
	// Functions for StateMachine
	//====================================================================

	//
	// Post an envet, the function may be called by other threads
	//
	int RooboLongLiveConn::PostEvent(const longliveconn::Event * evt){

		if(NULL == evt){
			return -1;
		}

		longliveconn::Event * local_event = (longliveconn::Event*)evt;
		// TODO: leak for MESSAGE_EVENT and PACKET_RECEIVED_EVENT
		if(quit_){ 		 
			roobo::longliveconn::EventFactory::GetInstance()->RecycleEvent(&local_event);
			return -2;
		}

		this->event_queue_->Offer(local_event);
		return 0;
	}

	//
	// Transit to a state
	// TODO: OnExit and OnEnter will be called before caller function completes
	//
	void RooboLongLiveConn::TransitTo(longliveconn::StateName target_state_name){

		longliveconn::State ** new_state = state_map_.Get(target_state_name);
		if(!new_state){
			log_e("state name does not exists: %d", target_state_name);
			return;
		}

		longliveconn::StateName old_state_name = longliveconn::STATE_INVALID;
		if(state_ != NULL){
			old_state_name =  state_->GetName();
			state_->OnExit();
		}  

		state_ = *new_state;

		if(old_state_name == longliveconn::STATE_INVALID){
			log_t("Initial state %s",  GetStateNameString( (*new_state)->GetName()));
		} else {
			log_t("State transition %s ==> %s",GetStateNameString( old_state_name),  GetStateNameString((*new_state)->GetName()));
		}


		if( state_->GetName() == longliveconn::STATE_ESTABLISHED){

			log_d("Established, reset ping timer");
			// reset reconnect interval, this is evil !!!
			conn_interval_index_ = 0;
			address_index_ = 0;

			timer_manager_->ResetTimer(ping_timer_id_, PING_TIMEOUT);

		} else {		
			// packet_manager_->RemovePendingPackets();
			timer_manager_->CancelTimer(ping_timer_id_);
		}

		// entering the state
		state_->OnEnter();

		api_->OnStateChange(old_state_name, target_state_name);

	}


	longliveconn::State * RooboLongLiveConn::GetCurrentState(){
		return this->state_;
	}

	//====================================================================
	// Functions for LongLiveConn
	//====================================================================



	longliveconn::NetworkInfo *  RooboLongLiveConn::GetNetworkInfo(){
		return & this->network_info_;
	}

	void RooboLongLiveConn::SetNetworkInfo( longliveconn::NetworkInfo & network_info){
		
		// log_d("RooboLongLiveConn::SetNetworkInfo available %d", network_info.Available);
		
		// reset reconnect interval
		if(!network_info_.Available && network_info.Available){
			conn_interval_index_ = 0;
		}

		memcpy(&this->network_info_, &network_info, sizeof(longliveconn::NetworkInfo));
	}


	void RooboLongLiveConn::NotifyNetworkChange( longliveconn::NetworkInfo & network_info){
		longliveconn::Event * evt = longliveconn::EventFactory::GetInstance()->ObtainEvent(network_info);
		this->PostEvent(evt);
	}


	longliveconn::Stream * RooboLongLiveConn::GetCurrentStream(){
		return stream_;
	}


	void RooboLongLiveConn::SetupStream(){
		
		stream_->Setup(address_index_);

		if(address_index_ < kReconnectArraySize - 1){
			++address_index_;
		}
	}


	bool RooboLongLiveConn::SendPacket(longliveconn::Packet * packet, longliveconn::PacketSendFlag flags){

		if(NULL == packet ){
			return false;
		}
		packet->GetHeader()->SetFlags(flags);
		packet->GetHeader()->Dump();
		if( quit_ ){
			longliveconn::Packet * local_packet = packet;
			RooboPacketFactory::GetInstance()->RecyclePacket(&local_packet);
			return false;
		}

		longliveconn::Event * evt = longliveconn::EventFactory::GetInstance()->ObtainEvent(packet, flags);
		PostEvent(evt);
		return true;
	}


	//
	// API for upper application
	//
	bool RooboLongLiveConn::SendPacket(longliveconn::Packet * packet){	
		packet_manager_->AddPacketTask(packet, longliveconn::kExpectAck);
		return DoSendPacket(packet);
	}


	//
	// internal use
	//
	bool RooboLongLiveConn::DoSendPacket(longliveconn::Packet * packet){

		if(NULL == packet){
			return false;
		}

		int ret = this->stream_->Write(packet);
		log_d("DoSendPacket %d ", ret);
		bool succeeded = ret > 0;

		packet_manager_->OnPacketSent(packet->GetSn(), succeeded);

		return succeeded;
	}



	//
	// set up a schedule to connect later
	//
	int RooboLongLiveConn::ScheduleNextConnect(){

		int timeout = reconnect_intervals_[conn_interval_index_] * 1000;

		log_d("%s %d ms", __PRETTY_FUNCTION__,  timeout);

		timer_manager_->ResetTimer(connect_timer_id_, timeout);

		conn_interval_index_ ++;
		conn_interval_index_ %= kReconnectArraySize;

		return 0;
	}

	void RooboLongLiveConn::ReportPacketResult(uint64_t sn, longliveconn::PacketResult result, longliveconn::Packet * packet){
		log_d("ReportPacketResult");
		api_->OnPacketResult(sn, result, packet);
	}

	//
	// Send pending packets, including the ones attempted
	//
	bool RooboLongLiveConn::SendPendingPacket(){
		log_d("SendPendingPacket");
		return packet_manager_->ResendPendingUserPackets();
	}

	void RooboLongLiveConn::RemovePendingPackets(){
		log_d("RemovePendingPackets");
		packet_manager_->RemovePendingPackets();
	}


	// cipher for reading data
	void RooboLongLiveConn::SetDecryptionCipher(longliveconn::CipherAlgorithm  algorithm, Buffer * key){
		stream_->SetDecryptionCipher(algorithm, key);
	}

	// cipher for writting data
	void RooboLongLiveConn::SetEncryptionCipher(longliveconn::CipherAlgorithm  algorithm, Buffer * key){
		stream_->SetEncryptionCipher(algorithm, key);
	}


	void RooboLongLiveConn::Run(){

		// initial state
		TransitTo(longliveconn::STATE_DISCONNECTED);

		while(!quit_){

			longliveconn::Event * evt = event_queue_->Take();

			log_d("Run: Event %s",  GetEventString(evt->GetEventCode()));

			if (evt->GetEventCode() == EVENT_MESSAGE){
				longliveconn::MessageEvent * me = (longliveconn::MessageEvent*)evt;
				packet_manager_->AddPacketTask(me->GetPacket(), me->GetFlags());
			} 

			state_->OnEvent(*evt);


			if(evt->GetEventCode() == EVENT_PACKET_RECEIVED){

				longliveconn::PacketReceivedEvent * pre = (longliveconn::PacketReceivedEvent*)evt;			
				longliveconn::Packet * packet = pre->GetPacket();
				
				PacketType p_type = packet_manager_->OnPacketReceived(pre->GetPacket());
				log_d("p_type: %d", p_type);
				if (p_type == kPushPacket && this->state_->GetName() == longliveconn::STATE_ESTABLISHED){				
					this->api_->OnPacket((RooboPacket*)pre->GetPacket());
				}

				RooboPacketFactory::GetInstance()->RecyclePacket(&packet);
			}

			if (evt->GetEventCode() == EVENT_CMD){

				longliveconn::CmdEvent* cmd_event = (longliveconn::CmdEvent*)evt;

				if(cmd_event->GetCmd() == CMD_SHUTDOWN){

					quit_ = true;

				} else if(cmd_event->GetCmd() == CMD_PACKET_TIMEOUT){

					TimeoutArgs* timeout_args = (TimeoutArgs*) cmd_event->GetParams();
					packet_manager_->OnTimeout(timeout_args);
					RB_FREE( timeout_args);

				} else if(cmd_event->GetCmd() == CMD_IO_EVENT){

					network::IoCallbackArgs * io_args = (network::IoCallbackArgs *) cmd_event->GetParams();
					//stream_->StreamCallback(io_args);
					RB_FREE( io_args);
				}
			}

			longliveconn::EventFactory::GetInstance()->RecycleEvent(&evt);
		}

		log_d("%s Shutting down  0x%08x", __PRETTY_FUNCTION__, this);

		DoShutdown();
	}

	void RooboLongLiveConn::DoShutdown(){

		mark();

		this->stream_->Close();

		packet_manager_->RemoveAllPackets();

		timer_manager_->RemoveTimer(ping_timer_id_);

		timer_manager_->RemoveTimer(connect_timer_id_);

		longliveconn::Event * evt = NULL;

		// dequeue all event, till no event within timeout
		// specially for MESSAGE and PACKET_RECEIVED, we need to recycle packets
		while(event_queue_->TimedTake(kShutdownWaittimeout, &evt)){

			if (evt->GetEventCode() == EVENT_MESSAGE){

				longliveconn::MessageEvent * me = (longliveconn::MessageEvent*)evt;		
				longliveconn::Packet * packet = me->GetPacket();
				RooboPacketFactory::GetInstance()->RecyclePacket(&packet);

			} else if(evt->GetEventCode() == EVENT_PACKET_RECEIVED){

				longliveconn::PacketReceivedEvent * pre = (longliveconn::PacketReceivedEvent*)evt;			
				longliveconn::Packet * packet = pre->GetPacket();
				RooboPacketFactory::GetInstance()->RecyclePacket(&packet);

			} else if (evt->GetEventCode() == EVENT_CMD){

				longliveconn::CmdEvent* cmd_event = (longliveconn::CmdEvent*)evt;

				if(cmd_event->GetCmd() == CMD_SHUTDOWN){

					quit_ = true;

				} else if(cmd_event->GetCmd() == CMD_PACKET_TIMEOUT){

					TimeoutArgs* timeout_args = (TimeoutArgs*) cmd_event->GetParams();
					RB_FREE( timeout_args);

				} else if(cmd_event->GetCmd() == CMD_IO_EVENT){

					network::IoCallbackArgs * io_args = (network::IoCallbackArgs *) cmd_event->GetParams();
					RB_FREE( io_args);
				}
			}

			longliveconn::EventFactory::GetInstance()->RecycleEvent(&evt);
		}
	}


	//
	// timer callback
	//
	int RooboLongLiveConn::OnTimeout(const TimeoutArgs & timeout_args){

		// log_d("%s timer_id = %d",  __PRETTY_FUNCTION__, timeout_args.timer_id);

		if(quit_){
			return -1;
		}

		if(timeout_args.timer_id == connect_timer_id_){
			log_d("RooboLongLiveConn time to connect");
			this->PostEvent(longliveconn::EventFactory::GetInstance()->ObtainEvent(CMD_CONNECT, NULL));	 
		} else if(timeout_args.timer_id == ping_timer_id_){
			log_d("RooboLongLiveConn time to ping");
			this->PostEvent(longliveconn::EventFactory::GetInstance()->ObtainEvent(CMD_PING, NULL));
		} else {
			TimeoutArgs * args = new TimeoutArgs(timeout_args);
			this->PostEvent(longliveconn::EventFactory::GetInstance()->ObtainEvent(CMD_PACKET_TIMEOUT, args));
		}

		return 0;
	}

	/*
	void RooboLongLiveConn::OnIoEvent (const network::IoCallbackArgs & io_callback_args){

		log_d("%s code = %d",  __PRETTY_FUNCTION__, io_callback_args.code);

		network::IoCallbackArgs * io_args  = new  network::IoCallbackArgs(io_callback_args);
		
		this->PostEvent(longliveconn::EventFactory::GetInstance()->ObtainEvent(CMD_IO_EVENT, io_args));
	}
	*/


	bool RooboLongLiveConn::Ping(){
		longliveconn::Packet * ping_pacaket = auth_->GetHeartbeat();
		if(NULL == ping_pacaket){
			log_e("Failed to get heartbeat packet");
			return false;
		}

		return this->SendPacket(ping_pacaket);
	}

	//
	// Callback for MUX IO thread
	//
	void RooboLongLiveConn::OnStreamEvent(longliveconn::Stream * stream, int event_code,  longliveconn::Packet * packet){

		if(quit_){
			return;
		}

		log_d("RooboLongLiveConn::OnStreamEvent %s", ::roobo::longliveconn::StreamCodeToString(event_code));

		longliveconn::Event * evt = NULL;

		if(event_code == STREAM_EVENT_PACKET_READ){

			if(NULL != packet){
				longliveconn::Packet * cloned_packet = (longliveconn::Packet*)(RooboPacketFactory::GetInstance()->GetPacket((RooboPacket*)packet));
				evt = longliveconn::EventFactory::GetInstance()->ObtainEvent(cloned_packet);
			}

		} else if( event_code == STREAM_EVENT_DISCONNECTED || event_code == STREAM_EVENT_BAD_MAGIC || event_code == STREAM_EVENT_DECRYPT_FAILED){
			evt = longliveconn::EventFactory::GetInstance()->ObtainEvent(STREAM_STATE_DISCONNECTED);
		} else if (event_code == STREAM_EVENT_CONNECTED ){
			evt = longliveconn::EventFactory::GetInstance()->ObtainEvent(STREAM_EVENT_CONNECTED);
		}

		if(evt){
			this->PostEvent(evt);
		}
	}


	void RooboLongLiveConn::Shutdown(){

		if(quit_){
			return;
		}

		roobo::longliveconn::Event * evt = longliveconn::EventFactory::GetInstance()->ObtainEvent(CMD_SHUTDOWN, (void*)NULL);
		this->PostEvent(evt);

		this->thread_->Join();
	}

	const char * RooboLongLiveConn::GetEventString(int id){

		if(id == EVENT_CMD){return "EVENT_CMD";}
		if(id == EVENT_NETWORK_CHANGED){return "EVENT_NETWORK_CHANGED";}
		if(id == EVENT_MESSAGE){return "EVENT_MESSAGE";}
		if(id == EVENT_STREAM_STATE_CHANGED){return "EVENT_STREAM_STATE_CHANGED";}
		if(id == EVENT_PACKET_RECEIVED){return "EVENT_PACKET_RECEIVED";}
		if(id == EVENT_PACKET_TIMEOUT){return "EVENT_PACKET_TIMEOUT";}
		if(id == EVENT_BAD_MAGIC_CODE){return "EVENT_BAD_MAGIC_CODE";}
		if(id == EVENT_UNKNOWN_PROTOCOL){return "EVENT_UNKNOWN_PROTOCOL";}

		return "UNKNOWN_EVENT";
	}

	const char * RooboLongLiveConn::GetStateNameString(longliveconn::StateName name){
		if(name == longliveconn::STATE_AUTHENTICATING) return "STATE_AUTHENTICATING";
		if(name == longliveconn::STATE_CONNECTING) return "STATE_CONNECTING";
		if(name == longliveconn::STATE_DISCONNECTED) return "STATE_DISCONNECTED";
		if(name == longliveconn::STATE_ESTABLISHED) return "STATE_ESTABLISHED";

		return "UNKNOWN_STATE";
	}
}