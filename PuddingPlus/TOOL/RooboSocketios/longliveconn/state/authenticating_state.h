#ifndef ROOBO_AUTHENTICATING_STATE_H_
#define ROOBO_AUTHENTICATING_STATE_H_

#include "../state.h"
#include "../auth.h"

#define AUTH_STATE_INIT 0
#define AUTH_STATE_HANDSHAKE_SENT 1
#define AUTH_STATE_AUTH_SENT 2

namespace roobo {

	namespace longliveconn {

		class AuthenticatingState : public State
		{

		protected:

			int sub_state_;

			void Reset(){ 
				sub_state_ = AUTH_STATE_INIT;
			}

		public:
			AuthenticatingState(StateMachine * machine, LongLiveConn * llc) : State(machine, llc){
				Reset();
			}

			virtual ~AuthenticatingState(void);


			//
			// get name of the state
			//
			virtual StateName GetName() {return STATE_AUTHENTICATING;}

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


			void SetCipherProperly(AuthResult * auth_result);

		};
	}
}
#endif // ROOBO_AUTHENTICATING_STATE_H_

