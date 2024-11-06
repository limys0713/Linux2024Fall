#include "../include/reverse.h"
char *reverse(char *dest, const char *src)
{	
	int length = 0;
	// Find the length of the string
	while(src[length] != '\0'){
		length++;
	}

	// Reverse the string
	for(int i = 0; i < length; i++){
		dest[i] = src[length - 1 - i];
	}

	return dest;
}
