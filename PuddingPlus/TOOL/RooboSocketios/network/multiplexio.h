#ifndef ROOBO_MULTIPLEXIO_H_
#define ROOBO_MULTIPLEXIO_H_

#include "socket.h"
#include "../common/semaphore.h"
#include "../tpl/smart_ptr.h"

#define MAX_FD 50

#define CODE_READ_READY 			1 	// data is available for read
#define CODE_WRITE_READY 			2	// ready to write data
#define CODE_CONNECTED				4	// stream connected
#define CODE_CLOSED					8	// stream closed
#define CODE_ERROR					16	// error happens
#define CODE_CONNECT_TIMEOUT		32	// timeout

namespace roobo {

	namespace network {

		struct IoCallbackArgs
		{
			Socket * socket;
			int code;
			void * params;
		};


		class IoCallback {

		public:

			virtual ~IoCallback(){}

			//
			// Got called on Io event 
			//
			virtual bool OnIoEvent (const IoCallbackArgs & io_callback_args) = 0;
		};

		struct SyncRemoveReq
		{
			Socket * socket;
			Semaphore semaphore;
		};

		/***
		* Muliplexing IO
		*/
		class MultiplexIO {

		protected:
			static MultiplexIO * _instance;

		public:

			virtual ~MultiplexIO(){}

			virtual void AddFd(Socket * socket, IoCallback * callback, void * params) = 0;

			virtual void RemoveFd(Socket * socket) = 0;

			// Remove Fd synchronously
			virtual void SyncRemoveFd(Socket * socket) = 0;

			//
			// Get an single instance of MUX
			// TODO: MT unsafe
			//
			static MultiplexIO * GetInstance();		
		};
	}
}


#endif // ROOBO_MULTIPLEXIO_H_
