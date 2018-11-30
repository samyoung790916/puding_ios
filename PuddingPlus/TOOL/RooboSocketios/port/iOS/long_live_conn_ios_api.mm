//
//  LongLiveConniOSApi.mm
//
//  Created by zhouyuanjiang on 16/9/1.
//  Copyright © 2016年 zhouyuanjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "long_live_conn_ios_api.h"

LongLiveConniOSApi::~LongLiveConniOSApi(){
    
}

// Received a packet
void LongLiveConniOSApi::OnPacket(roobo::RooboPacket * packet){
    if(this->packet_callback_){
        this->packet_callback_(packet);
    }
}

// State has changed
void LongLiveConniOSApi::OnStateChange(roobo::longliveconn::StateName old_state, roobo::longliveconn::StateName new_state){
    if(this->state_changed_callback_){
        state_changed_callback_(old_state, new_state);
    }
    
}

// promot of packet send result
void LongLiveConniOSApi::OnPacketResult(uint64_t sn, roobo::longliveconn::PacketResult result, roobo::longliveconn::Packet * packet){
    if(this->packet_result_callback_){
        packet_result_callback_(sn, result, packet);
    }
}


