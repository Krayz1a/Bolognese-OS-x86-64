#include "pmm.h"
#include "io.h"
#include "limine.h"
#include "kprint.h"
#include "string.h"

#include <stdint.h>
#include <stddef.h>

#define PAGE_SIZE 4096

__attribute__((used, section(".limine_requests")))
static volatile struct limine_memmap_request memmap_request = {
        .id = LIMINE_MEMMAP_REQUEST_ID,
        .revision = 0
};

__attribute__((used, section(".limine_requests")))
static volatile struct limine_hhdm_request hhdm_request = {
        .id = LIMINE_HHDM_REQUEST_ID,
        .revision = 0
};

uint8_t* bitmap;
uint64_t bitmap_pbase;
size_t bitmap_size;
uint64_t highest_usable_addr;
static size_t last_scanned_i = 0;

// Safely set a bit to 1 (USED / RESERVED)
void pmm_mark_used(uint64_t physical_addr) {
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
        uint64_t byte_idx = frame_idx / 8;
        uint8_t bit_idx = frame_idx % 8;
        bitmap[byte_idx] |= (1 << bit_idx);
}

// Safely set a bit to 0 (FREE)
void pmm_mark_free(uint64_t physical_addr) {
        uint64_t frame_idx = physical_addr / PAGE_SIZE;
        uint64_t byte_idx = frame_idx / 8;
        uint8_t bit_idx = frame_idx % 8;
        bitmap[byte_idx] &= ~(1 << bit_idx);
}

void pmm_dump_usable_memmap(void) {
	if(memmap_request.response != NULL) {
                for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
                        struct limine_memmap_entry *mm = memmap_request.response->entries[idx];
                        if(mm->type != LIMINE_MEMMAP_USABLE) continue;
                        print_str("\n\nbase: ");
                        print_hex(mm->base);
                        print_str("\nlength: ");
                        print_hex(mm->length);
                        print_str("\ntype: ");
                        print_hex(mm->type);
                }
        }
}

uint64_t pmm_max_usable_addr(void) {
	uint64_t max = 0;
	if(memmap_request.response != NULL) {
                for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
                        struct limine_memmap_entry *mm = memmap_request.response->entries[idx];
                        if(mm->type != LIMINE_MEMMAP_USABLE) continue;
                        if(max<mm->base+mm->length) max=mm->base+mm->length;
                }
        }
	return max;
}

size_t pmm_get_bitmap_size(void) {
	return (((highest_usable_addr + PAGE_SIZE - 1) / PAGE_SIZE) + 7) / 8;
}

uint64_t pmm_get_bitmap_pbase(void){
	if(memmap_request.response != NULL) {
                for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
                        struct limine_memmap_entry *mm = memmap_request.response->entries[idx];
                        if (mm->type != LIMINE_MEMMAP_USABLE) continue;
			if ((uint64_t)bitmap_size < mm->length) {
				return mm->base;
			}
                }
        }
	return 0;
}

void pmm_zero_usable_pages(void) {
	if(memmap_request.response != NULL) {
		for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
			struct limine_memmap_entry *mm = memmap_request.response->entries[idx];
			if (mm->type != LIMINE_MEMMAP_USABLE) continue;
			
			// Setting all usable memory to 0
			for (uint64_t p = mm->base; p < mm->base + mm->length; p += PAGE_SIZE) {
				pmm_mark_free(p);
			}
		}
		// Setting back bitmap memory to 1
		for (uint64_t p = bitmap_pbase; p < bitmap_pbase + bitmap_size; p += PAGE_SIZE) {
			pmm_mark_used(p);
		}
	}
}

uint64_t pmm_alloc_page(void) {
	uint64_t* bitmap_64 = (uint64_t*)bitmap;
	size_t bitmap64_size = bitmap_size / 8;
	
	// Start scanning from where we last found a free page
	for (size_t i = last_scanned_i; i < bitmap64_size; i++) {
		if(bitmap_64[i] == 0xFFFFFFFFFFFFFFFF) continue;

		size_t index = __builtin_ffsll(~(bitmap_64[i])) - 1;

		size_t page_idx = i * 64 + index;
		uint64_t paddr = page_idx * PAGE_SIZE;

		pmm_mark_used(paddr);
		last_scanned_i = i;
		return paddr;
	}

	// If we reached the end of the RAM and didn't find anything,
	// we wrap around and seach from 0 up to where we started.
	for (size_t i = 0; i < last_scanned_i; i++) {
		if(bitmap_64[i] == 0xFFFFFFFFFFFFFFFF) continue;

                size_t index = __builtin_ffsll(~(bitmap_64[i])) - 1;

                size_t page_idx = i * 64 + index;
                uint64_t paddr = page_idx * PAGE_SIZE;
        
                pmm_mark_used(paddr);
		last_scanned_i = i;
                return paddr;
	}

	// We only check the remainder bytes if the main RAM is completely full
	for (size_t i = bitmap_size & ~0x7ULL; i < bitmap_size; i++) {
		uint64_t byte = (uint64_t)bitmap[i] | ~((1ULL << 8) - 1ULL);

		if(byte == 0xFFFFFFFFFFFFFFFF) continue;
		size_t index = __builtin_ffsll(~(byte)) - 1;

		size_t page_idx = i * 8 + index;
		uint64_t paddr = page_idx * PAGE_SIZE;

		pmm_mark_used(paddr);
		return paddr;
	}
	
	// Run out of memory
	return 0;
}

void pmm_free_page(uint64_t paddr) {
	pmm_mark_free(paddr);
	size_t freed_chunk_idx = (paddr / PAGE_SIZE) / 64;
	
	if (freed_chunk_idx < last_scanned_i) {
		last_scanned_i = freed_chunk_idx;
	}
}

void pmm_init(void){
	//Initiallize global variables
	highest_usable_addr = pmm_max_usable_addr();
	bitmap_size = pmm_get_bitmap_size();
	bitmap_pbase = pmm_get_bitmap_pbase();
	bitmap = (uint8_t*)(bitmap_pbase + hhdm_request.response->offset);	// Offset to virtual base
	
	// Setting all pages in bitmap to be used (for now)
	memset(bitmap, 0xFF, bitmap_size);

	// Zero all usable pages (bitmap memory address will be 1 (used))
	pmm_zero_usable_pages();

	
	pmm_dump_usable_memmap();
        print_str("\n\nMax Usable Addr: ");
        print_hex(highest_usable_addr);
        print_str("\n\nbitmap_vbase: ");
        print_hex((uint64_t)bitmap);

}
