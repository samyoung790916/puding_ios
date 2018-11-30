#ifndef __ROOBO_CLIENT_CONFIG_H_
#define __ROOBO_CLIENT_CONFIG_H_

#include "../longliveconn/data_types.h"
#include "../tpl/vector.h"
#include "../tpl/smart_ptr.h"
#include "../common/platform.h"

namespace roobo {

#define COPY_FIELD(x, max) \
	int x##_len = strlen(x); \
	assert(x##_len > 0); \
	int x##_size = x##_len > max - 1 ? max - 1: x##_len;\
	memcpy(x##_, x, x##_size); \
	x##_[x##_size] = '\0'

	//
	// doc reference: http://wiki.365jiating.com/pages/viewpage.action?pageId=1933511
	//
	class ClientConfig {

	public:

		const static int kMaxFieldSize = 64;

	 

	public:

		/***
		* @param server_address
		* @param product
		* @param app
		* @param version
		* @param version_code
		* @param channel
		* @param device
		* */
		ClientConfig(const tpl::Vector<roobo::longliveconn::ServerAddress> & server_addresses, const char *  product, const char *  app, const char *  version,
			const char *  version_code, const char *  channel, const char *  device) 
			: server_address_(server_addresses)
		{
			assert(server_address_.Size()> 0);	

			COPY_FIELD(product, kMaxFieldSize);

			COPY_FIELD(app, kMaxFieldSize);

			COPY_FIELD(version, kMaxFieldSize);

			COPY_FIELD(version_code, kMaxFieldSize);

			COPY_FIELD(channel, kMaxFieldSize);
 
			COPY_FIELD(device, kMaxFieldSize);

		}

		const char *  GetApp() {
			return app_;
		}

		const char *  GetVersion() {
			return version_;
		}

		const char *  GetVersionCode() {
			return version_code_;
		}

		const char *  GetChannel() {
			return channel_;
		}

		const char *  GetDevice() {
			return device_;
		}

		const char *  GetProduct(){
			return product_; 
		}

		tpl::Vector<roobo::longliveconn::ServerAddress> GetServerAddress() const{
			return server_address_;
		}

	private:

		tpl::Vector<roobo::longliveconn::ServerAddress> server_address_;

		// App, package: com.roobo.t1.client
		char app_[kMaxFieldSize];

		// App version: 1.0.0.0
		char version_[kMaxFieldSize];

		// version code: 1
		char version_code_[kMaxFieldSize];

		// channel id
		char channel_[kMaxFieldSize];

		// device type, eg: android, ios, croobo, pudding1s
		char device_[kMaxFieldSize];

		char product_[kMaxFieldSize];

	};

}

#endif // __ROOBO_CLIENT_CONFIG_H_


