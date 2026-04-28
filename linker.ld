OUTPUT_FORMAT(elf64-x86-64)
OUTPUT_ARCH(i386:x86-64)
ENTRY(kernel_main)


SECTIONS
{
	. = 0xffffffff80000000;
	
	.text : {
		*(.text .text.*)
	}
	
	. = ALIGN(4096);

	.rodata : {
		*(.rodata .rodata.*)
	}

	. = ALIGN(4096);

	.data : {
		*(.data .data.*)
	}

	. = ALIGN(4096);

        .limine_requests : {
                KEEP(*(.limine_requests))
        }

	. = ALIGN(4096);

	.bss : {
		*(COMMON)
		*(.bss .bss.*)
	}
}
