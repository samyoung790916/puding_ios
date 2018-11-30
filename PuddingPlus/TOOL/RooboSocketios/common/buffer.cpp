#include "buffer.h"

#include <memory.h>

#if defined(ANDROID) || defined(__ANDROID__)
#include <stdio.h>
#include <stdlib.h>
#endif

#include "log.h"

namespace roobo {

#define DEFAULT_BUFFER_ELEMENT_SIZE 10


	Buffer::Buffer() :data_(0), size_(0), capacity_(0){
		DoResize(DEFAULT_BUFFER_ELEMENT_SIZE);
	}

	Buffer::Buffer(int capacity) : data_(0), size_(0), capacity_(0){
		DoResize(capacity);	
	}

	Buffer::Buffer(const char * str) : data_(0), size_(0), capacity_(0){
		int capacity = strlen(str) + 1;
		DoResize(capacity);
		size_ = capacity;
		memcpy(data_, str, (size_t)size_);
	}

	Buffer::Buffer(Buffer & buffer): data_(0), size_(0), capacity_(0){
		
		DoResize(buffer.capacity_);
		size_ = buffer.size_;
		if(size_ > 0){
			memcpy(data_, buffer.data_, size_ * sizeof(char));
		}
	}


	Buffer & Buffer::operator = (Buffer & buffer){
	
		DoResize(buffer.capacity_);
		size_ = buffer.size_;
		if(size_ > 0){
			memcpy(data_, buffer.data_, size_ * sizeof(char));
		}
	
		return *this;
	}


	Buffer & Buffer::operator = (char * str){
	 
		int capacity = strlen(str) + 1;
		DoResize(capacity);
		size_ = capacity;

		memcpy(data_, str, (size_t)size_);

		return *this;
	}


	void Buffer::DoResize(int new_size){

		if(new_size <= 0){
			return;
		}

		char * tmp = new char[new_size];
		if(size_ > 0){
			memcpy(tmp, data_, (size_t)( size_ * sizeof(char)));
		}

		if(capacity_ > 0){
			delete[] data_;
		}

		data_ = tmp;
		capacity_ = new_size;
	}

	void Buffer::Resize(int size){
		DoResize(size);
	}

	Buffer & Buffer::operator = (const char * str){

		int capacity = strlen(str) + 1;
		DoResize(capacity);
		size_ = capacity;
		memcpy(data_, str, (size_t)size_);

		return *this;
	}

	//
	// user takes the risk
	//
	char &  Buffer::operator[](int index){
		return data_[index];
	}

	void Buffer::EnsureCapacity(int size){
		if(size <= 0){
			return;
		}

		if(size + size_ > capacity_){
			DoResize(size + size_);
		}
	}

	void Buffer::ShrinkFront(int size){

		if(size <= 0 || size > size_){
			return;
		}
 
		size_ -= size;

		for(int i = 0; i< size_; i++){
			data_[i] = data_[i + size];
		}
	}


	void Buffer::ShrinkBack(int size){
		if( size_ >= size && size > 0){
			size_ -= size;
		}
	}

	void Buffer::Append(const char * str, int len){

		if(len <= 0){
			return;
		}

		if(size_ + len > capacity_){
			DoResize(size_ + len);
		}

		for(int i = 0; i < len; i++){
			data_[size_++] = str[i];
		}	
	}

	Buffer::~Buffer(){
		if(capacity_ > 0 && data_){
			delete[] data_;
			data_ = NULL;
		}
	}


	void Buffer::Clear(){
		size_ = 0;
	}


	void Buffer::GrowSize(int size){
		
		if(size <= 0){
			return;
		}

		if(size + size_ > capacity_){
			return;
		}

		size_ += size;
	}


	void  Buffer::Assign(void * data, int len){

		if( len <= 0 || data == NULL){
			return;
		}

		if(len > capacity_){
			DoResize(len);
		}

		memcpy(data_, data, len);
		size_ = len;
	}
}