#include "selector.h"
#include "socket_state.h"

#include <memory.h>

#if defined(ANDROID) || defined(__ANDROID__)
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <linux/socket.h>
#include <sys/socket.h>
#endif

#include <sys/cdefs.h>
#include <sys/types.h>

#include <errno.h>
#include <sys/time.h>


#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#include "../common/guard.h"
#include "../common/log.h"
#include "../common/utils.h"

namespace roobo {
    namespace network {
        
        Selector::Selector() : fd_updated_(false), shutdown_(false) {
            
            FD_ZERO(&read_set_);
            FD_ZERO(&write_set_);
            FD_ZERO(&err_set_);
            
            thread_ = new Thread(SelectorFunc);
            thread_->Start(this);
        }
        
        Selector::~Selector(){
            
            shutdown_ = true;
            delete thread_;
        }
        
        
        void Selector::AddFd(Socket * socket, IoCallback * callback,  void * params){
            
            if(NULL == socket || callback == NULL){
                log_e("selector.AddFd has invalid arguments");
                return;
            }
            
            Guard guard(&mutex_);
            
            if(map_.ContainsKey(socket)){
                mark();
                // already added
                return;
            }
            
            log_d("Selector::AddFd %d, %s : %d", socket->GetFD(), socket->GetAddress().address, socket->GetPort());
            
            SocketState * sock_state = new SocketState(socket, callback, params);
            
            map_.Put(socket, sock_state);
            
            fd_updated_ = true;
        }
        
        void Selector::RemoveFd( Socket * socket){
            this->DoRemoveFd(socket, true);
        }
        
        void Selector::SyncRemoveFd(Socket * socket){
            RemoveFd(socket);
        }
        
        void Selector::DoRemoveFd( Socket * socket, bool acquireLock){
            
            if(acquireLock){
                mutex_.Lock();
            }
            
            SocketState **  sock_state = map_.Get(socket);
            
            if(sock_state != NULL){
                
                log_d("selector.removeFd %s : %d", socket->GetAddress().address, socket->GetPort());
                
                delete *sock_state;
                *sock_state = NULL;
                
                map_.Remove(socket);
                fd_updated_ = true;
            }
            
            if(acquireLock){
                mutex_.Unlock();
            }
        }
        
        
        void Selector::RefreshFdSet(int & maxFd){
            
            tpl::Pair< Socket*, SocketState*> * cursor;
            
            Guard guard(&mutex_);
            
            maxFd = 0;
            
            fd_updated_ = false;
            
            FD_ZERO(&read_set_config_);
            FD_ZERO(&write_set_);
            FD_ZERO(&err_set_);
            
            tpl::MapIterator< Socket*, SocketState*> it(map_);
            cursor = it.Next();
            
            while(cursor){
                
                int fd = cursor->key()->GetFD();
                
                if(fd > maxFd){
                    maxFd = fd;
                }
                
                log_d("set fd %d", fd);
                
                FD_SET(fd, &read_set_config_);
                FD_SET(fd, &write_set_);
                FD_SET(fd, &err_set_);
                

				// DUMP_HEX_EX("RefreshFdSet", &read_set_, sizeof(read_set_));

                cursor = it.Next();
            }
            
            if(maxFd > 0){
                maxFd ++;
            }
        }
        
        
        
