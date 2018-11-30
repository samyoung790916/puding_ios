#ifndef ROOBO_CONNECTING_STATE_H_
#define ROOBO_CONNECTING_STATE_H_

#include "../state.h"

namespace roobo {

	namespace longliveconn {

		class ConnectingState : public State
		{

		public:

			ConnectingState(StateMachine * machine, LongLiveConn * llc) : State(machine, llc){
			}

			virtual ~ConnectingState(void);

			//
			// get name of the state
			//
			virtual StateName GetName() {return STATE_CONNECTING;}

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

#endif // ROOBO_CONNECTING_STATE_H_