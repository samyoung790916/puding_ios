/*
* main.cpp
*
*      Author: zhouyuanjiang
*/
#include "main.h"

#include "../common/log.h"
#include "../common/buffer.h"
#include "../common/timer.h"
#include "../common/utils.h"
#include "../common/semaphore.h"
#include "../common/thread.h"
#include "../network/multiplexio.h"
#include "../network/tcp_socket.h"
#include "../roobo/roobo_types.h"
#include "../roobo/roobo_packet.h"
#include "../roobo/roobo_long_live_conn.h"
#include "../tpl/blocking_queue.h"
#include "../tpl/vector.h"
#include "../tpl/map.h"
#include "../tpl/list.h"
#include "../thirdparty/cryptography/opensslbf/blowfish.h"
#include "../uploadstream/media_stream.h"
#include "../port/Linux/long_live_conn_linux_api.h"
#include "../cryptography/cipher_factory.h"


using namespace roobo;
using namespace roobo::longliveconn;
using namespace roobo::network;
using namespace tpl;
using namespace roobo::cryptography;
using namespace roobo::stream;

const static int TestCycles = 6;
const static int kMapTestCycles = 10;


struct Address {
	const char * address;
	int port;
};

void * produce(void * p){
	BlockingQueue<ComplexStruct*> *queue = (BlockingQueue<ComplexStruct*>*)p;
	//int i = 0;
	int b = 0;
	while(true){
		sleep(1);
		ComplexStruct * str = new ComplexStruct(&b);
		//str->dump();
		queue->Offer(str);
	}

	return NULL;
}

void * consume(void * p){

	BlockingQueue<ComplexStruct*> *queue = (BlockingQueue<ComplexStruct*>*)p;
	while(true){
		ComplexStruct* str;
		if(queue->TimedTake(1,&str)){
			if(!str->IsValid()){
				log_e("DATA IS INVALID !!!");
			}

			delete str;
		}
	}

	return NULL;
}

void testBlockQueue(){

	BlockingQueue<ComplexStruct*> queue;

	for(int i =  0; i<3; i++){
		Thread * consumer = new Thread(consume);
		consumer->Start(&queue);
	}

	for(int i =  0; i<3; i++){
		Thread * producer = new Thread(produce);
		producer->Start(&queue);
	}

	sleep(10000);
}

void * callback(void * params){
	printf("ThreadFunc called\n");
	sleep(10);
	//sem.Post();
	return NULL;
}



class IoTestCallback : public IoCallback {

public:

	bool OnIoEvent( const IoCallbackArgs & io_callback_args){

		Socket * socket = io_callback_args.socket; 
		int code = io_callback_args.code;
		//void * params = io_callback_args.params;

		if(code == CODE_CONNECTED){
			log_d("socket %s:%d CONNECTED", socket->GetAddress().address, socket->GetPort());
			if(socket->GetPort() == 80){
				const char * http_req = "GET / HTTP/1.1\r\nAccept-Encoding:gzip,deflate\r\nConnection:Keep-Alive\r\nUser-Agent:Mozilla/4.0(compatible;MSIE6.0;Windows NT 5.0)\r\n\r\n";
				socket->Write((void*)http_req, strlen(http_req));
			}

		} else if(code == CODE_READ_READY){
			log_d("socket %s:%d READ_READY", socket->GetAddress().address, socket->GetPort());
			char buffer[1024] = {0};

			int dataRead = socket->Read(buffer, 1023);
			log_d("%d bytes read, %s", dataRead, buffer);

			if( dataRead <= 0){ // means it is closed
				// mux->RemoveFd(socket);
				((Socket*)socket)->Close();
			}
		} else if(code == CODE_WRITE_READY){
			log_d("socket %s:%d WRITE_READY", socket->GetAddress().address, socket->GetPort());
		} else if(code == CODE_CLOSED){
			log_d("socket %s:%d CLOSED", socket->GetAddress().address, socket->GetPort());
		} else if(code == CODE_CONNECT_TIMEOUT){
			log_d("socket %s:%d CONNECT_TIMEOUT", socket->GetAddress().address, socket->GetPort());
			((Socket*)socket)->Close();
		} else {
			log_d("socket %s:%d unhandle code %d", socket->GetAddress().address, socket->GetPort(), code);
		}

		return true;
	}

};

