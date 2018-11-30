#ifndef _MY_SELECTOR_H_
#define _MY_SELECTOR_H_

#include <unistd.h>

#include <sys/types.h>

/* According to POSIX.1-2001 */
#include <sys/select.h>

/* According to earlier standards */
#include <sys/time.h>

#include "../tpl/map.h"

#include "../common/thread.h"
#include "../common/mutex.h"
#include "socket_state.h"

namespace roobo {
    namespace network {
        
        struct CallbackTask
        {
            int code;
            SocketState * socket_state;
        };
        
        class Selector : public MultiplexIO {
            
        protected:
            
            roobo::Mutex mutex_;
            roobo::Thread * thread_;
            
			fd_set read_set_config_;
            fd_set read_set_;
            fd_set write_set_;
            fd_set err_set_;
            
            tpl::Map<Socket*, SocketState*> map_;
            
            //tpl::Vector<SocketState> socket_states_;
            
            tpl::Vector<CallbackTask> callback_task_;
            
            volatile bool fd_updated_; // it is set when any fd_set is set
            
            volatile bool shutdown_;
            
            tpl::Vector< Socket*> socket_to_remove_;
            
            // QueueCallbackTask(SocketState * socket_state, int code)
            void QueueCallbackTask(SocketState * socket_state, int code);
            
            void PerformCallbackTask();
            
            void RemoveSocket(tpl::Vector< Socket*> & socket_to_remove);
            
        protected:
            
            void DoRemoveFd( Socket * socket, bool acquireLock);
            
            void RefreshFdSet(int & maxFd);
            
            void HandleIoEvent();
            
            void CheckConnectivity();
            
            public :
            
            Selector();
            
            virtual ~Selector();
            
            void Loop();
            
            void AddFd( Socket * socket, IoCallback * callback,  void * params);
            
            void RemoveFd( Socket * socket);
            
            virtual void SyncRemoveFd(Socket * socket);
            
            void Shutdown();
            
            void Start();
        };
        
        void * SelectorFunc(void * params);
        
    }
}

#endif // _MY_SELECTOR_H_

