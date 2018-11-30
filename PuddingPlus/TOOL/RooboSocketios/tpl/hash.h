#ifndef ROOBO_HASH_H_
#define ROOBO_HASH_H_

namespace tpl {

template<typename T>


unsigned int Hash(T & item, int table_size){	

	unsigned int sum = 0;

	int size = sizeof(T);

	char * p =  reinterpret_cast<char*>(&item);
	for(int i = 0; i<size; i++){
		sum += p[i];
	}	

	return sum % table_size;	 
}

}

#endif