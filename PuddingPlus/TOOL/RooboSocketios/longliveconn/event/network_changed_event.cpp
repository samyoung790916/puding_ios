#include "network_changed_event.h"

namespace roobo {

	namespace longliveconn {

		NetworkChangedEvent::NetworkChangedEvent(NetworkInfo * network_info) 
		{
			if(network_info){
				network_info_ = new NetworkInfo(*network_info);
			}
		}

		NetworkChangedEvent::~NetworkChangedEvent(void)
		{
			RB_FREE(network_info_);
		}

		int NetworkChangedEvent::GetEventCode(void)
		{
			return EVENT_NETWORK_CHANGED;
		}

		NetworkInfo * NetworkChangedEvent::GetNetworkInfo(){
			return network_info_;
		}

	}
}