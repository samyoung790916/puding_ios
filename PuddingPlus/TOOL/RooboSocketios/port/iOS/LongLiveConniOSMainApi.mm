//
//  LongLiveConniOSApi.mm
//
//  Created by zhouyuanjiang on 16/9/1.
//  Copyright © 2016年 zhouyuanjiang. All rights reserved.
//

#import "LongLiveConniOSMainApi.h"
#include "../../roobo/roobo_packet_factory.h"
#include "../../roobo/roobo_packet.h"
//收包
void OnPacket(roobo::RooboPacket * packet){
    char* char_array =   packet->GetBody().data();
    NSString *string_content = [[NSString alloc] initWithCString:char_array
                                                        encoding:NSASCIIStringEncoding];
    NSLog(@"OnPacket = %@",string_content);
    [RBLong_live_Delegate rb_LongOnPacket:string_content];
}

//发送包的结果
void OnPacketResult(uint64_t sn, roobo::longliveconn::PacketResult result, roobo::longliveconn::Packet * packet){
    char * char_array =   packet->GetBody().data();
    NSString *string_content = [[NSString alloc] initWithCString:char_array
                                                        encoding:NSASCIIStringEncoding];
    NSLog(@"OnPacketResult = %@",string_content);
    NSLog(@"PacketResult =  %d",result);
    [RBLong_live_Delegate rb_LongOnPacketResult:string_content];

}

//状态改变
void OnStateChange(roobo::longliveconn::StateName old_state, roobo::longliveconn::StateName new_state){
    NSLog(@"OnStateChange = %d",new_state);
    [RBLong_live_Delegate rb_LongOnStateChangeOld:old_state newState:new_state];
}


@implementation LongLiveConniOSMainApi


#pragma mark - action: 开始
-(void)startWithClientId:(NSString *)clientId token:(NSString *)tokenStr{
    tpl::Vector<roobo::longliveconn::ServerAddress> addresses;
    const char * production = "pudding-plus.app";
    roobo::longliveconn::ServerAddress server1("172.17.254.126", 7080);
    const char * client_id = [clientId UTF8String];
    NSLog(@"userid = %@",clientId);
    const char * public_key ="MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDPVarTfmRwwzs0QaE4ijsW3Xjd" \
    "NaQgWb7q3qGZTVGqQL8BE/oPK6+e1wdrulXGfdz9EOzn/l/vuD032a35AioaUwpd" \
    "Gz3TmPsnYY7l8j/i0d9NqlKjlM2QJWtnMSfTYaR/Mis3iKeZN7UkSrMbK+fW326c" \
    "tpm+ARb4gZg4f2KK3wIDAQAB";
    const char * app = "com.roobo.puddingplus";
    const char * version = "1.0.0";
    const char * version_code = "1";
    const char * channel = "10000";
    const char * device = "puddingplus";
    addresses.PushBack(server1);
    const char * token = [tokenStr UTF8String];
    /*
     * @param server_address
     * @param product
     * @param app
     * @param version
     * @param version_code
     * @param channel
     * @param device
     */
    roobo::ClientConfig client_config(addresses, production, app, version, version_code, channel, device);
    roobo::AuthInfo auth_info(client_id, public_key, token);
    api_ = new LongLiveConniOSApi(client_config, auth_info,OnPacket,OnStateChange,OnPacketResult);
}
#pragma mark - action: 发送消息
-(void)sendMsg:(NSString *)str{
    const char * reply = [str UTF8String];
    roobo::RooboPacket * pack = roobo::RooboPacketFactory::GetInstance()->GetPacket(0, roobo::MsgCategory::CATEGORY_CLIENT_MESSAGE_SERVER_SYN, (void*)reply, (int)strlen(reply));
    if(api_->SendPacket(pack, roobo::longliveconn::kExpectAck)){
        NSLog(@"发送start成功");
    }else{
        NSLog(@"发送start失败");
    }
}

#pragma mark - action: 断开长连接
-(void)shutDown{
    api_->Shutdown();
}

@end
