#include "kprint.h"
#include "io.h"

// Sending a str to an I/O port
void print_str(const char *str){
        for(int i=0; str[i] != '\0'; i++){
                outb(0x3F8, str[i]);
        }
}

// Convert 64 bit number to hex string and prints it
void print_hex(uint64_t value){
        const char *hex_chars = "0123456789abcdef";
        char buffer[19];

        buffer[0]='0';
        buffer[1]='x';
        buffer[18]='\0';

        for (int i=17;i>=2;i--){
                buffer[i] = hex_chars[value & 0xF];
                value >>= 4;
        }

        print_str(buffer);
}

