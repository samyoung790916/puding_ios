//
//  LongLiveConniOSApi.h
//
//  Created by zhouyuanjiang on 16/9/1.
//  Copyright © 2016年 zhouyuanjiang. All rights reserved.
//

#ifndef LONG_LIVE_CONN_API_APPLE_H_
#define LONG_LIVE_CONN_API_APPLE_H_

#include "../Linux/long_live_conn_linux_api.h"

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


class LongLiveConniOSApi : public LongLiveConnLinuxApi {
    
private:
    OnPacketCallback packet_callback_;
    OnStateChangeCallback state_changed_callback_;
    OnPacketResultCallback packet_result_callback_;
    
public:
    
    LongLiveConniOSApi(const roobo::ClientConfig & client_config, const roobo::AuthInfo & auth_info,
                       OnPacketCallback packet_callback, OnStateChangeCallback state_changed_callback, OnPacketResultCallback packet_result_callback) :
    
    
    LongLiveConnLinuxApi(client_config, auth_info),
    packet_callback_(packet_callback), state_changed_callback_(state_changed_callback), packet_result_callback_(packet_result_callback){
        
    }
    
    
    
    virtual ~LongLiveConniOSApi();
    
    // Received a packet
    virtual void OnPacket(roobo::RooboPacket * packet);
    
    // State has changed
    virtual void OnStateChange(roobo::longliveconn::StateName old_state, roobo::longliveconn::StateName new_state);
    
    // promot of packet send result
    virtual void OnPacketResult(uint64_t sn, roobo::longliveconn::PacketResult result, roobo::longliveconn::Packet * packet);
};


#endif // LONG_LIVE_CONN_API_APPLE_H_