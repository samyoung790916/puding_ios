#ifndef ROOBO_DISCONNECTED_STATE_H_
#define ROOBO_DISCONNECTED_STATE_H_

#include "../state.h"

namespace roobo {

	namespace longliveconn {

		class DisconnectedState : public State
		{
 
		public:

			DisconnectedState(StateMachine * machine, LongLiveConn * llc) : State(machine, llc){
			}

			virtual ~DisconnectedState(void);

			//
			// get name of the state
			//
			virtual StateName GetName() {return STATE_DISCONNECTED;}

			//
			// called when there is an event need to handle
			//
			virtual int OnEvent( Event & evt);

			//
			// called when enter the state
			//
			virtual int OnEnter();

			//
			// called when exit the state
			//
			virtual int OnExit();
		};

	}
}
#endif // ROOBO_DISCONNECTED_STATE_H_
