#ifndef PMM_H
#define PMM_H

#include <stdint.h>
#include <stddef.h>

// Dump info
void pmm_dump_usable_memmap(void);

// Initialization
uint64_t pmm_max_usable_addr(void);
size_t pmm_get_bitmap_size(void);
uint64_t pmm_get_bitmap_pbase(void);
void pmm_zero_usable_pages(void);

// Paging
uint64_t pmm_alloc_page(void);
void pmm_free_page(uint64_t paddr);

// Init
void pmm_init(void);



#endif
