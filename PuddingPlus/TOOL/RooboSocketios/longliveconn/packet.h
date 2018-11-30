#ifndef ROOBO_PACKET_H_
#define ROOBO_PACKET_H_

#include "../common/platform.h"
#include "../common/buffer.h"
#include "header.h"
#include "data_types.h"

namespace roobo {

	namespace longliveconn {

		class Packet {

		protected:
			Header  * header_;
			roobo::Buffer  body_;

		public: 

			virtual ~Packet(){
			}

			roobo::Buffer & GetBody()  {
				return body_;
			}

			virtual uint64_t GetSn() = 0;

			Header * GetHeader(){
				return header_;
			}

			virtual void Clear(){ 		
				body_.Clear();
				if(header_){
					header_->Clear();
				}
			}

			virtual void Deserialize(roobo::Buffer * buffer) = 0;

			virtual void Serialize(roobo::Buffer * buffer) = 0;

		};

	}

}
#endif // ROOBO_PACKET_H_