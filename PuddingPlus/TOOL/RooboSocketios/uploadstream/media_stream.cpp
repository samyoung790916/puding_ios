#include "media_stream.h"
#include "../network/multiplexio.h"
#include "stream_proto.h"
#include "../common/log.h"

#define GUARD() Guard guard(&sock_mutex_)

namespace roobo {

	const int kReconnectInterval = 1500;

	MediaStream::MediaStream(const tpl::Vector<roobo::longliveconn::ServerAddress> & addresses)
		: addresses_(addresses), socket_(NULL), connected_(NULL), reconnect_timer_id_(0), last_channel_state_(stream::kChannelAuthenticating)
	{
		thread_ = new Thread(MediaStreamThreadFunc);
		// assert(addresses.Size() > 0);
	}

	MediaStream::~MediaStream(void)
	{
		RB_FREE(proto_);
		RB_FREE(thread_);
	}

	void MediaStream::Init(tpl::SmartPtr<TimerCallback> * smart_ptr)
	{
		if(smart_ptr == NULL){
			return;
		}

		smart_ptr_ = smart_ptr;

		stream::RBS_ServerAddress server_address;
		server_address.address = addresses_[0].address;
		server_address.port = addresses_[0].port;

		stream::RBS_Parameters parameters;
		parameters.AddressSize = 1;
		parameters.addresses = &server_address;

		parameters.upload_pcm_format.channel_num = 2;

		proto_ = new stream::StreamProto(&parameters);

		reconnect_timer_id_ = TimerManager::GetInstance()->AddOnDemandTimer(*smart_ptr_, this);
		recv_buffer_.EnsureCapacity(4096); // TODO: do not harcode

		TimerManager::GetInstance()->ResetTimer(reconnect_timer_id_, kReconnectInterval);

		thread_->Start(this);
	}

	const char * MediaStream::GetCmdCodeString(const CmdCode & code){
		if (code == kSocketConnected) return "kSocketConnected";
		if (code == kSocketDisconnected) return "kSocketDisconnected";
		if (code == kConnectSocket) return "kConnectSocket";
		if (code == kUploadData) return "kUploadData";
		if (code == kDataReceived) return "kDataReceived";
		if (code == kShutdown) return "kShutdown";
		return "unknown";

	}


	void MediaStream::Run()
	{
		while(true){

			Command cmd = cmd_queue_.Take();
			if(!HandleCmd(cmd)){
				break;
			}
		}

		// TODO release resources in queue
	}


	bool MediaStream::HandleCmd(const Command & cmd){

		log_d("HandleCmd %s", GetCmdCodeString(cmd.code));

		if( cmd.code == kConnectSocket ){
			if(!this->Connect()){
				TimerManager::GetInstance()->ResetTimer(reconnect_timer_id_, kReconnectInterval);
			}
		} else if(cmd.code == kSocketDisconnected) {
			
			OnDisconnected();

		} else if(cmd.code == kSocketConnected) {

			if(OnConnected()){
				
			} else {
				OnDisconnected();
			}

		} else if(cmd.code == kUploadData){

			if(cmd.buffer != NULL){
				send_buffer_vct_.PushBack(cmd.buffer);
			}

		} else if(cmd.code == kDataReceived){

			stream::ChannelState state = proto_->OnDataRead(&recv_buffer_);
			
			if(last_channel_state_ != state){
				
				if(state == stream::kChannelEstablished){
					OnEstablished();
				}

				last_channel_state_ = state;
			}
		}

		if(connected_ && send_buffer_vct_.Size() > 0){
			//
			// upload data to server
			//
		}

		return true;
	}


	bool MediaStream::OnConnected(){

		mark();

		Buffer buffer;
		proto_->GetHandshakeData(&buffer);

		log_d("%s Handshake buffer size %d", __PRETTY_FUNCTION__, buffer.size());

		GUARD();

		mark();

		connected_ = true;
			
		// send handshake packet 
		int data_written = socket_->Write(buffer.data(), buffer.size());
		if(data_written != buffer.size()){
			log_e("Send failed, bytes sent %d", data_written);
		}

		return data_written == buffer.size();
	}

	void MediaStream::OnEstablished(){
		mark();
	}

	void MediaStream::OnDisconnected()
	{
		mark();

		GUARD();

		connected_ = false;
		last_channel_state_ = stream::kChannelAuthenticating;

		if(NULL != socket_){
			network::MultiplexIO::GetInstance()->RemoveFd(socket_);
			socket_->Close();
			RB_FREE(socket_);
		}

		TimerManager::GetInstance()->ResetTimer(reconnect_timer_id_, kReconnectInterval);
	}

	bool MediaStream::Connect()
	{
		mark();
		
		GUARD();

		assert(connected_ == false);

		socket_ = new network::TcpSocket(this->addresses_[0], false);
		network::MultiplexIO::GetInstance()->AddFd(socket_, this, NULL);
		bool ret =  socket_->Connect() == 0;
		if(!ret){
			network::MultiplexIO::GetInstance()->RemoveFd(socket_);
			log_e("Connect failed, RemoveFd");
		}

		return ret;
	}


	bool MediaStream::OnIoEvent (const network::IoCallbackArgs & io_callback_args)
	{
		GUARD();

		mark();

		if(io_callback_args.socket != socket_){
			mark();
			return false;
		}

		if(io_callback_args.code == CODE_CONNECTED){
			Command cmd(kSocketConnected);
			cmd_queue_.Offer(cmd);

		} else if(io_callback_args.code == CODE_CLOSED || io_callback_args.code == CODE_CONNECT_TIMEOUT ||
			io_callback_args.code == CODE_ERROR){
				Command cmd(kSocketDisconnected);
				cmd_queue_.Offer(cmd);

		} else if(io_callback_args.code == CODE_READ_READY){

			int dataRead = 0;

			while((dataRead = socket_->Read((void*)recv_buffer_.data(), recv_buffer_.capacity())) > 0 ){

				stream::ChannelState state = proto_->OnDataRead(&recv_buffer_);

				if(state != last_channel_state_){

					if(state == stream::kChannelEstablished){
						this->OnEstablished();
					}
					last_channel_state_ = state;
				}

				recv_buffer_.Clear();				 
			}
		}

		return true;
	}


	int MediaStream::OnTimeout(const TimeoutArgs & timeout_args)
	{
		if(timeout_args.timer_id != reconnect_timer_id_){
			return -1;
		}

		Command cmd(kConnectSocket);
		cmd_queue_.Offer(cmd);

		return 0;
	}


	void * MediaStreamThreadFunc(void * params){
		MediaStream * stream = (MediaStream*)params;
		stream->Run();
		return  NULL;
	}
}
