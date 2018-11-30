#include "roobo_stream.h"
#include "media_stream.h"

namespace roobo {

	namespace stream {

		//
		// �����ӿ�
		// @param parameters ���������� ˵��PCM��ʽ�� ����������Ҫ������
		// @param data_callback ���ָ��������ʱ�ص��Ľӿڣ� ���ΪNULL�� �յ������ݻ��������� �û���Ҫͨ��read����ȡ
		// @param error_callback ����ص��� �������ش���ʱ�ص�
		// @return ���ؾ�������ӿ���Ҫʹ��,����INVALID_HANDLE˵��ʧ����
		HANDLE RBS_OpenStream(struct RBS_Parameters * parameters){
			return INVALID_HANDLE;
		}

		//
		// ��ʼ׼���������ݣ� ���øýӿں�, PCM����ֱ�ӵ���Write����
		// @return ����PCM���λػ���serial number
		//
		RBS_INT32 RBS_StartStreamingPCM(HANDLE handle){
			return 0;
		}

		//
		// ��������������
		//
		void RBS_StopStreamingPCM(HANDLE handle){
		}

		//
		// ����PCM���ݸ�������
		// @param return ������ʾʵ�ʷ��͵����ݣ� �������ִ���
		//
		RBS_INT32 RBS_WritePCM(HANDLE handle, void * data, RBS_INT32 len){
			return 0;
		}

		//
		// ��ȡ����
		//
		RBS_Data_Packet * RBS_ReadPCM(HANDLE handle, RBS_Data_Packet * data, RBS_INT32 * err){
			return NULL;
		}

		//
		// �ر�����������Դ
		//
		void RBS_CloseStream(HANDLE handle){

		}
	}
}
