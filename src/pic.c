#include "pic.h"
#include "io.h"

// PIC Hardware I/O Ports
#define PIC1_COMMAND 0x20
#define PIC1_DATA 0x21
#define PIC2_COMMAND 0xA0
#define PIC2_DATA 0xA1

// Initialization Command Words
#define ICW1_INIT 0x11
#define ICW4_8086 0x01

// Send EOI
void pic_send_eoi(unsigned char irq) {
	if(irq >= 8) {
		outb(PIC2_COMMAND, 0x20);
	}
	outb(PIC1_COMMAND, 0x20);
}

void pic_remap(int offset1, int offset2) {
	// reset (ICW1)
	outb(PIC1_COMMAND, ICW1_INIT);
	io_wait();
	outb(PIC2_COMMAND, ICW1_INIT);
	io_wait();

	// send offsets (ICW2)
	outb(PIC1_DATA, offset1);
	io_wait();
	outb(PIC2_DATA, offset2);
	io_wait();

	// tell master the slave is at pin #2 and tell slave "you are wired to master's pin 2" (ICW3)
	outb(PIC1_DATA, 0x04);
	io_wait();
	outb(PIC2_DATA, 0x02);
	io_wait();

	// architecture mode
	outb(PIC1_DATA, ICW4_8086);
	io_wait();
	outb(PIC2_DATA, ICW4_8086);
	io_wait();

	// restoring interrrupt masks
	outb(PIC1_DATA, 0xFD);
	outb(PIC2_DATA, 0xFF);
}
