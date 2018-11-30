#ifndef __ROOBO_SMART_PTR_H__
#define __ROOBO_SMART_PTR_H__

#include "../common/platform.h"

namespace tpl {

	template <typename T>

	class Reference {

		template <typename U> friend class SmartPtr;

	private:
		int self_count_;
		int ptr_count_;
		intptr_t detached_;
		T * ptr_;

	public: 

		explicit Reference(T * ptr)
			: self_count_(1), ptr_count_(1), detached_((intptr_t)0), ptr_(ptr)
		{
			assert(ptr_);
		}

		~Reference(){

		}

		inline int Clone(){
			return __sync_add_and_fetch(&self_count_, 1);
		}

		inline T * Get(int detach = 0){

			int n = __sync_add_and_fetch(&ptr_count_, 1);
			if(n < 1){ // unlikely to happen
				return NULL;
			}

			int b = __sync_bool_compare_and_swap((void **) &detached_, (void *) 0, (void *) (intptr_t) detach);
			if (!b) { // already detached
				Put();
				return NULL;
			}

			return ptr_;
		}

		inline int Put(int count = 1){

			int n = __sync_sub_and_fetch(&ptr_count_, count); 

			if(n < 0){
				log_e("");
			}

			assert(n >= 0);

			if (n == 0) { 
				T * handle_ptr = (T *) __sync_lock_test_and_set(&ptr_, NULL); 
				delete handle_ptr;
			}

			return n;
		}
	};



	template <typename T>

	//
	// smart pointer, it is thread safe for most of time.
	// note: it is unsafe if one thread is deleting SmartPtr, while another is caling copy constructor 
	//
	// TOTO no need to use atomic operation for single thread scoped usage
	//
	class SmartPtr
	{

	private:

		bool cloned_;
		int attach_count_;
		Reference<T> * ref_;

		void destruct(){

			if(attach_count_ > 0){
				Put(attach_count_);
				attach_count_ = 0;
			}

			if(cloned_){
				Release();
				cloned_ = false;
			}
		}

	public:

		SmartPtr()
			: cloned_(false), attach_count_(0), ref_(NULL)
		{
			//log_d("%s default ctor", __FUNCTION__);
		}

		explicit SmartPtr(T * ptr)
			: cloned_(true), attach_count_(0)
		{
			ref_ = new Reference<T>(ptr);
			//log_d("%s ctor with one pointer", __FUNCTION__);
		}

		//
		// Copy constructor
		//
		SmartPtr(const SmartPtr & smart_ptr)
			: cloned_(false), attach_count_(0)
		{ 
			ref_ = smart_ptr.ref_;
		 
			if(NULL != ref_ && ref_->Clone() > 0){
				cloned_ = true;
			}
			//log_d("%s copy ctor", __FUNCTION__);
		}

		//
		// Assigment operator
		//
		SmartPtr & operator = (const SmartPtr & smart_ptr){

			if(this == &smart_ptr){
				return  * this;
			}

			destruct();

			ref_ = smart_ptr.ref_;
			if(ref_ != NULL &&  ref_->Clone() > 0 ){
				cloned_ = true;
			}

			attach_count_ = 0;

			//log_d("%s assignment ctor", __FUNCTION__);

			return * this;
		}

		/*
		bool operator == (const SmartPtr & smart_ptr){
			return (ref_ == smart_ptr.ref_);
		}
		*/

		//
		// Destructor
		//
		~SmartPtr(){

			//log_d("%s", __FUNCTION__);

			destruct();
		}



		//
		// Get element pointer, return NULL if memory is released
		//
		inline T * Get(){

			if(ref_ == NULL || !cloned_){
				return NULL;
			}

			T * ptr =  ref_->Get();

			if(NULL != ptr){
				attach_count_++;
			}

			return ptr;
		}
 
	private:

		//
		// Done using wrapped pointer
		//
		inline int Put(int count = 1){

			if(NULL == ref_){
				return -1;
			}

			int ret =  ref_->Put(count);

			if(ret >= 0){
				attach_count_ --;
			}

			return ret;
		}



		//
		// Release smart pointer, calling thread does not use the smart pointer any more
		//
		inline int Release()
		{
			if(NULL == ref_){
				return -1;
			}

			int n = __sync_sub_and_fetch(&ref_->self_count_, 1);

			//log_d("%s n = %d\n", __FUNCTION__, n);

			assert(n >= 0);

			if (n > 0) {
				// log_d("%s n = %d, skip free_callback \n", __FUNCTION__, n);
				return n;
			}

			if (ref_->detached_ == 0) {
				ref_->Put();
			}

			assert(ref_->ptr_count_ == 0);

			log_d("%s deleting reference 0x%08x", __PRETTY_FUNCTION__,  ref_);

			delete ref_;
			ref_ = NULL;

			return n;
		}

		//
		// Force release
		//
		inline int Delete( )
		{
			if(NULL == ref_){
				return -1;
			}

			T * ptr = ref_->Get(1);

			// log_d("%s ptr = 0x%08x\n", __FUNCTION__, ptr);

			if (ptr != NULL) {
				__sync_sub_and_fetch(&ref_->ptr_count_, 1);
				ref_->Put();
			}

			return Release();
		}
	};
}

#endif // __ROOBO_SMART_PTR_H__
