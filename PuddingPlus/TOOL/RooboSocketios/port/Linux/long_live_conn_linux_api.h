#ifndef LONG_LIVE_CONN_API_LINUX_H_
#define LONG_LIVE_CONN_API_LINUX_H_

#include "../../roobo/long_live_conn_api.h"
#include "../../roobo/roobo_long_live_conn.h"
#include "../../longliveconn/auth.h"
#include "../../longliveconn/data_types.h"
#include "../../tpl/vector.h"
#include "../../tpl/smart_ptr.h"
#include "auth_helper.h"
#include "../../roobo/client_config.h"
#include "../../roobo/auth_info.h"

// Callback function to receive packet
typedef void (*OnPacketCallback)(roobo::RooboPacket * packet);

// Callback function to receive state change event
typedef void (*OnStateChangeCallback)(roobo::longliveconn::StateName old_state, roobo::longliveconn::StateName new_state);

// Callback function of packet send result
// @sn: sn of the packet previously sent
// @result: 0 measn sucess
// @packet: response packet if applicable
//
typedef void (*OnPacketResultCallback)(uint64_t sn, roobo::longliveconn::PacketResult result, roobo::longliveconn::Packet * packet);






class LongLiveConnLinuxApi : public roobo::LongLiveConnApi
{

private:
	
	roobo::longliveconn::AuthHelper auth_helper_;

	roobo::RooboLongLiveConn * llc_;
	
	tpl::SmartPtr<roobo::TimerCallback> llc_ptr_;

public:

	LongLiveConnLinuxApi(const roobo::ClientConfig & client_config, const roobo::AuthInfo & auth_info);

	virtual ~LongLiveConnLinuxApi(void);

	// Received a packet
	virtual void OnPacket(roobo::RooboPacket * packet);

	// State has changed
	virtual void OnStateChange(roobo::longliveconn::StateName old_state, roobo::longliveconn::StateName new_state);

	// promot of packet send result
	virtual void OnPacketResult(uint64_t sn, roobo::longliveconn::PacketResult result, roobo::longliveconn::Packet * packet);

	// send a packet
	virtual bool SendPacket(roobo::RooboPacket * packet, roobo::longliveconn::PacketSendFlag flags);

	// notify about network change
	virtual void NotifyNetworkChange(bool available, roobo::longliveconn::NetworkType net_type, int sub_type) ;

	// update token for user application
	virtual void UpdateToken(const char * token);

	virtual void Shutdown();
};



#endif // LONG_LIVE_CONN_API_LINUX_H_