void testMultiplexIO(){


	MultiplexIO * mux = MultiplexIO::GetInstance();
	//mux->Start();

	Vector<Address> addresses;
	Address a1 = {"101.201.174.41", 7070};
	Address a2 = {"61.135.169.125", 80};
	Address a3 = {"117.110.0.11", 441};
	Address a4 = {"127.123.0.12", 442};
	Address a5 = {"127.98.10.123", 443};
	Address a6 = {"127.46.5.12", 8080};

	addresses.PushBack(a1);
	addresses.PushBack(a2);
	addresses.PushBack(a3);
	addresses.PushBack(a4);
	addresses.PushBack(a5);
	addresses.PushBack(a6);

	IoTestCallback io_callback;

	for(int i = 0; i<addresses.Size(); i++){

		Address address = addresses[i];
		log_d("connect socket %s:%d", address.address , address.port);

		ServerAddress sa(address.address, address.port);

		TcpSocket * socket = new TcpSocket(sa, false);
		int ret = socket->Connect();
		if(ret != 0){
			log_d("connet ret = %d", ret);
			((Socket*)socket)->Close();			
		}

		mux->AddFd(( Socket*)socket , & io_callback, NULL);
	}

	sleep(100000);
}


void testlist(){

	log_d("push and retrieve test");

	{

		List<tpl::SmartPtr<ComplexStruct> > l;

		for(int i = 0; i<TestCycles; i++){
			//int * pi = new int[1];
			//int op = rand() % 4;
			int op = 0;
			if((op > 1) && l.size() > 0){
				if(op == 2){
					l.retrieve_back();
				} else {
					l.retrieve_front();
				}
			} else {
				int a = rand();
				tpl::SmartPtr<ComplexStruct> ptr(new ComplexStruct(&a));
				if(op == 0){
					l.push_back(ptr);
				} else {
					l.push_front(ptr);
				}
			}
		}


		int size = l.size();

		for(int i = 0; i< size; i++){
			tpl::SmartPtr<ComplexStruct> ptr = l.retrieve_back();
			//printf("list_item %d\n", item);
		}

	}


	log_d("remove test");

	{
		List<ComplexStruct* > l;

		ComplexStruct* raw_list[TestCycles] = {0};

		for(int i = 0; i<TestCycles; i++){

			int a = rand();

			ComplexStruct* ptr = new ComplexStruct(&a);
			raw_list[i] = ptr;

			if(a % 2 == 0){
				l.push_back(ptr);
			} else {
				l.push_front(ptr);
			}			 
		}

		int size = l.size();

		for(int i = 0; i< size; i++){
			//ComplexStruct* ptr = l.retrieve_back();
			//delete ptr;

			l.remove(raw_list[i]);

			delete raw_list[i];
		}
	}
}

void testVector(){
	Vector<ComplexStruct> vct;

	int i = 0;
	ComplexStruct cs(&i);
	cs.dump();

	vct.PushBack(cs);

	ComplexStruct c =  vct[0];
	c.f1 = rand();

	vct[0].dump();

}




class MyTimerCallback : public TimerCallback{

public:

	MyTimerCallback(){
		log_d("MyTimerCallback default contructor 0x%08x", this);
	}

	MyTimerCallback (const MyTimerCallback & callback){
		log_d("MyTimerCallback copy constructor 0x%08x", this);
	}

