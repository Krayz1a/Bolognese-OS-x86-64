#include "vmm.h"
#include "limine.h"
#include "string.h"
#include "pmm.h"
#include "boot.h"

#define PAGE_SIZE 4096

extern uint8_t text_start_addr[];
extern uint8_t text_end_addr[];
extern uint8_t rodata_start_addr[];
extern uint8_t rodata_end_addr[];
extern uint8_t data_start_addr[];
extern uint8_t data_end_addr[];
extern uint8_t bss_start_addr[];
extern uint8_t bss_end_addr[];

uint64_t hhdm_offset;;



void vmm_map_page(uint64_t* pml4, uint64_t virtual_addr, uint64_t physical_addr, uint64_t flags){
	// PML4
	uint64_t entry = pml4[GET_PML4_INDEX(virtual_addr)];
	if (!(entry & PTE_PRESENT)) {
		uint64_t PDPT_paddr = pmm_alloc_page();
		memset((void*)(PDPT_paddr + hhdm_offset), 0, PAGE_SIZE);
		
		entry = (PDPT_paddr  & PTE_PADDR) | PTE_PRESENT;
	}
	pml4[GET_PML4_INDEX(virtual_addr)] = entry | flags;

	// PDPT
	uint64_t* pdpt = (uint64_t*)((entry & PTE_PADDR) + hhdm_offset);
	entry = pdpt[GET_PDPT_INDEX(virtual_addr)];
	if (!(entry & PTE_PRESENT)) {
		uint64_t PD_paddr = pmm_alloc_page();
		memset((void*)(PD_paddr + hhdm_offset), 0, PAGE_SIZE);
			
		entry = (PD_paddr  & PTE_PADDR) | PTE_PRESENT;
	}
	pdpt[GET_PDPT_INDEX(virtual_addr)] = entry | flags;

	// PD
	uint64_t* pd = (uint64_t*)((entry & PTE_PADDR) + hhdm_offset);
	entry = pd[GET_PD_INDEX(virtual_addr)];
	if (!(entry & PTE_PRESENT)) {
		uint64_t PT_paddr = pmm_alloc_page();
		memset((void*)(PT_paddr + hhdm_offset), 0, PAGE_SIZE);
			
		entry = (PT_paddr & PTE_PADDR) | PTE_PRESENT;
	}
	pd[GET_PD_INDEX(virtual_addr)] = entry | flags;
	
	// PT
	uint64_t* pt = (uint64_t*)((entry & PTE_PADDR) + hhdm_offset);
	pt[GET_PT_INDEX(virtual_addr)] = (physical_addr & PTE_PADDR) | PTE_PRESENT | flags;
}

void vmm_init(void) {
	hhdm_offset = hhdm_request.response->offset;
	uint64_t* kernel_pml4 = (uint64_t*)(pmm_page_alloc() + hhdm_offset);
	memset((void*)kernel_pml4, 0, PAGE_SIZE);

	uint64_t virt_base = executable_address_request.response->virtual_base;
    	uint64_t phys_base = executable_address_request.response->physical_base;
	uint64_t kernel_phys_offset = virt_base - phys_base;

	if(memmap_request.response != NULL) {
                for (size_t idx = 0; idx < memmap_request.response->entry_count; idx++) {
                        struct limine_memmap_entry *mm = memmap_request.response->entries[idx];

                        for (uint64_t p = mm->base; p < mm->base + mm->length; p += PAGE_SIZE) {
                                vmm_map_page(kernel_pml4, (p + hhdm_offset) & PAGE_ALIGN,
						p & PAGE_ALIGN, PTE_PRESENT | PTE_WRITABLE);
                        }
                }
        }

	// Now we need to map the kernel executable addresses
	// Start with .text
	for (uint64_t v = (uint64_t)&text_start_addr & PAGE_ALIGN	

}
