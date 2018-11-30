#include "long_live_conn_linux_api.h"
#include <endian.h>
#include <unistd.h>
#include "../../roobo/roobo_packet_factory.h"
#include "../../roobo/roobo_packet.h"
#include "../../common/utils.h"
#include "../../roobo/roobo_types.h"
#include "../../cryptography/cipher_factory.h"
#include "../../network/multiplexio.h"
#include "../../thirdparty/jsmn/jsmn.h"


//初始化
LongLiveConnLinuxApi::LongLiveConnLinuxApi(const roobo::ClientConfig & client_config,  const roobo::AuthInfo & auth_info)
	: auth_helper_(client_config, auth_info)
{
	llc_ = new roobo::RooboLongLiveConn(client_config.GetServerAddress(), this, &auth_helper_);

	llc_ptr_ = tpl::SmartPtr<roobo::TimerCallback>(llc_);

	llc_ptr_.Get();

	llc_->Init(&llc_ptr_);

	roobo::longliveconn::NetworkInfo network_info(true, roobo::longliveconn::kWiFi);

	// TODO: remove the trick
	llc_->NotifyNetworkChange(network_info);
}


LongLiveConnLinuxApi::~LongLiveConnLinuxApi(void)
{
	mark();
	llc_ = NULL;
}


//收到服务器的主动发包
void LongLiveConnLinuxApi::OnPacket(roobo::RooboPacket * packet){
	const char * reply = "{\"result\":0,\"msg\":\"success\",\"data\":{\"cmd\":\"ok\"}}";
	roobo::longliveconn::Packet * replyPacket = roobo::RooboPacketFactory::GetInstance()->GetPacket(packet->GetSn(), (uint8_t)0, (uint8_t)roobo::CATEGORY_MESSAGE_ACK, (void*)reply, (int)strlen(reply));
	SendPacket((roobo::RooboPacket*)replyPacket, roobo::longliveconn::kNone);
	log_d(packet->GetBody().c_str());
}


//长链接状态改变
void LongLiveConnLinuxApi::OnStateChange(roobo::longliveconn::StateName old_state, roobo::longliveconn::StateName new_state) {
    
}

// Packet send result report
//自己发的包收到的回执
void LongLiveConnLinuxApi::OnPacketResult(uint64_t sn, roobo::longliveconn::PacketResult result, roobo::longliveconn::Packet * packet){

}


//发包
bool LongLiveConnLinuxApi::SendPacket(roobo::RooboPacket * packet, roobo::longliveconn::PacketSendFlag flags){
    
	if(NULL == packet){
		mark();
		return false;
	}

	return llc_->SendPacket(packet, flags);
}


//通知网络状态变化
void LongLiveConnLinuxApi::NotifyNetworkChange(bool available, roobo::longliveconn::NetworkType net_type, int sub_type){

	roobo::longliveconn::NetworkInfo networkinfo;
	networkinfo.Available = available;
	networkinfo.NetType = net_type;
	networkinfo.SubType = sub_type;

	llc_->NotifyNetworkChange(networkinfo);

	if(available){
		auth_helper_.OnNetTypeChanged(net_type);
	}
}

//结束
void LongLiveConnLinuxApi::Shutdown(){
	llc_->Shutdown();
}


//刷新 Token
void LongLiveConnLinuxApi::UpdateToken(const char * token){
	auth_helper_.UpdateToken(token);
}
