
#include "tcp_socket.h"


#include <unistd.h>
#include <memory.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/socket.h>

#include <arpa/inet.h>

#include <netdb.h>

#include "../common/log.h"
#include "../common/utils.h"

namespace roobo {
	namespace network {

		TcpSocket::TcpSocket(::roobo::longliveconn::ServerAddress & server_address,  bool blocking, int connect_timeout, int read_timeout)
			: Socket(server_address, kTCP, blocking, connect_timeout, read_timeout){

				Init();
		}


		void TcpSocket::Init(){

			bool init_result = false;

			do{

				fd_ = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);

				if(fd_ <0){
					log_d("%s socket failed", __FILE__);
					break;
				}

				if(!blocking_){
					int x = fcntl(fd_, F_GETFL,0);
					if(-1 == x){
						log_d("fcntl get failed");
						break;
					}
					x = fcntl(fd_, F_SETFL, x | O_NONBLOCK );
					if(-1 == x){
						log_d("fcntl set failed");
						break;
					}
					log_d("set as non-blocking ok");
				}


				//
				// TODO: nolinger, keep alive, proper write buffer size
				//

				// struct timeval timeout;    
				// timeout.tv_sec = _read_timeout / 1000;    
				// timeout.tv_usec = (_read_timeout % 1000) * 1000;

				int keep_alive = 1;
				int buffer_size = 0;
				
				socklen_t sock_len = sizeof(buffer_size);

				if(setsockopt(fd_, SOL_SOCKET, SO_KEEPALIVE, &keep_alive, sizeof(keep_alive))){
					log_d("setsockopt failed");
				}
				
				if(0 == getsockopt(fd_, SOL_SOCKET, SO_RCVBUF, &buffer_size, &sock_len)){
					log_d("SO_RCVBUF %d", buffer_size);
				}

				sock_len = sizeof(buffer_size);
				if(0 == getsockopt(fd_, SOL_SOCKET, SO_SNDBUF, &buffer_size, &sock_len)){
					log_d("SO_SNDBUF %d", buffer_size);
				}

				init_result = true;

			}while(0);

			if(!init_result){
				Close();
			}
		}

		int TcpSocket::Connect(){

			int ret = -1;

			do{

				struct hostent *he;
				struct in_addr **addr_list;
				
				he = gethostbyname(address_.address);
				if(NULL == he){
					log_e("gethostbyname failed, err %d %s", h_errno, hstrerror(h_errno));
					break;
				} 

				addr_list = (struct in_addr **)he->h_addr_list;

				struct sockaddr_in stSockAddr;    
				memset(&stSockAddr, 0, sizeof(struct sockaddr_in));    
				stSockAddr.sin_family = AF_INET;    
				stSockAddr.sin_port = htons((unsigned short)address_.port);    

				int len = 0;
				while(addr_list[len]){
					len ++;
				}

				// pick up a random address
				int addr_index = rand() % len;

				log_d("pick up address %s", inet_ntoa(*addr_list[addr_index]));

				memcpy(&stSockAddr.sin_addr, addr_list[addr_index], sizeof(struct in_addr));

				if (::connect(fd_, (const struct sockaddr *)&stSockAddr, sizeof(struct sockaddr_in))) {        
					if(EINPROGRESS != errno){
						log_d("connect failed %d %s",  errno,   strerror(errno));
						break;
					}
					log_d("%s EINPROGRESS", __FILE__);
				}

				ret = 0;

			}while(0);

			if(ret){
				// log_d("%s %d close fd %d",__FILE__, __LINE__, fd_);
				Close();
			}

			return ret;
		}


		void TcpSocket::Close(){
			if(fd_ > 0){
				log_d("%s %d close fd %d",__FILE__, __LINE__, fd_);
				close(fd_);
				fd_ = -1;
			}
		}

		bool TcpSocket::IsConnected()  {

			sockaddr addr;
			socklen_t len = sizeof(sockaddr);
			int err = getpeername (fd_, &addr, &len);
			if(err){
				log_d("getpeername failed: %d, %s", errno, strerror(errno));
				return false;
			} 

			return true;
		}


		int TcpSocket::Read(void * buffer, int len)  {

			if(NULL == buffer || len <= 0){
				return 0;
			}

			int ret = recv(fd_, buffer, len, 0);

#ifdef SIMULATE_INVALID_SOCK_DATA
		 
			if(ret > 0){

				int factor = rand() % 5;

				if(factor == 0){ // bad magic
					rand_bytes((unsigned char*)buffer, 0, ret);
				} else if (factor == 1){ // incorrect length
					rand_bytes((unsigned char*)buffer, 8, 8);
				} else if(factor == 2){ // incorrect data
					rand_bytes((unsigned char*)buffer, 18, ret - 18);
				} else if(factor == 3){ // miss one byte
					ret --;
				}  
			}
#endif

			if(ret > 0){		

				DUMP_HEX_EX("SOCK READ", buffer, ret);

			} else  {
				int sock_err = GetSocketError();
				log_e("TcpSocket::Read sock_err %d", sock_err);
			}

			return ret;
		}


		int TcpSocket::Write(void * buffer, int len)  {

			if(NULL == buffer || len <= 0){
				return 0;
			}

			int ret = send(fd_, buffer, len, 0);
			log_e("send %d, len:%d", ret, len);
			DUMP_HEX_EX("SOCK WRITE", buffer, ret);

			return ret;
		}


		TcpSocket::~TcpSocket(){
			Close();
		}

		int TcpSocket::GetSocketError(){
			int error_code = 0;
			socklen_t error_code_size = sizeof(error_code);
			getsockopt(fd_, SOL_SOCKET, SO_ERROR, &error_code, &error_code_size);
			return error_code;
		}
	}
}