        void Selector::HandleIoEvent(){
            
            //
            // TODO: Do not hold mutex when calling back, potential deak lock
            //
            mutex_.Lock();
            
            tpl::MapIterator<Socket*, SocketState*> it(map_);
            tpl::Pair<Socket*, SocketState*> * cursor = it.Next();
            
            while(cursor){
                
                Socket * sock = cursor->key();
                SocketState * sock_state = cursor->value();
                
                // log_d("%s fd %d", __PRETTY_FUNCTION__, sock->GetFD());
                
                int fd = sock->GetFD();
                
                if(FD_ISSET(fd, &read_set_)){
                    
                    log_d("READ_READY");
                    
                    // FD_CLR(fd, &read_set_);
                    
                    if(!sock_state->IsConnected()){
                        sock_state->SetIsConnected(true);
                        QueueCallbackTask(sock_state, CODE_CONNECTED);
                    }
                    
                    if(!sock_state->ExecuteCallback(CODE_READ_READY)){
						// TODO: notify that socket has been closed
						this->socket_to_remove_.PushBack(sock);
					}
                    
                   // FD_SET(fd, &read_set_);
                }
                
                if (FD_ISSET(fd, &write_set_)){
                    
                    // log_d("WRITE_READY");
                    
                    //FD_CLR(fd, &write_set_);
                    
                    sockaddr addr;
                    socklen_t len = {0};
                    int err = getpeername (fd, &addr, &len);
                    if(!sock_state->IsConnected()){
                        if(err == 0){
                            sock_state->SetIsConnected(true);
                            QueueCallbackTask(sock_state, CODE_CONNECTED);
                        }
                    } else {
                        if(err != 0) {
                            socket_to_remove_.PushBack(sock);
                            QueueCallbackTask(sock_state, CODE_CLOSED);
                        }
                    }
                    
                    // sock_state->ExecuteCallback(CODE_WRITE_READY);
                    
                    // FD_SET(fd, &write_set_);
                }
                
                
                if (FD_ISSET(fd, &err_set_)) {
                    
                    //log_d("ERROR_READY");
                    
                    FD_CLR(fd, &err_set_);
                    
                    QueueCallbackTask(sock_state, CODE_ERROR);
                    
                    //FD_SET(fd, &err_set_);
                }
                
                cursor = it.Next();
            }
            
            mutex_.Unlock();
            
            PerformCallbackTask();
        }
        
        
        void Selector::CheckConnectivity(){
            
            // TODO do not remove fd inside the loop
            mutex_.Lock();
            
            tpl::MapIterator< Socket*, SocketState*> it(map_);
            tpl::Pair< Socket*, SocketState*> * cursor = it.Next();
            char buf;
            
            while(cursor){
                
                Socket * socket = cursor->key();
                SocketState * sock_state = cursor->value();
            
                int err = 0;
                
                sockaddr addr;
                socklen_t len = sizeof(addr);
                
                if(sock_state->IsConnected()){
                    
                    // log_d("%ld pre recv MSG_PEEK fd = %d",get_monotonic_time(), socket->GetFD());
                    err = recv(socket->GetFD(), &buf, 1, MSG_PEEK|MSG_DONTWAIT);
                    // log_d("%ld post recv MSG_PEEK %d %d", get_monotonic_time(), err, errno);
                    if(err == 0 && (errno != EAGAIN && errno != EWOULDBLOCK)){
                        
                        log_d("recv error %d", errno);
                        
                        QueueCallbackTask(sock_state, CODE_CLOSED);
                        socket_to_remove_.PushBack(socket);
                        
                    } else if(err > 0){
						// log_d("data available %d", err);
					}                    
                } else { // socket is not connectd.
                    
                    err = getpeername (socket->GetFD(), &addr, &len);
                    
                    if(err == 0){
                        
						QueueCallbackTask(sock_state, CODE_CONNECTED);
                        sock_state->SetIsConnected(true);	
						
                    } else {
                        
                        int e = errno;
                        
                        if(err != 0){
                            if(sock_state->IsConnectTimedout()){
                                QueueCallbackTask(sock_state, CODE_CONNECT_TIMEOUT);
                                socket_to_remove_.PushBack(socket);                                
                            }
                        }
                        
                        if( e == ENOTCONN){
                            
                        } else if(e == EBADF){
                            log_d("bad fd");
                            QueueCallbackTask(sock_state, CODE_CLOSED);
                            socket_to_remove_.PushBack(socket);
                        }else {
                            log_d("unhandled getpeername error %d", e);
                        }
                    }
                }  
                
                cursor = it.Next();
            }
            
            mutex_.Unlock();
            
            PerformCallbackTask();
        }
        
        
        void Selector::Loop(){
            
            struct timeval tv;
            int ret = 0;
            int nfd = 0;
            
            log_d("selector is running...");
            shutdown_ = true;
            while(!shutdown_){
                
                if(fd_updated_){	
                    
                    RefreshFdSet(nfd);
                    
                    log_e("fdset updated, max fd %d", nfd);
                }
                
                if(nfd == 0){
                    usleep(10000);
                    continue;
                }
                
                tv.tv_sec  = 0;
                tv.tv_usec = 50000;

				//fd_set local_read_set = read_set_;

				memcpy(&read_set_, &read_set_config_, sizeof(read_set_));

                ret = select(nfd, &read_set_, NULL, NULL, &tv);
                
                if (ret < 0){
                    if(errno == EINTR){
						log_e("SELECT EINTR %d", errno);
					} else {
						log_e("SELECT FAILED %d", errno);
					}
                    
                } else if (ret > 0){ // sokcets ready
                    
                    log_d(" SELECT READY:  %d", ret);
                    
                    HandleIoEvent();
                    
                    RemoveSocket(socket_to_remove_);
                    
                } else {                    
                    // log_d(" NO IO IS READY ");
					// log_d("errno = %d, msg = %s", errno, strerror(errno));

					// RefreshFdSet(nfd);
                }
                
                // check if socket is closed or connected
                CheckConnectivity();
                
                // remove those closed or connect timeouted sockets
                RemoveSocket(socket_to_remove_);

            }
        }
        
        void Selector::Shutdown(){
            shutdown_ = true;
        }
        
        void Selector::RemoveSocket(tpl::Vector< Socket*> & socket_to_remove){
            
			if(socket_to_remove.Size() > 0){
                
				for(int i = 0; i< socket_to_remove.Size(); i++){
                    DoRemoveFd(socket_to_remove[i], true);
                }
                
				socket_to_remove.Clear();
            }
        }
        
        
        
        void Selector::Start(){
            if(shutdown_){
                log_e("Selector has already been shutdown, cannot start it again.");
                return;
            }
            
            this->thread_->Start(this);
        }
        
        void Selector::QueueCallbackTask(SocketState * socket_state, int code){
            
            CallbackTask task;
            task.code = code;
            task.socket_state = socket_state;			 
            callback_task_.PushBack(task);
        }
        
        void Selector::PerformCallbackTask(){
            
            int size = callback_task_.Size();
            
            for(int i = 0; i<size; i++){
                CallbackTask & task = callback_task_.Front();
                task.socket_state->ExecuteCallback(task.code);
            }
            
            callback_task_.Clear();
        }
        
        
        
        void * SelectorFunc(void * params){
            Selector * selector = (Selector*)params;
            selector->Loop();
            return NULL;
        }
    }
}