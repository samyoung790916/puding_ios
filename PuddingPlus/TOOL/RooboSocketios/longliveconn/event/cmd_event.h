#ifndef ROOBO_CMD_EVENT_H_
#define ROOBO_CMD_EVENT_H_
#include "../event.h"


namespace roobo {

	namespace longliveconn {

		class CmdEvent : public Event
		{
		
		protected:
			int cmd_;
			void * params_;

		public:

			CmdEvent(int cmd, void * params) : cmd_(cmd), params_(params){}

			virtual ~CmdEvent(void);

			virtual int GetEventCode();

			int GetCmd() {return cmd_;}

			void * GetParams(){return params_;}
		};
	}
}

#endif // ROOBO_CMD_EVENT_H_
