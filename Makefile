###############################################################################
# Generic Loader for Operating System Software (GLOSS)                        #
# Makefile                                                                    #
#                                                                             #
# Copyright 2015-2016 - Adrian J. Collado           <acollado@polaritech.com> #
# All Rights Reserved                                                         #
#                                                                             #
# This file is licensed under the MIT license, see the LICENSE file in the    #
# root of this project for more information. If this file was not distributed #
# with the source of this project, see http://choosealicense.com/licenses/mit #
###############################################################################

.PHONY: all clean rebuild image run
all:

PROJECTS := Gloss Gloss-BootSector.FD Gloss-BootSector.HD

MAKEFILE += --no-builtin-rules
.SUFFIXES:

IMAGE := Build/SlickOS.raw Build/SlickOS.img

BINARIES := Build/Binaries/Gloss/GLOSS.SYS

all: $(PROJECTS) image
	@echo "Finished Building!"

clean:
	@rm -rf $(addsuffix /Build,$(PROJECTS))

rebuild: clean all

image: $(IMAGE)

Build/SlickOS.img: Build/Binaries/Gloss-BootSector.FD/BOOTSECT.BIN
	@echo "Building Boot Image (Floppy Disk)"
	@mkdir -p $(@D)
	@mkdir -p Build/Structure/FD
	@dd if=/dev/zero of=$@ bs=512 count=2880 status=none
	@mkfs.msdos -F 12 $@ > /dev/null
	@dd if=$< of=$@ conv=notrunc bs=512 count=1 status=none
	@sudo mount -t msdos -o loop,fat=12 $@ Build/Structure/FD
	@sudo cp $(BINARIES) Build/Structure/FD
	@sleep .1
	@sudo umount Build/Structure/FD

Build/SlickOS.raw: Build/Binaries/Gloss-BootSector.HD/BOOTSECT.BIN
	@echo "Building Boot Image (Hard Disk)"
	@mkdir -p $(@D)
	@mkdir -p Build/Structure/HD
	@dd if=/dev/zero of=$@ bs=512 count=204800 status=none
	@dd if=$< of=$@ conv=notrunc bs=512 count=128 status=none
	@sleep .1

run: all
	@qemu-system-x86_64 -fda Build/SlickOS.img -boot a -m 2G
#	@/opt/local/util/bin/bochs 'cpu: ips=100000000' 'boot:floppy' 'clock: sync=realtime, time0=utc' 'floppya: 1_44=Build/SlickOS.img, status=inserted' 'magic_break: enabled=1' #'romimage: file=/opt/local/util/share/bochs/bios.bin-1.7.5, address=0xfffc0000' 'vgaromimage: file=/opt/local/util/share/bochs/VGABIOS-lgpl-latest'
#	/opt/local/util/bin/bochs
#	bochs

run-hdd: all
	@qemu-system-x86_64 -hda Build/SlickOS.raw -boot c -m 2G

.PHONY: Gloss-BootSector.FD
Gloss-BootSector.FD:
	@echo "Project: Gloss-BootSector.FD"
	@cd Gloss-BootSector.FD && $(MAKE) --no-print-directory
	@cd ..
	@mkdir -p Build/Binaries/Gloss-BootSector.FD
	@cp Gloss-BootSector.FD/Build/BOOTSECT.BIN Build/Binaries/Gloss-BootSector.FD/BOOTSECT.BIN

.PHONY: Gloss
Gloss:
	@echo "Project: Gloss"
	@cd Gloss && $(MAKE) --no-print-directory
	@cd ..
	@mkdir -p Build/Binaries/Gloss
	@cp Gloss/Build/GLOSS.SYS Build/Binaries/Gloss/GLOSS.SYS

.PHONY: Gloss-BootSector.HD
Gloss-BootSector.HD:
	@echo "Project: Gloss-BootSector.HD"
	@cd Gloss-BootSector.HD && $(MAKE) --no-print-directory
	@cd ..
	@mkdir -p Build/Binaries/Gloss-BootSector.HD
	@cp Gloss-BootSector.HD/Build/BOOTSECT.BIN Build/Binaries/Gloss-BootSector.HD/BOOTSECT.BIN
