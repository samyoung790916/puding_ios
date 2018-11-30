#include "socket_state.h"
#include "../common/log.h"
#include "../common/utils.h"
#include "../common/atomic.h"

namespace roobo {
	namespace network {

		SocketState::SocketState( Socket * socket, IoCallback * callback,  void * params)
			: socket_(socket), callback_(callback), params_(params), add_time_(get_monotonic_time()), last_data_recv_time_(0), connected_(false)
			
		{			
				
		}


		SocketState::SocketState()
		: socket_(NULL), callback_(NULL), params_(NULL), add_time_(0), last_data_recv_time_(0), connected_(false)
		{

		}
 
		SocketState::~SocketState(){

		}

		bool SocketState::IsConnectTimedout(){
			
			if(this->connected_){
				return false;
			}
			
			if(socket_ != NULL){
				return( get_monotonic_time() -  this->add_time_ > socket_->GetConnectTimeout());
			}

			return false;
		}

		bool SocketState::IsReadTimedout(){
			if(socket_ != NULL){
				return (get_monotonic_time() -  this->last_data_recv_time_ > socket_->GetReadTimeout());
			}

			return false;
		}

		void SocketState::onDataReceived(){ 
			last_data_recv_time_ = get_monotonic_time(); 
		}


		bool SocketState::ExecuteCallback(int code){

			if(callback_ == NULL){
				mark();
				return false;
			}

			IoCallbackArgs io_callback_args;
			io_callback_args.socket = socket_;
			io_callback_args.code = code;
			io_callback_args.params = params_;
			
			return callback_->OnIoEvent(io_callback_args);
		}
	}
}