#!/bin/bash

set -e

echo "Compiling..."
x86_64-elf-gcc -I./src -c src/kernel.c -o kernel.o -g -std=c11 -ffreestanding -O2 -Wall -Wextra -mno-red-zone -mcmodel=kernel -mgeneral-regs-only

x86_64-elf-gcc -I./src -c src/idt.c -o idt.o -g -std=c11 -ffreestanding -O2 -Wall -Wextra -mno-red-zone -mcmodel=kernel -mgeneral-regs-only -mno-80387 -mno-mmx -mno-sse -mno-sse2

x86_64-elf-gcc -I./src -c src/pic.c -o pic.o -g -std=c11 -ffreestanding -O2 -Wall -Wextra -mno-red-zone -mcmodel=kernel -mgeneral-regs-only

x86_64-elf-gcc -I./src -c src/kprint.c -o kprint.o -g -std=c11 -ffreestanding -O2 -Wall -Wextra -mno-red-zone -mcmodel=kernel -mgeneral-regs-only

x86_64-elf-gcc -I./src -c src/pmm.c -o pmm.o -g -std=c11 -ffreestanding -O2 -Wall -Wextra -mno-red-zone -mcmodel=kernel -mgeneral-regs-only

x86_64-elf-gcc -I./src -c src/string.c -o string.o -g -std=c11 -ffreestanding -O2 -Wall -Wextra -mno-red-zone -mcmodel=kernel -mgeneral-regs-only

x86_64-elf-gcc -I./src -c src/vmm.c -o vmm.o -g -std=c11 -ffreestanding -O2 -Wall -Wextra -mno-red-zone -mcmodel=kernel -mgeneral-regs-only

x86_64-elf-objcopy -O elf64-x86-64 -I binary src/font.psf font.o

echo "Linking..."
x86_64-elf-gcc -T linker.ld -o kernel.elf kernel.o idt.o pic.o vmm.o pmm.o kprint.o string.o font.o -ffreestanding -O2 -nostdlib -lgcc

echo "Generating assembly dump..."
x86_64-elf-objdump -S kernel.elf > kernel.asm

echo "Preparing ISO directory..."
# Create a staging folder for the CD contents
mkdir -p iso_root/EFI/BOOT

# Copy your kernel and config to the root of the CD
cp kernel.elf iso_root/
cp limine.conf iso_root/

# Copy Limine's bootloader binaries to the CD
cp limine/limine-bios.sys limine/limine-bios-cd.bin limine/limine-uefi-cd.bin iso_root/
cp limine/BOOTX64.EFI iso_root/EFI/BOOT/
cp limine/BOOTIA32.EFI iso_root/EFI/BOOT/

echo "Building ISO..."
# Use xorriso to pack the staging folder into a bootable ISO
xorriso -as mkisofs -b limine-bios-cd.bin \
	-no-emul-boot -boot-load-size 4 -boot-info-table \
	--efi-boot limine-uefi-cd.bin \
	-efi-boot-part --efi-boot-image --protective-msdos-label \
	iso_root -o myos.iso

echo "Build complete! ISO generated at myos.iso"