	MyTimerCallback & operator = (const MyTimerCallback & callback){
		log_d("MyTimerCallback assignment 0x%08x", this);
		if(this  == &callback){
			return *this;
		}
		return *this;
	}

	~MyTimerCallback(){
		log_d("MyTimerCallback destructor 0x%08x", this);
	}

	//
	// OnTimeout callback
	// @param id timer id returned when call AddTimer
	// @param context, context provided when call AddTimer
	// @return positive value means to reset the timer with the timeout, 0 means do nothing, negative value to remove the timer
	//
	int OnTimeout(const TimeoutArgs & timeout_args) {
		//int id = timeout_args.timer_id;
		//void * context = timeout_args.context;

		// log_d("%ld OnTimedout tid %d, context 0x%08x \n", get_monotonic_time(), id, context);

		//ComplexStruct * cs = (ComplexStruct*) context;
		//cs->dump();

		return 0;
	}
};




void testVectorEmpty(){
	Vector<ComplexStruct> l;
	mark();
}

void testVectorClear(){

	Vector<tpl::SmartPtr<TimerCallback> > l;

	for(int i = 0; i < TestCycles; i++){
		tpl::SmartPtr<TimerCallback> callback1(new MyTimerCallback);	 
		l.PushBack(callback1);
	}

	//l.Clear();
	//mark();
}

void testVectorPop(){

	int count = 0;
	Vector<ComplexStruct> l;
	for(int i = 0; i < TestCycles; i++){
		ComplexStruct cs(&count);
		l.PushBack(cs);
		l.PopBack();
	}
	mark();
}

void testVector1(){
	//testVectorEmpty();
	testVectorClear();
	//testVectorPop();
}






void * timerFunc(void * cs){

	TimerManager * tm = TimerManager::GetInstance();

	for(int i = 0; i<10; i++){

		tpl::SmartPtr<TimerCallback> callback1(new MyTimerCallback);

		int id = tm->AddOnceTimer(callback1, 1000, cs);
		log_d("%ld AddOnceTimer tid %d, context 0x%08x \n", get_monotonic_time(), id, cs);

		if(i% 3 == 0){
			tm->RemoveTimer(id);
		}

		tm->RemoveTimer(rand());

		usleep(10000);
	}

	return NULL;
}







template<typename K, typename V>
class PP{

protected:
	K key_;
	V value_;

public:

	PP(){
		memset((void*)&key_, 0, sizeof(PP));
	}

	PP(K & k, V & v) {
		log_d("arguments address 0x%08x 0x%08x", &k, &v);
		key_ = k;
		value_ = v;
		log_d("fields address 0x%08x 0x%08x", &key_, &value_);
	}

	K & key() { return key_;}

	V & value()  {return value_;}

	bool operator == (const PP & PP){
		return (key_ == PP.key_ && value_ == PP.value_);
	}

	PP & operator = (const PP & PP){
		this->key_ = PP.key_;
		this->value_ = PP.value_;
		return *this;
	}
};

void refTest(){
	tpl::SmartPtr<MyTimerCallback> ptr(new MyTimerCallback);

	int key = 2;
	log_d("key addr = 0x%08x, ptr addr = 0x%08x", &key, &ptr);
	PP<int, tpl::SmartPtr<MyTimerCallback> >  pp(key, ptr);

	log_d("get key addr = 0x%08x, get value addr = 0x%08x", &pp.key(), &pp.value());

}

void testBuffer(){
	//Buffer b = "asdfasfasf";
	Buffer b3(10000);
	//Buffer a = "";
	Buffer c(b3);

	Buffer f = b3;
}


