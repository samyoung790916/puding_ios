#include "cmd_event.h"

namespace roobo {

	namespace longliveconn {

		CmdEvent::~CmdEvent(void)
		{
		}

		int CmdEvent::GetEventCode()
		{
			return EVENT_CMD;
		}
	}
}
