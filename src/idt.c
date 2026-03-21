#include "idt.h"
#include "io.h"
#include "pic.h"
#include "kprint.h"

#include <stdint.h>
#include <stdbool.h>

extern void draw_char(char c, uint32_t color);

const char kbd_US[128] = {
    0,  27, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', '\b',   
  '\t', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n',       
    0,  'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', '\'', '`',   
    0, '\\', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/',   0,
  '*',  0,  ' ',  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
    0,   0,   0,   0,   0,   0, '-',   0,   0,   0, '+',   0,   0,
    0,   0,   0,   0,   0,   0,   0,   0,   0
};

const char kbd_US_shifted[128] = {
    0,  27, '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '\b',
  '\t', 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', '\n',
    0,  'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':', '"', '~',
    0, '|', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', '<', '>', '?',   0,
  '*',  0,  ' ',  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
    0,   0,   0,   0,   0,   0, '-',   0,   0,   0, '+',   0,   0,
    0,   0,   0,   0,   0,   0,   0,   0,   0
};

static bool shift_pressed = false;

// The layout the CPU pushes to the stack
struct interrupt_frame {
	uint64_t rip;		// address where is crashes
	uint64_t cs; 		// code segment
	uint64_t rflags;	// CPU Flags
	uint64_t rsp;		// stack pointer
	uint64_t ss; 		// stack segment
} __attribute__((packed));


__attribute__((aligned(0x10)))
static struct idt_entry idt[256];
static struct idtr idtr;

static void idt_set_entry(uint8_t idx, void* isr, uint8_t flags) {
	struct idt_entry* idt_entry = &idt[idx];
	uint64_t isr_addr = (uint64_t)isr;

	idt_entry->isr_low = isr_addr & 0xFFFF;
	idt_entry->kernel_cs = 0x28;
	idt_entry->ist = 0;
	idt_entry->attributes = flags;
	idt_entry->isr_mid = (isr_addr >> 16) & 0xFFFF;
	idt_entry->isr_high = (isr_addr >> 32) & 0xFFFFFFFF;
	idt_entry->zero = 0;
}

__attribute__((interrupt))	// GCC automatically takes the stack pointer and passes it into this function as an argument
static void generic_exception_handler(struct interrupt_frame* frame) {
	print_str("\nnig nig nig nig nign igni\n");

	print_str(" RIP (Instruction) ");
	print_hex(frame->rip);
	print_str("\n");

	print_str(" RSP (Stack) ");
	print_hex(frame->rsp);
	print_str("\n");

	print_str(" HALTED\n");

	__asm__ __volatile__ ("cli; hlt");
}

__attribute__((interrupt))
static void keyboard_handler(struct interrupt_frame *frame) {
	(void)frame;
	uint8_t scancode = inb(0x60);	// 0x60 is the Keyboard controller data register
	
	if(scancode == 0x2A || scancode == 0x36) shift_pressed = true;

	else if(scancode == 0xAA || scancode == 0xB6) shift_pressed = false;

	else if(!(scancode & 0x80)){		// check if MSB is set, if not then its press (else release)
		char ascii = shift_pressed ? kbd_US_shifted[scancode] : kbd_US[scancode];
		if(ascii != 0){
			if(ascii == '\b') {
				print_str("\b \b");
			} else { 
				char str[2] = {ascii, '\0'};
				print_str(str);
			}

			draw_char(ascii, 0x00FF00);
		}
	}
	pic_send_eoi(1);	// keyboard wired to IRQ 1 of the Master PIC
}

void idt_init(void) {
	idtr.base = (uint64_t)&idt[0];
	idtr.limit = (uint16_t)sizeof(idt) - 1;

	for (int idx=0; idx < 32; idx++){
		idt_set_entry(idx, generic_exception_handler, 0x8E);
	}

	idt_set_entry(33, keyboard_handler, 0x8E);

	__asm__ __volatile__ ("lidt %0" : : "m"(idtr));
	__asm__ __volatile__ ("sti");
}
