#ifndef IDT_H
#define IDT_H
#endif

#include <stdint.h>

struct idt_entry {
	uint16_t isr_low;	// low 16 bits (0 - 15) of the isr address
	uint16_t kernel_cs;	// Offset in the GDT (privilege level selector)
	uint8_t ist;		// Interrupt Stack Table index
	uint8_t attributes;	// flag byte for the CPU
	uint16_t isr_mid;	// bits 16-31 of the isr address
	uint32_t isr_high;	// bits 32-63 of the isr address
	uint32_t zero;		// 32 bits of 0 (required to complete 16 bytes)
} __attribute__((packed));


// The IDTR (Interrupt descriptor Table Register)
// A special register that stores the location and size of the IDT (Interrupt Descriptor Table)
struct idtr {
	uint16_t limit;		// IDT size (bytes), usually 4096
	uint64_t base;		// IDT virtual memory base
} __attribute__((packed));


void idt_init(void);
