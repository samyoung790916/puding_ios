#ifndef ROOBO_LONG_LIVE_CONN_STATE_MACHINE_H_
#define ROOBO_LONG_LIVE_CONN_STATE_MACHINE_H_

#include "event.h"

namespace roobo {

	namespace longliveconn {

		class State;

		//
		// State Machine abstraction class
		//
		class StateMachine {

		public:

			virtual ~StateMachine(){}

			//
			// post and event into the state machine
			//
			virtual int PostEvent(const Event * evt) = 0;

			//
			// Transit to a state
			//
			virtual void TransitTo(StateName target_state_name) = 0;

			//
			// Get current state
			//
			virtual State * GetCurrentState() = 0;
		};
	}
}
#endif /* ROOBO_LONG_LIVE_CONN_STATE_MACHINE_H_ */
