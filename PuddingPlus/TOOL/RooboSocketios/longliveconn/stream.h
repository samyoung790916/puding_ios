#ifndef ROOBO_STREAM_H_
#define ROOBO_STREAM_H_ 

#include "packet.h"

#define STREAM_STATE_CONNECTED		 1
#define STREAM_STATE_DISCONNECTED	 2


#define STREAM_EVENT_CONNECTED		1
#define STREAM_EVENT_DISCONNECTED	2
#define STREAM_EVENT_PACKET_READ	3 // a packet is read
#define STREAM_EVENT_BAD_MAGIC		4
#define STREAM_EVENT_DECRYPT_FAILED 5

namespace roobo {

	namespace longliveconn {

		class Stream;

		//
		// Got called when stream event fired: connected, disconnected, data available
		// Callee is responsible for free the memory
		//

		class StreamEventCallbcak{

		public:
			virtual void OnStreamEvent(Stream * stream, int event_code,  Packet * packet) = 0;
		};


		//
		// Stream Mode is used to do flow control
		// If new decryption key would be assigned after aauthentication,
		// read thread should not decrypt arrived data (arrived earlier before auth result returned) with old cipher and key
		// If there is no flow control, such data may be decrypted incorrectly 
		//
		enum StreamMode
		{
			kActive,	// Decode packet actively
			kPause,		// Do not decode packet
			kActiveOnce, // Decode only one packet, and then switch to Pause mode
		};


		//
		// Abstracted Data Stream Transportation Layer:
		// Monitor transportation state change (connected, disconnected)
		// Read/decrypt and write/encrypt data
		//
		class Stream {

		public :

			virtual ~Stream() {};

			// Close old stream if there is any, and setup new stream
			virtual void Setup(int address_index) = 0;

			// close the stream
			virtual void Close() = 0;

			// start to connect
			virtual int Connect() = 0;

			// write a packe to stream
			virtual int Write(Packet * packet) = 0;

			// write raw data
			virtual int WriteRaw(Buffer * data) = 0;


			virtual int WriteRaw(void * data, int len) = 0;

			// data read callback
			// return number of additional byte(s) of data needed
			virtual int OnDataRead(void * params, int len) = 0;

			// cipher for reading data
			virtual void SetDecryptionCipher(CipherAlgorithm  algorithm, Buffer * key) = 0;

			// cipher for writting data
			virtual void SetEncryptionCipher(CipherAlgorithm  algorithm, Buffer * key) = 0;

			virtual void SetStreamMode(StreamMode mode) = 0;

			virtual bool IsConnected() = 0;

		};

		const char * StreamCodeToString(int code);

	}
}

#endif // ROOBO_STREAM_H_