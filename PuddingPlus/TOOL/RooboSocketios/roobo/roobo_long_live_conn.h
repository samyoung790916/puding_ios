#ifndef MY_ROBOO_LONGLIVECONN_H_
#define MY_ROBOO_LONGLIVECONN_H_

#include "../longliveconn/data_types.h"
#include "../longliveconn/long_live_conn.h"
#include "../longliveconn/state_machine.h"
#include "../longliveconn/event.h"
#include "../longliveconn/auth.h"
#include "../network/tcp_stream.h"

#include "../common/thread.h"
#include "../common/log.h"
#include "../common/buffer.h"
#include "../common/timer.h"

#include "../tpl/blocking_queue.h"
#include "../tpl/vector.h"
#include "../tpl/map.h"

#include "packet_monitor.h"
#include "roobo_types.h"

#include "../network/multiplexio.h"

#include "long_live_conn_api.h"

namespace roobo {

	void * RooboThreadFunc(void * params);

	void StreamEventFunc(int event_code,  longliveconn::Packet * packet);

	//
	// Roobo LongLiveConn implementation
	//
	class RooboLongLiveConn : public longliveconn::LongLiveConn, public longliveconn::StateMachine, 
		public TimerCallback, public longliveconn::StreamEventCallbcak
	{

	protected:

		LongLiveConnApi * api_;

		tpl::Vector<longliveconn::ServerAddress> addresses_;

		tpl::BlockingQueue<longliveconn::Event*> * event_queue_; // working queue

		Thread * thread_;

		longliveconn::Packet * packet_; // packet for stream

		longliveconn::State * state_; // current state 

		tpl::Map<longliveconn::StateName, longliveconn::State*> state_map_;

		longliveconn::NetworkInfo network_info_;

		network::TcpStream * stream_; // network stream

		longliveconn::Auth * auth_;

		TimerManager * timer_manager_;

		PacketMonitor * packet_manager_;

		volatile bool quit_;

		int connect_timer_id_;

		int ping_timer_id_;

		int conn_interval_index_;

		int address_index_;

		static unsigned short reconnect_intervals_[];

		void Run(); // start running the long live connection

		void DoShutdown();

		const char * GetEventString(int id);

		const char * GetStateNameString(longliveconn::StateName name);

		tpl::SmartPtr<TimerCallback> * smart_ptr_container_;

	public:

		RooboLongLiveConn(const tpl::Vector<longliveconn::ServerAddress> & addresses, LongLiveConnApi * api,  longliveconn::Auth *auth);

		virtual ~RooboLongLiveConn(void);


		//====================================================================
		// Functions for StateMachine
		//====================================================================

		//
		// post and event into the state machine
		//
		virtual int PostEvent(const longliveconn::Event * evt);

		//
		// Transit to a state
		//
		virtual void TransitTo(longliveconn::StateName target_state_name);

	 
		virtual longliveconn::State * GetCurrentState();


		//====================================================================
		// Functions for LongLiveConn
		//====================================================================

		virtual void ReportPacketResult(uint64_t sn, longliveconn::PacketResult result, longliveconn::Packet * packet);


		 
		virtual longliveconn::NetworkInfo *  GetNetworkInfo();

		 
		virtual void SetNetworkInfo( longliveconn::NetworkInfo & network_info) ;


		void NotifyNetworkChange( longliveconn::NetworkInfo & network_info) ;

		//
		// Get current stream
		//
		virtual longliveconn::Stream * GetCurrentStream();

		//
		// Setup stream up
		//
		virtual void SetupStream();


		virtual void Shutdown();

		//
		// Send a packet
		//
		virtual bool SendPacket(longliveconn::Packet * packet);


		virtual bool SendPacket(longliveconn::Packet * packet, longliveconn::PacketSendFlag flags);


		 
		virtual bool DoSendPacket(longliveconn::Packet * packet);

		//
		// set up a schedule to connect later
		//
		virtual int ScheduleNextConnect();


		virtual void RemovePendingPackets();

		//
		// Send pending packets, including the ones attempted to send
		//
		bool SendPendingPacket();


		virtual bool Ping();


		// cipher for reading data
		virtual void SetDecryptionCipher(longliveconn::CipherAlgorithm  algorithm, Buffer * key) ;

		// cipher for writting data
		virtual void SetEncryptionCipher(longliveconn::CipherAlgorithm  algorithm, Buffer * key);


		longliveconn::Auth * GetAuth(){return auth_;}


		//====================================================================
		// Functions of stream event
		//====================================================================

		virtual void OnStreamEvent(longliveconn::Stream * stream, int event_code,  longliveconn::Packet * packet);


		//====================================================================
		// Functions of timer callback
		//====================================================================

		int OnTimeout(const TimeoutArgs & timeout_args);


		 

		//====================================================================
		// Functions of own's
		//====================================================================

		bool Init(tpl::SmartPtr<TimerCallback> * smart_ptr_container);

		// define friend function
		friend  void * RooboThreadFunc(void * params);
	};

}
#endif // MY_ROBOO_LONGLIVECONN_H_
