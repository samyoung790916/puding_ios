#ifndef MY_LLC_HEADER1_H_
#define MY_LLC_HEADER1_H_

#include "../common/buffer.h"
#include <stdint.h>

namespace roobo {

	namespace longliveconn {

		//
		// Head of a packet, concrete head must inherit the class
		//
		class Header {

		public :

			virtual ~Header(){}

			// Get fxied header size
			virtual int GetSize() = 0;

			// Parse header
			virtual bool Parse(const void * data, int size) = 0;

			// Wether this is a ping packet
			virtual bool IsHeartbeat() = 0;

			virtual uint16_t GetBodyLen() = 0; 

			virtual void SetBodyLen(uint16_t len) = 0;

			virtual void Clear() = 0;

			virtual void Deserialize(Buffer * buffer) = 0;

			virtual void Serialize(Buffer * buffer) = 0;

			virtual void SetFlags(int flag) = 0;

			virtual uint8_t GetCategory() = 0;

			virtual void Dump() = 0;

		};

	}
}

#endif // MY_LLC_HEADER1_H_