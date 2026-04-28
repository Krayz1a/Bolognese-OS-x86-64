#ifndef VMM_H
#define VMM_H

#include <stdint.h>

// ----- Virtual Address Slicing Macros ----- //
#define GET_PML4_INDEX(addr) (((addr) >> 39) & 0x1FF)
#define GET_PDPT_INDEX(addr) (((addr) >> 30) & 0x1FF)
#define GET_PD_INDEX(addr) (((addr) >> 21) & 0x1FF)
#define GET_PT_INDEX(addr) (((addr) >> 12) & 0x1FF)
#define GET_OFFSET(addr) ((addr) & 0xFFF)

// ----- Page Table Entry (PTE) Hardware Flags ----- //
#define PTE_PRESENT (1ULL << 0)		// Bit 0: Is the page in memory
#define PTE_WRITABLE (1ULL << 1)	// Bit 1: Is the page writable
#define PTE_USER (1ULL << 2)		// Bit 2: Can user mode program touch it
#define PTE_PADDR 0x000FFFFFFFFFF000	// Bit 12-51: Phyisical Base Address of the next table
#define PTE_NX (1ULL << 63)		// Bit 3: No Execute


void vmm_init(void);
void vmm_map_page(uint64_t* pml4, uint64_t virtual_addr, uint64_t physical_addr, uint64_t flags);

#endif
