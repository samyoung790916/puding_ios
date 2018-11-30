#include "message_event.h"

namespace roobo {

	namespace longliveconn {

		MessageEvent::~MessageEvent(void)
		{
			packet_ = NULL;
		}

	}
}