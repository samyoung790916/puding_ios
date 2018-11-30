#ifndef __ROOBO_MEDIA_STREAM_H_
#define __ROOBO_MEDIA_STREAM_H_

#include "../network/multiplexio.h"
#include "../tpl/vector.h"
#include "../common/mutex.h"
#include "../common/buffer.h"
#include "../common/timer.h"
#include "../network/tcp_socket.h"
#include "../tpl/blocking_queue.h"
#include "../common/thread.h"
#include "../common/guard.h"
#include "../tpl/smart_ptr.h"
#include "proto.h"


namespace roobo {

	void * MediaStreamThreadFunc(void * params);

	class MediaStream : public network::IoCallback, public TimerCallback
	{

	private:

		enum CmdCode{
			kSocketConnected = 1,
			kSocketDisconnected = 2,
			kConnectSocket = 3,
			kUploadData = 4,
			kDataReceived = 5,
			kShutdown = 6
		};


		struct Command {
			CmdCode code;
			Buffer * buffer;
		public:
			Command()
				: buffer(NULL)
			{
			}

			explicit Command(CmdCode cmdCode)
				: code(cmdCode), buffer(NULL)
			{

			}
			explicit Command(Buffer * dataBuffer)
				: code(kUploadData), buffer(dataBuffer)
			{

			}
		};

		network::TcpSocket * socket_;

		Mutex sock_mutex_;

		Buffer recv_buffer_;

		tpl::BlockingQueue<Command> cmd_queue_;

		tpl::SmartPtr<TimerCallback> * smart_ptr_;

		tpl::Vector<Buffer*> send_buffer_vct_;

		Thread * thread_;

		tpl::Vector<roobo::longliveconn::ServerAddress> addresses_;

		bool connected_;

		bool Connect();

		void OnDisconnected();

		bool OnConnected();

		void OnEstablished();

		bool HandleCmd(const Command & cmd);

		int reconnect_timer_id_;

		stream::Proto * proto_;

		stream::ChannelState last_channel_state_;

		const char * GetCmdCodeString(const CmdCode & code);

	public:

		explicit MediaStream(const tpl::Vector<roobo::longliveconn::ServerAddress> & addresses);

		void Init(tpl::SmartPtr<TimerCallback> * smart_ptr);

		void Run();

		virtual bool OnIoEvent (const network::IoCallbackArgs & io_callback_args);

		virtual int OnTimeout(const TimeoutArgs & timeout_args);

		virtual ~MediaStream(void);
	};
}

 
#endif // __ROOBO_MEDIA_STREAM_H_