void testMap(){

	const int CNT = 100;	

	for(int n = 0; n < 10; n ++){

		Map<uint64_t, ComplexStruct*> map;
		int balance = 0;
		typedef ComplexStruct * PComplexStruct;

		for(int t = 0; t < kMapTestCycles; t++ ){

			uint64_t keys[CNT + 1];
			PComplexStruct pts[CNT];

			for(int i = 0; i< CNT; i++){

				uint64_t sn = (uint64_t)i;
				keys[i] = sn;

				ComplexStruct * cs = new ComplexStruct(&balance);
				pts[i] = cs;

				map.Put(sn, cs);
			}

			keys[CNT] = keys[CNT -1 ] + 1; 

			for(int j = 0; j < CNT + 1; j++){

				ComplexStruct ** cs = map.Get(keys[j]);

				if(cs == NULL && j < CNT){
					log_d("test failed 1");
				} 

				if(j == CNT && cs != NULL){
					log_d("test failed 2");
				}
			}

			for(int j = 0; j< CNT; j ++){

				ComplexStruct ** cs = map.Get(keys[j]);

				delete *cs;
				*cs = NULL;

				map.Remove(keys[j]);
			}


			MapIterator<uint64_t, ComplexStruct*> it(map);
			Pair<uint64_t, ComplexStruct*> * cursor = it.Next();
			int cnt = 1;
			while(cursor){
				log_e("!!!!! failed !!!");
				ComplexStruct * cs = cursor->value();
				if(!cs->IsValid()){
					log_e("data is invalid !!!!!");
				}
				cnt++;
				cursor = it.Next();
			}

			if(balance != 0){
				log_d("leaked !!!!");
			}

			map.dump();
		}
	}
}


int encrypt_test(char * key, int key_len,  char* input, int i_len, char * output, int o_len)
{
	if (input == NULL || i_len == 0) {
		return 0;
	}

	BF_KEY bfKey;
	BF_set_key(&bfKey, key_len, (const unsigned char*)key);
	//int n = 0;
	unsigned char ivec[8] = {0};

	BF_cbc_encrypt((unsigned char*)input, (unsigned char*)output, o_len, &bfKey, ivec, BF_ENCRYPT);

	return 0;
}

int decrypt_test(char * key, int key_len,  char* input, int i_len, char * output, int o_len)
{
	if (input == NULL || i_len == 0) {
		return 0;
	}

	BF_KEY bfKey;
	BF_set_key(&bfKey, key_len, (const unsigned char*)key);
	//int n = 0;
	unsigned char ivec[8] = {0};

	BF_cbc_encrypt((unsigned char*)input, (unsigned char*)output, o_len, &bfKey, ivec, BF_DECRYPT);

	return 0;
}



void blowfishCipherTest(){

	int key_len =32;
	const char * key = "12345678901234567890123456789012";

	char input[16] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16};
	char output[16] = {0};
	char output2[16] = {0};

	encrypt_test((char*)key, key_len, (char*)input, 16, (char*)output, 16);

	DUMP_HEX_EX("after encryption", output, 16);

	output[15] = 0;

	decrypt_test((char*)key, key_len, (char*)output, 16, (char*)output2, 16);

	DUMP_HEX_EX("after decryption", output2, 16);

}


void testLongLiveApi(){


}

void testRooboPacket(){
	RooboPacket * packet = new RooboPacket();
	packet->GetBody().Append("1234567890", 10);

	RooboPacket p = (*packet);
	RooboPacket c ;
	c = p;
	RooboPacket r((const RooboPacket &)*packet);

	DUMP_HEX_EX("dump body", r.GetBody().data(), r.GetBody().size());
	delete packet;
	packet = NULL;
}

// primitiveTest


// tpl::Vector<tpl::SmartPtr<TimerCallback> > vct;

void timerTest(){	
	for(int i = 0; i < 3; i++ ){
		tpl::SmartPtr<TimerCallback> callback1(new MyTimerCallback);
		TimerManager::GetInstance()->AddOnceTimer(callback1, 1000, NULL);

		tpl::SmartPtr<TimerCallback> callback2(new MyTimerCallback);
		int tid = TimerManager::GetInstance()->AddRepeatTimer(callback2, 800, NULL);
		TimerManager::GetInstance()->ResetTimer(tid, 800);

	}

}

