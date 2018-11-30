#ifndef ROOBO_PAIR_H_
#define ROOBO_PAIR_H_

#include <string.h>

namespace tpl {

	template<typename K, typename V>
	class Pair{

	protected:
		K key_;
		V value_;

	public:

		Pair(){
			// memset((void*)&key_, 0, sizeof(Pair));
		}

		Pair(K & k, V & v) {
			key_ = k;
			value_ = v;
		}

		K & key() { return key_;}

		V & value()  {return value_;}

		bool operator == (const Pair & pair){
			return (key_ == pair.key_ && value_ == pair.value_);
		}

		Pair & operator = (const Pair & pair){
			this->key_ = pair.key_;
			this->value_ = pair.value_;
			return *this;
		}
	};

}

#endif // ROOBO_PAIR_H_