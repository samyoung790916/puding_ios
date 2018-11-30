#ifndef ROOBO_PACKET_MONITOR_H_
#define ROOBO_PACKET_MONITOR_H_

#include "../common/timer.h"
#include "../tpl/map.h"
#include "../longliveconn/state_machine.h"
#include "../longliveconn/long_live_conn.h"
#include "../longliveconn/packet.h"
#include "../longliveconn/data_types.h"

namespace roobo {

	enum PacketType{
		kUserPacketAck,		// ACK of user packet
		kNormalPacketAck,	// ACK of normal packet
		kPushPacket,		// Push packet from server
		kInvalidPacket		
	};

	class PacketMonitor
	{

	private:

		enum TaskStatus {
			kStatusFinished, // life has finished
			kStatusRunning,	 //
			kStatusPending	// sent and wait for ack
		};

		class DeliveryTask
		{ 

		public:

			TaskStatus status;

			uint64_t sn;						// serial number of the packet

			longliveconn::Packet * packet;		// packet object pointer

			longliveconn::PacketSendFlag flags;	// flags of the packet

			int send_count;						// how many times the packet has been sent

			int action_timer_id;				// timerid for a single send action

			int task_timer_id;					// timerid for a packet sending task

		public: 

			// whether resend the packet on failure
			bool resend() { return HAS_FLAG(flags, roobo::longliveconn::kResendOnFailure); }

			// whether need to report send result
			bool report() { return HAS_FLAG(flags, roobo::longliveconn::kResultReport); }

			// whether ack is expected
			bool expect_ack() { return HAS_FLAG(flags, roobo::longliveconn::kExpectAck); }
		};

	protected:


		static const int kMaxResendCount = 3;

		TimerManager * timer_manager_;

		longliveconn::LongLiveConn * llc_;

		longliveconn::StateMachine * machine_;

		//  key packet sn and delivery task map
		tpl::Map<uint64_t, DeliveryTask> sn_task_map_; // map for normal packet

		// associates timer id and packet sn
		tpl::Map<int, uint64_t> tid_sn_map_;

		tpl::SmartPtr<TimerCallback> * timer_callback_;

	public:

		PacketMonitor(tpl::SmartPtr<TimerCallback> * timer_callback, longliveconn::LongLiveConn * llc, longliveconn::StateMachine * machine);


		virtual ~PacketMonitor(void);

		//
		// Resend pending user packets
		//
		bool ResendPendingUserPackets();

		//
		// Remove normal pending packets (excluding user packets)
		//
		void RemovePendingPackets();

		//
		// Remove all packets
		//
		void RemoveAllPackets();

		//
		// Got called when packet is sent
		//
		bool OnPacketSent(uint64_t sn, bool succeeded);

		//
		// Add user packet task
		//
		void AddPacketTask(longliveconn::Packet * packet, longliveconn::PacketSendFlag flags);

		//
		// Got called when a packet is received
		// return true, if this is ack of any pending user packet
		//
		PacketType OnPacketReceived(longliveconn::Packet * packet);

		//
		// Timer timeout callback
		//
		int OnTimeout(TimeoutArgs * timeout_args);
	};
}
#endif // ROOBO_PACKET_MONITOR_H_