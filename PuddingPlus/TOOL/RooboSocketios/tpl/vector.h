#ifndef ROOBO_VECTOR_H_
#define ROOBO_VECTOR_H_

#include <string.h>
#include <stdlib.h>
#include <new>
#include "../common/log.h"

#ifndef DefaultVecotrSize
#define DefaultVecotrSize 5
#endif

namespace tpl {

	//
	// basic vector implementation
	// issue: memroy will not be released immediately after poping
	//
	template<typename T>
	class Vector{

	protected:

		T  * data_;
		int  size_;	
		int  capacity_;

		void Init(int capacity){
			data_ = (T*) malloc(sizeof(T) * capacity);
			//log_d("Init data_ = 0x%08x", data_);
			capacity_ = capacity;
		}

		void DoResize(int new_size){

			if(new_size == capacity_) {
				return ;
			}

			T * tmp =  (T*) malloc(sizeof(T) * new_size);

			for(int i = 0; i < size_; i++){
				new ((void*)(tmp + i)) T(data_[i]);
			}

			if(capacity_ > 0 && data_ != NULL){				
				for(int i = 0; i < size_; i++){
					(data_ + i)->~T();
				}
				free(data_);
			}

			data_ = tmp;
			capacity_ = new_size;
		}


	public:


		Vector() : data_(NULL), size_(0), capacity_(0) {
			Init(DefaultVecotrSize);
		}


		explicit Vector(int capacity) : data_(NULL), size_(0), capacity_(0){
			Init(capacity);
		}


		Vector & operator = (const Vector & vct){

			if(this == &vct){
				return *this;
			}

			if(this->capacity_ > 0){
				for(int i = 0; i < vct.size_; i++){
					(data_ + i)->~T();
				}
				free(data_);
			}

			if(vct.size_ > 0){
				capacity_ = vct.capacity_;
				size_ = vct.size_;
				data_ =  (T*) malloc(sizeof(T) * capacity_); 
				for(int i = 0; i < vct.size_; i++){
					new ((void*)(data_ + i)) T(vct.data_[i]);
				}

			} else {
				Init(DefaultVecotrSize);
			}

			return *this;
		}


		Vector(const Vector & vct){

			if(this == &vct){
				return;
			}

			if(vct.size_ > 0){
				capacity_ = vct.capacity_;
				size_ = vct.size_;
				data_ = (T*) malloc(sizeof(T) * capacity_);
				for(int i = 0; i<vct.size_; i++){
					new ((void*)(data_ + i)) T(vct.data_[i]);
				}
			} else {
				Init(DefaultVecotrSize);
			}
		}


		virtual ~Vector(){

			Clear();

			if(data_){
				//log_d("~Vector free data_ = 0x%08x", data_);
				free(data_);
				data_ = NULL;
			}
		}

		void Resize(int new_size){
			DoResize(new_size);
		}

		void PushBack(const T & item){

			if(size_ >= capacity_){
				DoResize(size_ * 2);
			}

			void * mem = (void*)(data_ + size_);
			new (mem) T(item);

			++size_;
		}

		void PushFront(const T & item){

			if(size_ >= capacity_){
				DoResize(size_ * 2);
			}

			for(int i = size_ ; i >= 0; i--){

				if(i < size_){
					(data_ + i)->~T();
				}

				if(i == 0){
					new ((void*)(data_ + i)) T(item);
				}else {
					new ((void*)(data_ + i)) T(data_[i - 1]);
				}
			}

			++size_;
		}

		void PopBack(){

			if(size_ <= 0){
				return;
			}

			(data_ + size_- 1)->~T();

			--size_;
		}

		void PopFront(){		

			if(size_ <= 0){
				return;
			}

			data_->~T();

			for(int i = 0; i< size_ - 1; i++){
				data_[i] = data_[i+1];
			}
			--size_;
		}

		T & Back(){
			return data_[size_ - 1];
		}

		T & Front(){
			return data_[0];
		}

		// Remove item from vector 
		bool Remove(T & item){
			for(int i = 0; i<size_; i++){
				if(data_[i] == item){
					
					for(int j = i; j <= size_ - 1; j++){
						(data_ + j)->~T();						 
						if(j < size_ -1){						
							new ((void*)(data_ + j)) T( data_[ j + 1 ] );
						}
					}

					--size_;
					return true;
				}
			}
			return false;
		}

		int Size(){
			return size_;
		}

		void Clear(){
			while(size_ > 0){
				PopBack();
			}
		}

		T & operator [] (int index){
			return data_[index];
		}
	};
}

#endif // ROOBO_VECTOR_H_