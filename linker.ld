OUTPUT_FORMAT(elf64-x86-64)
OUTPUT_ARCH(i386:x86-64)
ENTRY(kernel_main)


SECTIONS
{
	. = 0xffffffff80000000;
	
	.text : {
		text_start_addr = .
		*(.text .text.*)
		text_end_addr = .
	}
	
	. = ALIGN(4096);

	.rodata : {
		rodata_end_addr = .
		*(.rodata .rodata.*)
		rodata_end_addr = .
	}

	. = ALIGN(4096);

	.data : {
		data_end_addr = .
		*(.data .data.*)
		data_end_addr = .
	}

	. = ALIGN(4096);

        limine_requests : {
                KEEP(*(.limine_requests))
        }

	. = ALIGN(4096);

	.bss : {
		bss_end_addr = .
		*(COMMON)
		*(.bss .bss.*)
		bss_end_addr = .
	}
}
