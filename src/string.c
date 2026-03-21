#include "string.h"

void* memset(void* dst, int value, size_t num) {
	volatile uint8_t* ptr = (uint8_t*)dst;
        for (size_t i = 0; i < num; i++) ptr[i] = (uint8_t)value;
        return dst;
}

