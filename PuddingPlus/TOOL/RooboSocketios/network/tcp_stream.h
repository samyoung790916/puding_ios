#ifndef ROOBO_TCP_STREAM_H_
#define ROOBO_TCP_STREAM_H_

#include "../longliveconn/stream.h"
#include "tcp_socket.h"
#include "../cryptography/cipher_factory.h"
#include "../tpl/vector.h"
#include "../tpl/blocking_queue.h"
#include "../common/mutex.h"
#include "../common/guard.h"
#include "../network/multiplexio.h"


namespace roobo {
	namespace network {

		//
		// The transportation layer, responsible for sending and recieving data,
		// as well as encrypt or decrypt data
		//
		class TcpStream : public roobo::longliveconn::Stream, public roobo::network::IoCallback
		{

			// friend void TcpStreamIoCallback(Socket * socket, int code, void * params);

		protected:

			//
			// Packet parse state
			// phase one: parse header
			// phase two: parse body
			//
			struct PacketParseState
			{
				bool header_parsed;

				// data size needed to the next phase
				int  data_size_needed;

				void Reset(){
					header_parsed = false;
					data_size_needed = 0;
				}
			};

			MultiplexIO * mux_;

			Mutex sock_mutex_;
			Mutex encrypt_cipher_mutex_;
			Mutex decrypt_cipher_mutex_;

			roobo::longliveconn::StreamMode mode_;

			Socket * sock_; // inner socket

			roobo::longliveconn::StreamEventCallbcak * stream_callback_;
			roobo::cryptography::Cipher * encryption_cipher_;	
			roobo::cryptography::Cipher * decryption_cipher_;

			Buffer * buffer_;

			// user to parse packet, and cache data temporarily
			roobo::longliveconn::Packet * packet_; 

			PacketParseState parse_state_;

			tpl::Vector<roobo::longliveconn::ServerAddress> * addresses_;
			bool	connected_;
			int		connect_timeout_;

		public:

			TcpStream(roobo::longliveconn::StreamEventCallbcak * callbcak, roobo::longliveconn::Packet * packet, 
				tpl::Vector<roobo::longliveconn::ServerAddress> * address, int connect_timeout);

			virtual ~TcpStream(void);

			// Close old stream if there is any, and setup new stream
			virtual void Setup(int address_index);

			// close the stream
			virtual void Close();

			// start to connect
			virtual int Connect();

			// write a packe to stream
			virtual int Write(roobo::longliveconn::Packet * packet);

			// write raw data
			virtual int WriteRaw(Buffer * data);

			virtual int WriteRaw(void * data, int len);

			// data read callback
			// return number of additional byte(s) of data needed
			virtual int OnDataRead(void * params, int len);

			// cipher for reading data
			virtual void SetDecryptionCipher(roobo::longliveconn::CipherAlgorithm  algorithm, Buffer * key);

			// cipher for writting data
			virtual void SetEncryptionCipher(roobo::longliveconn::CipherAlgorithm  algorithm, Buffer * key);

			virtual void SetStreamMode(roobo::longliveconn::StreamMode mode);

			virtual bool IsConnected();

			virtual bool OnIoEvent (const IoCallbackArgs & io_callback_args);

		};

	}
}
#endif // ROOBO_TCP_STREAM_H_

