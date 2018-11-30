#include "roobo_stream.h"
#include "media_stream.h"

namespace roobo {

	namespace stream {

		//
		// 开流接口
		// @param parameters 开流参数， 说明PCM格式， 其他握手需要的数据
		// @param data_callback 如果指定有数据时回调改接口， 如果为NULL， 收到的数据缓存下来， 用户需要通过read来读取
		// @param error_callback 错误回调， 出现严重错误时回调
		// @return 返回句柄后续接口需要使用,返回INVALID_HANDLE说明失败了
		HANDLE RBS_OpenStream(struct RBS_Parameters * parameters){
			return INVALID_HANDLE;
		}

		//
		// 开始准备传输数据， 调用该接口后, PCM数据直接调用Write发送
		// @return 返回PCM单次回话的serial number
		//
		RBS_INT32 RBS_StartStreamingPCM(HANDLE handle){
			return 0;
		}

		//
		// 结束发送流数据
		//
		void RBS_StopStreamingPCM(HANDLE handle){
		}

		//
		// 发送PCM数据给服务器
		// @param return 正数表示实际发送的数据， 负数出现错误
		//
		RBS_INT32 RBS_WritePCM(HANDLE handle, void * data, RBS_INT32 len){
			return 0;
		}

		//
		// 读取数据
		//
		RBS_Data_Packet * RBS_ReadPCM(HANDLE handle, RBS_Data_Packet * data, RBS_INT32 * err){
			return NULL;
		}

		//
		// 关闭流，回收资源
		//
		void RBS_CloseStream(HANDLE handle){

		}
	}
}
