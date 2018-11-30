
#ifndef ROOBO_SOCKET_H_
#define ROOBO_SOCKET_H_

#include "../longliveconn/data_types.h"

namespace roobo {
	namespace network {

		enum SocketType {
			kTCP = 0,
			kUDP = 1,
		};

		class Socket {

		protected:
			int connect_timeout_;
			int read_timeout_;
			roobo::longliveconn::ServerAddress address_;
			int fd_;
			SocketType sock_type_; 
			bool blocking_;

		public:

			Socket(roobo::longliveconn::ServerAddress & address, SocketType sock_type, bool blocking, int connect_timeout = 5000, int read_timeout = 0):
				connect_timeout_(connect_timeout),
				read_timeout_(read_timeout),
				address_(address),
				fd_(-1),
				sock_type_(sock_type),
				blocking_(blocking){			 
			
			}

			virtual ~Socket(){

			}

			virtual int Connect() = 0;

			virtual void Close() = 0 ;

			virtual bool IsConnected()  = 0;

			virtual int Read(void * buffer, int len) = 0;

			virtual int Write(void * buffer, int len) = 0;

			int GetSockType()  {return sock_type_;}

			int GetConnectTimeout()  {return connect_timeout_;}

			int GetReadTimeout()  {return read_timeout_;}

			int GetFD()  {return fd_;} 

			int GetPort()  {return address_.port; }

			roobo::longliveconn::ServerAddress & GetAddress()  {return address_;}

		};

	}
}


#endif /* ROOBO_SOCKET_H_ */
