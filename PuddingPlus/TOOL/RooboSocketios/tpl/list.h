#ifndef ROOBO_LIST_H_
#define ROOBO_LIST_H_

#include <assert.h>
#include <cstddef>


namespace tpl {

	//
	// Doubly linked list
	//
	template <typename T>

	class ListNode {

	public:		

		T data_;
		ListNode<T> * next_;
		ListNode<T> * pre_;

	public:

		ListNode()
			: next_(0), pre_(0)
		{
		}

		explicit ListNode(const T & data)
			: data_(data), next_(0), pre_(0)
		{

		}
	};


	template <typename T>
	class List{

	protected:
		ListNode<T> * _head;
		ListNode<T> * _tail;
		int _size;

	public:

		List(){
			_tail = _head = NULL;		
			_size = 0;
		}

		ListNode<T> * GetHead(){
			return _head;
		}

		ListNode<T> * GetTail(){
			return _tail;
		}

		void push_back(T & item){

			ListNode<T> * node = new ListNode<T>(item);

			if(_tail){
				_tail->next_ = node;
				node->pre_ = _tail;
				_tail = _tail->next_;
			} else {
				assert(_head == NULL);
				_head = _tail = node;
			}

			_size++;
		}


		void push_front(T & item){

			ListNode<T> * node = new ListNode<T>(item);

			if(_head){
				node->next_ = _head;
				_head->pre_ = node;
				_head = node;
			} else {				 
				_head = _tail = node;
			}

			_size++;
		}



		T retrieve_front(){

			ListNode<T> * node = _head;
			_head = _head->next_;

			if(!_head){
				_tail = _head;
			} else {
				_head->pre_ = NULL;
			}

			T item = node->data_;

			delete node;
			node = NULL;
			--_size;

			return item;
		}



		T  retrieve_back(){

			ListNode<T> * node = _tail;
			_tail =_tail->pre_;
			if(_tail){
				_tail->next_ = NULL;
			} else {
				_head = _tail;
			}

			T  item = node->data_;
			delete node;
			node = NULL;

			--_size;
            
			return item;
		}


		void remove(T & item){

			ListNode<T> * node = _head;

			while(node){
				if(node->data_ == item){
					if(node->next_){
						node->next_->pre_ = node->pre_;
					} else { // its tail
						_tail = _tail->pre_;
					}

					if(node->pre_){
						node->pre_->next_ = node->next_;
					} else{ // its head
						_head = node->next_;
						if(_head){
							_head->pre_ = NULL;
						} else {
							_tail = _head = NULL;
						}
					}

					delete node;
					node = NULL;
					--_size;

					break;
				}

				node = node->next_;
			}
		}


		T * find(T & item){
			ListNode<T> * node = _head;
			while(node){
				if(node->data_ == item){
					return &(node->data_);
				}
			}
			return NULL;
		}


		int size(){
			return _size;
		}


		void clear(){

			ListNode<T> * node = _head;
			ListNode<T> * tmp = NULL;

			while(node){
				tmp = node;
				node = node->next_;
				delete tmp;
			}

			_head = _tail = NULL;
		}
	};

}

#endif // ROOBO_LIST_H_