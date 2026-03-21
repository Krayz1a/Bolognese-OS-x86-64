#!/bin/bash

qemu-system-x86_64 -m 2G -cdrom myos.iso -serial stdio -no-reboot
