#ifndef _MY_SOCKET_STATE_H_
#define _MY_SOCKET_STATE_H_

#include "multiplexio.h"

namespace roobo {
	namespace network {

		class SocketState
		{

		protected:
			Socket * 		socket_;
			IoCallback 	*	callback_;
			void *			params_;
			long			add_time_;  // the time we add the Fd, used to compute connect timeout
			long			last_data_recv_time_; // last time receive data 
			bool			connected_; //

		public:

			~SocketState();

			SocketState();

			SocketState(Socket * socket, IoCallback * callback, void * params);

			Socket * GetSocket(){return socket_;}

			IoCallback * GetCallback(){return callback_;}

			bool IsConnected(){return connected_;}

			void SetIsConnected(bool connected){ connected_ = connected;}

			bool IsConnectTimedout();

			bool IsReadTimedout();

			void onDataReceived();

			void * GetParams(){return params_;}

			bool ExecuteCallback(int code);
		};
	}
}
#endif // _MY_SOCKET_STATE_H_

