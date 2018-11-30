#include "multiplexio.h"
#include "selector.h"
#include "../tpl/smart_ptr.h"

#ifdef __APPLE__

#else
#include "epoll.h"
#endif

#include <time.h>

namespace roobo {
	namespace network {

#ifdef __APPLE__
		MultiplexIO * MultiplexIO::_instance = new Selector();
#else 
		MultiplexIO * MultiplexIO::_instance = new Epoll();
#endif
		tpl::SmartPtr<MultiplexIO> kMultiplexIoPtr(MultiplexIO::GetInstance());

		MultiplexIO * MultiplexIO::GetInstance(){
			return _instance;
		}
	}
}