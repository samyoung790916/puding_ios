#ifndef _NETWORK_CHANGED_EVENT_H_
#define _NETWORK_CHANGED_EVENT_H_
#include "../event.h"
#include "../../longliveconn/data_types.h"

namespace roobo {

	namespace longliveconn {

		//
		// report of network change
		//
		class NetworkChangedEvent : public Event
		{

		protected:
			NetworkInfo * network_info_;

		public:
			explicit NetworkChangedEvent(NetworkInfo * network_info);

			~NetworkChangedEvent(void);
			 
			virtual int GetEventCode(); 

			NetworkInfo * GetNetworkInfo();
		};


	}

}

#endif // _NETWORK_CHANGED_EVENT_H_
