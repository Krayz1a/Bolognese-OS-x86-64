#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include "limine.h"
#include "idt.h"
#include "pic.h"
#include "io.h"
#include "font.h"
#include "pmm.h"
#include "kprint.h"

#define PAGE_SIZE 4096


// Cursor location on screen
uint32_t cursor_x = 0;
uint32_t cursor_y = 0;

__attribute__((used, section(".limine_requests")))
static volatile uint64_t base_revision[] = LIMINE_BASE_REVISION(3);

// Force the compiler to keep this struct and put it in a special section
__attribute__((used, section(".limine_requests")))
static volatile struct limine_framebuffer_request framebuffer_request = {
	.id = LIMINE_FRAMEBUFFER_REQUEST_ID,
	.revision = 0
};

// Halt forever
static void hcf(void){
	__asm__ __volatile__ ("cli");
	for (;;){
		__asm__ __volatile__ ("hlt");
	}
}

// Raw pixel drawing function
void draw_pixel(uint32_t x, uint32_t y, uint32_t color) {
	struct limine_framebuffer *fb = framebuffer_request.response->framebuffers[0];
	uint32_t *pixels = fb->address;

	// Pitch is in bytes. Since our pixels are 32-bit (4 bytes), we divide pitch by 4
	uint32_t pixels_per_row = fb->pitch / 4;
	pixels[(y*pixels_per_row) + x] = color;
}

// Color rendering function
void draw_char(char c, uint32_t color) {
	if (c == '\n') {
		cursor_x = 0;
		cursor_y += 16;
		return;
	} else if (c == '\b') {
		if(cursor_x >= 8) cursor_x -= 8;
		else if (cursor_y >= 16) {	// wrap backward to the end of the previous line
			uint32_t screen_width = framebuffer_request.response->framebuffers[0]->width;
			cursor_x = screen_width -8;
			cursor_y -= 16;
		}

		for (int y=0; y < 16; y++) {
			for (int x=0; x<8; x++) {
				draw_pixel(cursor_x + x, cursor_y + y, 0x000000);
			}
		}
		return;
	}


	PSF1_HEADER *font_header = (PSF1_HEADER*)_binary_src_font_psf_start;

	if (font_header->magic[0]!=PSF1_MAGIC0 || font_header->magic[1]!=PSF1_MAGIC1) return;

	uint8_t *glyph_data = (uint8_t*)(_binary_src_font_psf_start + sizeof(PSF1_HEADER));

	int font_idx = (unsigned char)c;
	uint8_t *glyph = glyph_data + (font_idx * font_header->chars_size);

	for (int y=0; y < font_header->chars_size; y++) {
		uint8_t row_data = glyph[y];
		for (int x=0; x < 8; x++) {
			if ((row_data >> (7-x)) & 1) {
				draw_pixel(cursor_x + x, cursor_y + y, color);
			}
		}
	}

	cursor_x += 8;
	if (cursor_x >= framebuffer_request.response->framebuffers[0]->width) {
		cursor_x = 0;
		cursor_y += 16;
	}
}

// The Main Kernel Entry Point
void kernel_main(void){
	if(LIMINE_BASE_REVISION_SUPPORTED(base_revision) == false){
		hcf();
	}

	idt_init();

	print_str("Hello from the 64-bit Higher Half!\n");

	pic_remap(32,40);
	
	pmm_init();	
	

	// __asm__ __volatile__ ("int $0");
	for (;;) {
		__asm__ __volatile__ ("hlt");
	}
}
