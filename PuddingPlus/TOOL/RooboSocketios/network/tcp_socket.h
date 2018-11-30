#ifndef MY_TCP_SOCKET_H_
#define MY_TCP_SOCKET_H_

#include "socket.h"


namespace roobo {
	namespace network {

		class TcpSocket : public Socket {

		protected:
			void Init();
			int GetSocketError();

		public: 

			TcpSocket(roobo::longliveconn::ServerAddress & server_address,  bool blocking, int connect_timeout = 5000, int read_timeout = 0);

			virtual ~TcpSocket();

			virtual int Connect();	

			virtual bool IsConnected();

			virtual void Close();

			virtual int Read(void * buffer, int len) ;

			virtual int Write(void * buffer, int len);
		};

	}
}

#endif // MY_TCP_SOCKET_H_
