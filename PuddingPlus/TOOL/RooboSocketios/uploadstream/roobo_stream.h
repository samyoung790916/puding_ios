#ifndef __ROOBO_STREAM_H__
#define __ROOBO_STREAM_H__

#ifndef HANDLE
#define HANDLE RBS_INT32
#endif

#define RBS_INT32 long long
#define RBS_BYTE unsigned char
#define RBS_INT16 short
#define RBS_UINT16 unsigned short
#define RBS_UINT32 unsigned long long

#define INVALID_HANDLE 0

#define RBS_STREAM_MAGIC 0x1234

namespace roobo  {
	namespace stream {

		enum RBS_Sample_Rate {
			RBS_SAMPLE_RATE_8000 = 1, // 采样率8K
			RBS_SAMPLE_RATE_16000 = 2  //采样率16K
		};

		enum RBS_PCM_Encoding {
			RBS_ENCODING_PCM_8BIT	 = 1,
			RBS_ENCODING_PCM_16BIT	 = 2
		};

		enum RBS_Error_Code {

			RBS_ERROR_SUCCESS			= 0,	// 成功
			RBS_ERROR_AGAIN				= -1,    // 暂时没有数据稍后再来读取

			RBS_ERROR_INVALID_HANDLE	= -100,	// INVALID HANDLE
			RBS_ERROR_NO_INTERNET		= -101,	// 没有因特网访问
			RBS_ERROR_AUTH_FAILED		= -102,	// 鉴权失败
			RBS_ERROR_OUT_OF_MEMORY		= -103   // 内存不足
		};

		enum RBS_Payload {
			RBS_PAYLOAD_AUTH_REQ		=	1, // 鉴权请求
			RBS_PAYLOAD_AUTH_RESP		=	2, // 鉴权响应
			RBS_PAYLOAD_PCM				=	3, // PCM包
			RBS_PAYLOAD_MUSIC_URL		=	4 // 播放MP3
		};

		enum RBS_Flag{
			RBS_FLAG_BEGIN			=1, // 流开始
			RBS_FLAG_IN_PROGRESS	=2, // 正在传输
			RBS_FLAG_END			=3, // 结束
			RBS_FLAG_SINGLE			=4  // 单个完整独的包, 起始传输，结尾一个包完成
		};

		enum RBS_Cipher_Algorithm {
			AES = 1,
			RC4 = 2,
			PLAIN = 3,
		};

		//
		// PCM格式
		//
#pragma pack(push)
#pragma pack(1)
		struct RBS_PcmFormat {
			RBS_BYTE sample_rate;	// 采样率
			RBS_BYTE channel_num;	// 声道数量
			RBS_BYTE encoding;		// 编码格式8 或16比特一个采样 
		};

		//
		// 协议包头
		//
		struct RBS_Header{
			RBS_UINT16	protocol_version;	// 协议版本 
			RBS_UINT16	magic_number;		//  magic code 快速区分协议
			RBS_UINT32	payload_type;		//  PCM,文本命令
			RBS_UINT32	serial_number;		//  串号, 同一payload，并且同一组的包的串号是一样的
			RBS_UINT32	payload_length;		//  不包含header本身
		};


		//
		// 鉴权握手协议， 包含PCM格式
		//
		struct RBS_AuthReq{	

			struct RBS_Header header;	 // 包头

			struct RBS_PcmFormat upload_pcm_format;	  // 上行的PCM格式
			struct RBS_PcmFormat download_pcm_format; // 下行需要的PCM格式

			RBS_UINT16  platform;				// 平台
			RBS_UINT16	channel_id;				// 渠道
			RBS_UINT16	app_id;					// 应用厂商id

			RBS_BYTE	client_id		[32];	// 端唯一标识
			RBS_BYTE	secret			[16];	// 用公钥加密的16字节随机数
			RBS_BYTE	reserved		[16];	// 保留字段
		};


		//
		// 鉴权握手协议包
		//
		struct RBS_AuthResp {
			struct  RBS_Header header;		// 包头
			RBS_INT16 error_code;			// 错误代码
			RBS_INT16 cipher_algorithm;		// 加解密算法 
			RBS_INT16 key_len;
			RBS_BYTE  * key;				// 后续加解密密钥 (密钥使用鉴权包里面的随机数加密, 防止被窃听)
		};

		//
		// 数据包
		//
		struct RBS_Packet{
			struct  RBS_Header header;	 // 包头
			RBS_INT16 flag; 			 //  起始, 结束, 传输, 单个完整包
			RBS_BYTE * data;				 //  数据体地址
		};
#pragma pack(pop)


		//=========================================================================================
		// 下面的API和结构体暴露给外层应用
		//=========================================================================================


		struct RBS_ServerAddress{
			RBS_INT32 port;
			const char * address;	
		};

		struct RBS_Parameters{

			RBS_BYTE client_id	[32];			// 端唯一标识
			RBS_BYTE public_key	[32];			// 鉴权信息
			RBS_UINT16	app_id;					// 应用厂商id
			RBS_UINT16	channel_id;				// 渠道

			struct RBS_PcmFormat upload_pcm_format; // 上行的PCM格式
			struct RBS_PcmFormat download_pcm_format; // 希望下行的PCM格式		

			struct RBS_ServerAddress * addresses; // 服务器地址信息队列
			RBS_INT32 AddressSize; // 服务器地址个数
		};


#pragma pack(push)
#pragma pack(1)
		struct RBS_Data_Packet
		{
			RBS_UINT32	payload_type;		//  PCM,文本命令
			RBS_UINT32	serial_number;		//  串号, 同一payload，并且同一组的包的串号是一样的
			RBS_UINT32	payload_length;		//  不包含header本身
			RBS_INT16	flag; 				//  起始, 结束, 传输, 单个完整包
			RBS_BYTE *  data;
		};
#pragma pack(pop)

		//
		// 开流接口
		// @param parameters 开流参数， 说明PCM格式， 其他握手需要的数据
		// @param data_callback 如果指定有数据时回调改接口， 如果为NULL， 收到的数据缓存下来， 用户需要通过read来读取
		// @param error_callback 错误回调， 出现严重错误时回调
		// @return 返回句柄后续接口需要使用,返回INVALID_HANDLE说明失败了
		HANDLE RBS_OpenStream(struct RBS_Parameters * parameters);

		//
		// 开始准备传输数据， 调用该接口后, PCM数据直接调用Write发送
		// @return 返回PCM单次回话的serial number
		//
		RBS_INT32 RBS_StartStreamingPCM(HANDLE handle);

		//
		// 结束发送流数据
		//
		void RBS_StopStreamingPCM(HANDLE handle);

		//
		// 发送PCM数据给服务器
		// @param return 正数表示实际发送的数据， 负数出现错误
		//
		RBS_INT32 RBS_WritePCM(HANDLE handle, void * data, RBS_INT32 len);

		//
		// 读取数据
		//
		RBS_Data_Packet * RBS_ReadPCM(HANDLE handle,  RBS_INT32 * err);

		//
		// 关闭流，回收资源
		//
		void RBS_CloseStream(HANDLE handle);

	}
}

#endif // __ROOBO_STREAM_H__