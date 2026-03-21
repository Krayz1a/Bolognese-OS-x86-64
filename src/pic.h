#ifndef PIC_H
#define PIC_H

#include <stdint.h>

// Remap the PIC so IRQs 0-15 map to IDT vectors 32-47
void pic_remap(int offset1, int offset2);

// Tell the PIC we have finished handling the current interrupt
void pic_send_eoi(unsigned char irq);

#endif