void testMediaStream(){


	// MultiplexIO::GetInstance()->Start();

	ServerAddress sa("127.0.0.1", 8070);
	Vector<ServerAddress> addresses;
	addresses.PushBack(sa);


	MediaStream * media_stream = new MediaStream(addresses);
	SmartPtr<TimerCallback> mediaStream(media_stream);

	media_stream->Init(&mediaStream);
}

#define USE_APP

void testLinuxPort(){

	tpl::Vector<roobo::longliveconn::ServerAddress> addresses;

//#ifdef USE_APP

	const char * production = "domgy.app";
	roobo::longliveconn::ServerAddress server1("t1.roobo.net", 7080);
	const char * client_id = "dm:ddb464bfa68d78046bcbae18e027d379";  
	const char * public_key ="MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDSSwvej3JDqhN23fki0gDaNqDE" \
		"D1g6ox+OhETOnIALCo1KIImTjy9zpZPYLAmWuqPZV+X1aAPs56tvD9m1h1wNDmqV" \
		"lM0Tj9QlywEZX3/FKggoH5VBDlB6fCfjp+iI40eThzTGHPBI7Rj0kr10atE3WOdq" \
		"PQFn+ZXzzjz2U/35gQIDAQAB";
//#else
//	const char * production = "pudding1s.app";
//	roobo::longliveconn::ServerAddress server1("172.17.254.126", 7080);
//	const char * client_id = "1200000000200062";
//	const char * public_key ="MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCvyAKGh28yBs6Lo663BlkeNWG7YAUhWOnMzqeJoLqrwEyUQXV4lKS8id01rwBNrFKu3ARxKtag+pf79g3FvKenhcN+YwugIpf9zVkt/Difvjji4mR0gQ04d4Atlu6QMo+RFBEeIDcUGBn1W6fwXFgGdueBBcxvVnwB3e8Ud8d92wIDAQAB";
//
//#endif

	//"pudding1s.app"; domgy.app
	const char * app = "com.juan.roobo.domgy";
	const char * version = "1.0.0";
	const char * version_code = "1";
	const char * channel = "10000";
	const char * device = "t1";

	addresses.PushBack(server1);

	const char * token = "f9a622f8ab9748ddbfafe6a24bfcf97d";

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


//#ifdef USE_APP
	roobo::AuthInfo auth_info(client_id, public_key, token);
//#else
//	roobo::AuthInfo auth_info(client_id, public_key);
//#endif

	LongLiveConnLinuxApi api(client_config, auth_info);



	sleep(100000);
}


void testAes(){


	Buffer key("q7so2z3go47vu59z");
	key.ShrinkBack(1);

	Buffer data("l74FLchsmY4lNUXXYlBWSB1mbdBX8eo1fqVj6xwZ5f8=");
	data.ShrinkBack(1);

	Cipher * cipher = CipherFactory::GetInstance()->GetCipher(CA_AES, &key);
	bool decrypt_result = cipher->Decrypt(&data);
	if(decrypt_result){
		DUMP_HEX_EX("DECRYPTED", data.data(), data.size());
	}

	delete cipher;
}

#ifndef __ANDROID__

int main(){


	// testVector();
	//testAes();

	testLinuxPort();

	// testMediaStream();
	// timerTest();
	// testlist();

	// testVector1();
	/*
	int count = 0;
	ComplexStruct * p = (ComplexStruct*)malloc(sizeof(ComplexStruct) * 2);
	new (p)ComplexStruct(&count);
	free(p);
	*/


	// testRooboLlc();
	// timerTest();
	// testMultiplexIO();
	// testBlockQueue();
	//  testMap();
	// blowfishCipherTest();
	// sleep(1000000);

	// testRooboPacket();
	log_d("done");
	//sleep(1000);

	return 0;
}

#endif
