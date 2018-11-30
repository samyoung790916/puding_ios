#ifndef ROOBO_ROOBO_TYPES_H_
#define ROOBO_ROOBO_TYPES_H_

#define STR_SIZE 128
#define MAGIC "juan"
#define PROTOCOL_VERSION 1

namespace roobo {

	enum MsgFormat
	{
		MSG_FMT_RAW = 0,
		MSG_FMT_JSON = 1,
		MSG_FMT_REQ_JSON = 2, // json with action data
		MSG_FMT_RET_JSON = 3, // json with result, msg
	};

 
	enum AuthType{
		
		DEVICE, // such as pudding, pudding1s, t1, j2

		APP // android, ios, etc
	};

	enum MsgCategory
	{
		CATEGORY_ECHO_REQ = 0x00, // 客户端 -> 服务器 回显 server收到后立即将body返回给client

		CATEGORY_ECHO_RESP = 0x40, // 服务器 -> 客户端 回显响应 服务器针对0x00的响应包

		CATEGORY_HEART_REQ = 0x01, // 客户端 -> 服务器 上行心跳 客户端主动触发的心跳包

		CATEGORY_HEART_RESP = 0x41, // 服务器 -> 客户端 上行心跳响应 服务器针对0x01的响应包

		CATEGORY_UNKNOWN_REQ = 0x02, // 服务器 -> 客户端

		CATEGORY_UNKNOWN_RESP = 0x42, // 客户端 -> 服务器

		CATEGORY_REGISTER_REQ = 0x03, // 客户端 -> 服务器 认证 客户端在服务器上注册，需要先验证客户端身份，这个包包含认证信息

		CATEGORY_REGISTER_RESP = 0x43, // 服务器 -> 客户端 认证响应 认证通过后的响应包（如果认证失败，服务器会主动断开连接）

		CATEGORY_RECONN_REQ = 0x04, // 客户端 -> 服务器 重连（暂不支持） 客户端和服务器因为某种原因断开后，可以使用这种命令快速重练，而不需要重新认证

		CATEGORY_RECONN_RESP = 0x44, // 服务器 -> 客户端 重连响应（暂不支持）

		CATEGORY_MESSAGE_PUSH =  0x80, // 服务器 -> 客户端 推送 服务器主动给客户端推送消息

		CATEGORY_MESSAGE_ACK = 0xC0, // 客户端 -> 服务器 推送响应 客户端针对

		CATEGORY_CLIENT_MESSAGE_SERVER_ASYN = 0xA0,  //客户端->服务器 消息转发（异步）客户端A发送消息给客户端B， 由服务器完成异步中转，确保消息被客户端接收

		CATEGORY_CLIENT_MESSAGE_SERVER_SYN = 0xA1   //客户端->服务器 消息转发（同步）客户端A发送消息给客户端B， 由服务器完成同步中转，消息不做任何持久化保存
	};

}

#endif // ROOBO_ROOBO_TYPES_H_