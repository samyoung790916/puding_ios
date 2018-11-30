#ifndef ROOBO_ESTABLISHED_STATE_H_
#define ROOBO_ESTABLISHED_STATE_H_


#include "../state.h"

namespace roobo {

	namespace longliveconn {

		class EstablishedState : public State
		{

		public:

			EstablishedState(StateMachine * machine, LongLiveConn * llc) : State(machine, llc){
			}

			virtual ~EstablishedState(void);

			//
			// get name of the state
			//
			virtual StateName GetName() {return STATE_ESTABLISHED;}

			//
			// called when there is an event need to handle
			//
			virtual int OnEvent(Event & evt);

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
#endif // ROOBO_ESTABLISHED_STATE_H_

