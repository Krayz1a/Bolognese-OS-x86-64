#ifndef FONT_H
#define FONT_H

#include <stdint.h>

#define PSF1_MAGIC0 0x36
#define PSF1_MAGIC1 0x04

typedef struct {
	uint8_t magic[2];
	uint8_t mode;
	uint8_t chars_size;
} __attribute__((packed)) PSF1_HEADER;

extern uint8_t _binary_src_font_psf_start[];

#endif
