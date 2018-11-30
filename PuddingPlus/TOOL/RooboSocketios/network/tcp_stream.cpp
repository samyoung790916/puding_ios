#include "tcp_stream.h"
#include "../common/log.h"
#include "../tpl/map.h"

#define BUFFER_SIZE 4096

#define GUARD_SOCK() Guard guard_s(&sock_mutex_)

#define GUARD_DCRYPT_CIPHER() Guard guard_r(&decrypt_cipher_mutex_)

#define GUARD_ENCRYPT_CIPHER() Guard guard_w(&encrypt_cipher_mutex_)

namespace roobo {
	namespace network {

		TcpStream::TcpStream(roobo::longliveconn::StreamEventCallbcak * callback, roobo::longliveconn::Packet * packet, 
			tpl::Vector<roobo::longliveconn::ServerAddress> * address, int connect_timeout)
			:mux_ (MultiplexIO::GetInstance()), mode_(roobo::longliveconn::kActiveOnce),
			sock_(NULL), stream_callback_(callback), encryption_cipher_(NULL), decryption_cipher_(NULL),
			packet_(packet), addresses_(address), connected_(false), connect_timeout_(connect_timeout)
		{
			assert(address && address->Size() > 0 && packet);

			log_d("TcpStream address provided: %s %d", (*addresses_)[0].address, (*addresses_)[0].port);

			parse_state_.Reset();
			parse_state_.data_size_needed = packet_->GetHeader()->GetSize();

			buffer_ = new Buffer(BUFFER_SIZE);
		}

		TcpStream::~TcpStream(void)
		{
			Close();

			{
				RB_FREE(buffer_);

				{
					GUARD_DCRYPT_CIPHER();
					GUARD_ENCRYPT_CIPHER();
					roobo::cryptography::CipherFactory::GetInstance()->RecycleCipher(&decryption_cipher_);
					roobo::cryptography::CipherFactory::GetInstance()->RecycleCipher(&encryption_cipher_);
				}
			}
		}

		void TcpStream::Setup(int address_index){

			if(address_index < 0 || address_index >= addresses_->Size()){
				address_index = address_index % addresses_->Size();
			}

			{
				GUARD_SOCK();

				roobo::longliveconn::ServerAddress * sa = &(*addresses_)[address_index];

				log_d("TcpStrimg:Setup address index %d %s : %d", address_index, sa->address, sa->port);

				assert(sock_ == NULL);

				sock_ = new TcpSocket(*sa, false, connect_timeout_);

				log_d("TcpStrimg:Setup fd = %d", sock_->GetFD());

				mux_->AddFd(sock_, this, this);
			}


			{
				GUARD_DCRYPT_CIPHER();
				GUARD_ENCRYPT_CIPHER();

				roobo::cryptography::CipherFactory::GetInstance()->RecycleCipher(&decryption_cipher_);
				roobo::cryptography::CipherFactory::GetInstance()->RecycleCipher(&encryption_cipher_);

				decryption_cipher_ = roobo::cryptography::CipherFactory::GetInstance()->GetCipher(roobo::longliveconn::CA_PLAIN, NULL);
				encryption_cipher_ = roobo::cryptography::CipherFactory::GetInstance()->GetCipher(roobo::longliveconn::CA_PLAIN, NULL);
			}
		}

		// close the stream
		void TcpStream::Close()
		{
			if(sock_ == NULL){
				return;
			}

			mux_->SyncRemoveFd(sock_);
			{
				GUARD_SOCK();
				sock_->Close();
				RB_FREE(sock_);
			}
		}

		// start to connect
		int TcpStream::Connect()
		{
			GUARD_SOCK();

			if(sock_){
				return sock_->Connect();
			}

			return -1;
		}

