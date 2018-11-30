#ifndef ROOBO_BUFFER_H_
#define ROOBO_BUFFER_H_

namespace roobo {

	class Buffer {

	protected:
		char * data_;	// data pointer of the buffer
		int size_;		// valid data size
		int capacity_;	// capacity of the buffer

		void DoResize(int new_size);

	public:

		Buffer();

		explicit Buffer(int capacity);

		// construct Buffer from const string, note: the terminating null character would be count in
		explicit Buffer(const char * str);

		Buffer(Buffer & buffer);

		virtual ~Buffer();

		void Resize(int size);
 
		char * data() const {return data_;}

		char * c_str() const {return data_;}

		int size() const {return size_;}

		int capacity(){return capacity_;}

		int free_space(){return capacity_ - size_;}

		Buffer & operator= (const char * str);

		Buffer & operator= (char * str);

		Buffer & operator= (Buffer & buffer);

		char & operator[](int index);

		//
		// Make sure enough free space is available
		//
		void EnsureCapacity(int size);

		//
		// Shrink data at front
		//
		void ShrinkFront(int size);

		//
		// Shrink data at end
		//
		void ShrinkBack(int size);

		//
		// Clear all data, capacity is not changed though
		//
		void Clear();

		//
		// Append data to the end
		//
		void Append(const char * str, int len);

		//
		// Grow data size
		//
		void GrowSize(int size);

		//
		// Assign data to buffer, existing data would be overwritten
		//
		void Assign(void * data, int len);
	};
}

#endif // ROOBO_BUFFER_H_
