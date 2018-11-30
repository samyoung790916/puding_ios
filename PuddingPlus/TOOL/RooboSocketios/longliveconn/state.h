
#ifndef LONGLIVECONN_STATE_H_
#define LONGLIVECONN_STATE_H_

#include "event.h"
#include "long_live_conn.h"
#include "state_machine.h"

namespace roobo {

	namespace longliveconn {

		class State {

		protected:
			StateMachine * machine_;
			LongLiveConn * llc_;

		public:

			State(StateMachine * machine, LongLiveConn * llc) : machine_(machine), llc_(llc){

			}

			virtual ~State(){};

			//
			// get name of the state
			//
			virtual  StateName GetName() = 0;

			//
			// called when there is an event need to handle
			//
			virtual int OnEvent(Event & evt) = 0;

			//
			// called when enter the state
			//
			virtual int OnEnter() {return 0;}

			//
			// called when exit the state
			//
			virtual int OnExit() {return 0;}

		};
	}
}

#endif // LONGLIVECONN_STATE_H_