		//
		// write a packet to stream
		// TODO: do not hardcode error constant
		//
		int TcpStream::Write(roobo::longliveconn::Packet * packet){

			if(NULL == packet){
				return -1;
			}

			if(!this->IsConnected()){
				log_e("%s stream is not connected yet", __FILE__);
				return -2;
			}

			if(packet == NULL || packet->GetHeader() == NULL ){
				log_e("%s packet or packet->header is null", __FILE__);
				return -3;
			}

			//log_e("%s:%d pre encrypt size %d", __FILE__, __LINE__, packet->GetBody().size());
			packet->GetHeader()->Dump();
			log_e("GetBody:%s", packet->GetBody().data());
			if(!packet->GetHeader()->IsHeartbeat())
			{
				GUARD_ENCRYPT_CIPHER();
				if(!encryption_cipher_->Encrypt(&packet->GetBody())){
					log_e("%s Encrypt failed", __FILE__);
					return -4;
				}
			}

			Buffer buf;
			log_e("buf:%s", buf.data());
			// cache data into a buffer
			packet->Serialize(&buf);

			//log_e("%s:%d Serialize data size %d", __FILE__, __LINE__, buf.size());

			// send to stream
			int err = this->WriteRaw(&buf);

			if(err != buf.size()){
				log_e("%s:%d Failed to write body", __FILE__, __LINE__);
				return -5;
			}

			// no data is written
			if(err == 0){
				log_e("%s:%d No data is written", __FILE__, __LINE__);
				return -6;
			}

			return err;
		}

		int TcpStream::WriteRaw(Buffer * data){

			if(data == NULL){
				return -1;
			}

			GUARD_SOCK();

			if(!sock_->IsConnected()){
				return -2;
			}

			return sock_->Write(data->data(), data->size());
		}

		int TcpStream::WriteRaw(void * data, int len) {

			if(data == NULL || len <= 0){
				return -1;
			}

			GUARD_SOCK();

			if(!sock_->IsConnected()){
				return -2;
			}

			return sock_->Write(data, len);
		}


		// cipher for reading data
		void TcpStream::SetDecryptionCipher(roobo::longliveconn::CipherAlgorithm  algorithm, Buffer * key){

			if(key == NULL){
				return;
			}

			GUARD_DCRYPT_CIPHER();

			if(decryption_cipher_->GetName() == algorithm){
				return;
			}

			log_e("decryption_cipher_:%s", key->data());
			
			roobo::cryptography::CipherFactory::GetInstance()->RecycleCipher(&decryption_cipher_);
			decryption_cipher_ = roobo::cryptography::CipherFactory::GetInstance()->GetCipher(algorithm, key);
		}

		// cipher for writting data
		void TcpStream::SetEncryptionCipher(roobo::longliveconn::CipherAlgorithm  algorithm, Buffer * key){

			if(key == NULL){
				return;
			}

			GUARD_ENCRYPT_CIPHER();

			log_e("encryption_cipher_:%s ", key->data());

			if(encryption_cipher_->GetName() == algorithm){
				return;
			}

			roobo::cryptography::CipherFactory::GetInstance()->RecycleCipher(&encryption_cipher_);
			encryption_cipher_ = roobo::cryptography::CipherFactory::GetInstance()->GetCipher(algorithm, key);
		}


		void TcpStream::SetStreamMode(roobo::longliveconn::StreamMode mode){

			GUARD_SOCK();

			mode_ = mode;
			// To pase the packet received
			if(mode_ == roobo::longliveconn::kActive && buffer_->size() > 0){
				OnDataRead(NULL, buffer_->size());
			}
		}


