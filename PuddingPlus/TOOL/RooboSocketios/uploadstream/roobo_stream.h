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
			RBS_SAMPLE_RATE_8000 = 1, // ������8K
			RBS_SAMPLE_RATE_16000 = 2  //������16K
		};

		enum RBS_PCM_Encoding {
			RBS_ENCODING_PCM_8BIT	 = 1,
			RBS_ENCODING_PCM_16BIT	 = 2
		};

		enum RBS_Error_Code {

			RBS_ERROR_SUCCESS			= 0,	// �ɹ�
			RBS_ERROR_AGAIN				= -1,    // ��ʱû�������Ժ�������ȡ

			RBS_ERROR_INVALID_HANDLE	= -100,	// INVALID HANDLE
			RBS_ERROR_NO_INTERNET		= -101,	// û������������
			RBS_ERROR_AUTH_FAILED		= -102,	// ��Ȩʧ��
			RBS_ERROR_OUT_OF_MEMORY		= -103   // �ڴ治��
		};

		enum RBS_Payload {
			RBS_PAYLOAD_AUTH_REQ		=	1, // ��Ȩ����
			RBS_PAYLOAD_AUTH_RESP		=	2, // ��Ȩ��Ӧ
			RBS_PAYLOAD_PCM				=	3, // PCM��
			RBS_PAYLOAD_MUSIC_URL		=	4 // ����MP3
		};

		enum RBS_Flag{
			RBS_FLAG_BEGIN			=1, // ����ʼ
			RBS_FLAG_IN_PROGRESS	=2, // ���ڴ���
			RBS_FLAG_END			=3, // ����
			RBS_FLAG_SINGLE			=4  // �����������İ�, ��ʼ���䣬��βһ�������
		};

		enum RBS_Cipher_Algorithm {
			AES = 1,
			RC4 = 2,
			PLAIN = 3,
		};

		//
		// PCM��ʽ
		//
#pragma pack(push)
#pragma pack(1)
		struct RBS_PcmFormat {
			RBS_BYTE sample_rate;	// ������
			RBS_BYTE channel_num;	// ��������
			RBS_BYTE encoding;		// �����ʽ8 ��16����һ������ 
		};

		//
		// Э���ͷ
		//
		struct RBS_Header{
			RBS_UINT16	protocol_version;	// Э��汾 
			RBS_UINT16	magic_number;		//  magic code ��������Э��
			RBS_UINT32	payload_type;		//  PCM,�ı�����
			RBS_UINT32	serial_number;		//  ����, ͬһpayload������ͬһ��İ��Ĵ�����һ����
			RBS_UINT32	payload_length;		//  ������header����
		};


		//
		// ��Ȩ����Э�飬 ����PCM��ʽ
		//
		struct RBS_AuthReq{	

			struct RBS_Header header;	 // ��ͷ

			struct RBS_PcmFormat upload_pcm_format;	  // ���е�PCM��ʽ
			struct RBS_PcmFormat download_pcm_format; // ������Ҫ��PCM��ʽ

			RBS_UINT16  platform;				// ƽ̨
			RBS_UINT16	channel_id;				// ����
			RBS_UINT16	app_id;					// Ӧ�ó���id

			RBS_BYTE	client_id		[32];	// ��Ψһ��ʶ
			RBS_BYTE	secret			[16];	// �ù�Կ���ܵ�16�ֽ������
			RBS_BYTE	reserved		[16];	// �����ֶ�
		};


		//
		// ��Ȩ����Э���
		//
		struct RBS_AuthResp {
			struct  RBS_Header header;		// ��ͷ
			RBS_INT16 error_code;			// �������
			RBS_INT16 cipher_algorithm;		// �ӽ����㷨 
			RBS_INT16 key_len;
			RBS_BYTE  * key;				// �����ӽ�����Կ (��Կʹ�ü�Ȩ����������������, ��ֹ������)
		};

		//
		// ���ݰ�
		//
		struct RBS_Packet{
			struct  RBS_Header header;	 // ��ͷ
			RBS_INT16 flag; 			 //  ��ʼ, ����, ����, ����������
			RBS_BYTE * data;				 //  �������ַ
		};
#pragma pack(pop)


		//=========================================================================================
		// �����API�ͽṹ�屩¶�����Ӧ��
		//=========================================================================================


		struct RBS_ServerAddress{
			RBS_INT32 port;
			const char * address;	
		};

		struct RBS_Parameters{

			RBS_BYTE client_id	[32];			// ��Ψһ��ʶ
			RBS_BYTE public_key	[32];			// ��Ȩ��Ϣ
			RBS_UINT16	app_id;					// Ӧ�ó���id
			RBS_UINT16	channel_id;				// ����

			struct RBS_PcmFormat upload_pcm_format; // ���е�PCM��ʽ
			struct RBS_PcmFormat download_pcm_format; // ϣ�����е�PCM��ʽ		

			struct RBS_ServerAddress * addresses; // ��������ַ��Ϣ����
			RBS_INT32 AddressSize; // ��������ַ����
		};


#pragma pack(push)
#pragma pack(1)
		struct RBS_Data_Packet
		{
			RBS_UINT32	payload_type;		//  PCM,�ı�����
			RBS_UINT32	serial_number;		//  ����, ͬһpayload������ͬһ��İ��Ĵ�����һ����
			RBS_UINT32	payload_length;		//  ������header����
			RBS_INT16	flag; 				//  ��ʼ, ����, ����, ����������
			RBS_BYTE *  data;
		};
#pragma pack(pop)

		//
		// �����ӿ�
		// @param parameters ���������� ˵��PCM��ʽ�� ����������Ҫ������
		// @param data_callback ���ָ��������ʱ�ص��Ľӿڣ� ���ΪNULL�� �յ������ݻ��������� �û���Ҫͨ��read����ȡ
		// @param error_callback ����ص��� �������ش���ʱ�ص�
		// @return ���ؾ�������ӿ���Ҫʹ��,����INVALID_HANDLE˵��ʧ����
		HANDLE RBS_OpenStream(struct RBS_Parameters * parameters);

		//
		// ��ʼ׼���������ݣ� ���øýӿں�, PCM����ֱ�ӵ���Write����
		// @return ����PCM���λػ���serial number
		//
		RBS_INT32 RBS_StartStreamingPCM(HANDLE handle);

		//
		// ��������������
		//
		void RBS_StopStreamingPCM(HANDLE handle);

		//
		// ����PCM���ݸ�������
		// @param return ������ʾʵ�ʷ��͵����ݣ� �������ִ���
		//
		RBS_INT32 RBS_WritePCM(HANDLE handle, void * data, RBS_INT32 len);

		//
		// ��ȡ����
		//
		RBS_Data_Packet * RBS_ReadPCM(HANDLE handle,  RBS_INT32 * err);

		//
		// �ر�����������Դ
		//
		void RBS_CloseStream(HANDLE handle);

	}
}

#endif // __ROOBO_STREAM_H__