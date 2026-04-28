#ifndef BOOT_H
#define BOOT_H

#include "limine.h"

extern volatile struct limine_memmap_request memmap_request;
extern volatile struct limine_hhdm_request hhdm_request;
extern volatile struct limine_executable_address_request executable_address_request;

#endif