		// data read callback
		// return number of additional byte(s) of data needed
		int TcpStream::OnDataRead(void * params, int len) {

			if(mode_ == roobo::longliveconn::kPause){
				mark();
				return 1;
			}

			roobo::longliveconn::Header * header = packet_->GetHeader();

			int ret = 0;

			while (ret == 0) {

				if(!parse_state_.header_parsed ){

					if(buffer_->size() < parse_state_.data_size_needed){
						ret = parse_state_.data_size_needed - buffer_->size();
						mark();
						break;
					}

					// parse header
					if(header->Parse(buffer_->data(), header->GetSize())){				
						parse_state_.header_parsed = true;
						buffer_->ShrinkFront(header->GetSize());
						parse_state_.data_size_needed = header->GetBodyLen();
						//log_d("TcpStream: header parsed, body len %d", header->GetBodyLen());
						header->Dump();
					} else {
						log_e("TcpStream: Failed to parse header !!!");
						ret = -1;
						break;			
					}
				}

				//
				// TODO: consider the situation when data is partially arrived, network may be gone, we can detect it earlier
				// a timer is needed to check the situation
				//

				if(parse_state_.header_parsed){ // header is done, body is not yet, and data is enough

					if(buffer_->size() < parse_state_.data_size_needed){
						ret = parse_state_.data_size_needed - buffer_->size();
						break;
					}

					packet_->GetBody().Append(buffer_->data(), header->GetBodyLen());
					buffer_->ShrinkFront(header->GetBodyLen());

					bool decrypt_ok = true;
					bool bflag = header->IsHeartbeat();
					
					if(!bflag)
					{
						GUARD_DCRYPT_CIPHER();
						roobo::Buffer buf_body = packet_->GetBody();
						
						log_e("buf_body_len:%d", buf_body.size());
						decrypt_ok = decryption_cipher_->Decrypt(&buf_body);
						log_e("def_body:%s", buf_body.data());
						log_e("def_body_len:%d", buf_body.size());
						packet_->GetBody().Clear();
						log_e("buf_body0:%s", buf_body.data());
						packet_->GetBody().Assign(buf_body.data(), buf_body.size());
					}
					else
					{
						log_e("bflag is true");
					}

					if(decrypt_ok){
						header->SetBodyLen((unsigned short)packet_->GetBody().size());

						// Notify new packet
						this->stream_callback_->OnStreamEvent(this, STREAM_EVENT_PACKET_READ, packet_);			

						packet_->Clear();
						parse_state_.Reset();
						parse_state_.data_size_needed = header->GetSize();

						if(mode_ == roobo::longliveconn::kActiveOnce){
							mode_ = roobo::longliveconn::kPause;
						}

					} else {
						log_e("TcpStream: Failed to decrypt body !!!");
						ret = -2;
						break;
					}
				}
			}

			if(ret < 0){
				packet_->Clear();
				buffer_->Clear();

				parse_state_.Reset();
				parse_state_.data_size_needed = header->GetSize();
			}

			return ret;
		}

		bool TcpStream::IsConnected(){
			return connected_;
		}


		// void StreamCallback(IoCallbackArgs * io_callback_args);
		bool TcpStream::OnIoEvent(const IoCallbackArgs & io_callback_args){

			GUARD_SOCK();

			Socket * socket = io_callback_args.socket;

			int code = io_callback_args.code;

			// the case sokcet is closed or different socket
			if(sock_ == NULL ){
				mark();
				return false;
			}

			if( socket != sock_){
				mark();
				return false;
			}

			bool success = true;

			if(code == CODE_CLOSED || code == CODE_CONNECT_TIMEOUT){
				stream_callback_->OnStreamEvent(this, STREAM_EVENT_DISCONNECTED, NULL);
				success = connected_ = false;
			} else if(code == CODE_CONNECTED) {
				stream_callback_->OnStreamEvent(this, STREAM_EVENT_CONNECTED, NULL);
				connected_ = true;
			} else if(code == CODE_READ_READY) {		
				connected_ = true;

				int dataRead = 0;
				bool first_read = true;

				do{

					if(buffer_->free_space() < BUFFER_SIZE){
						buffer_->EnsureCapacity(BUFFER_SIZE * 2);
					}

					dataRead = sock_->Read(buffer_->data() + buffer_->size(), BUFFER_SIZE);

					log_d("TcpStream: data read %d", dataRead);

					if(dataRead == 0 && first_read){
						stream_callback_->OnStreamEvent(this, STREAM_EVENT_DISCONNECTED, NULL);
						success = connected_ = false;
						break;
					}

					first_read = false;

					// error, it is closed
					if(dataRead < 0){
						stream_callback_->OnStreamEvent(this, STREAM_EVENT_DISCONNECTED, NULL);
						success = connected_ = false;
						break;
					}

					buffer_->GrowSize(dataRead);

					int ret = OnDataRead(buffer_, dataRead);

					if (ret < 0){						
						stream_callback_->OnStreamEvent(this, STREAM_EVENT_BAD_MAGIC, NULL);
						success = connected_ = false;
						break;

					} else if(ret > 0 ){
						// log_d("TcpStream: extra data needed to parse packet: %d", ret);
					}

				}while(dataRead == BUFFER_SIZE);
			} 

			return success;
		}
	}
}