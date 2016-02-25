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

PROJECTS := Gloss Gloss-BootSector.FD

.PHONY: all clean rebuild image run
all:

MAKEFILE += --no-builtin-rules
.SUFFIXES:

BINARIES := Build/Binaries/Gloss-BootSector.FD/BOOTSECT.BIN Build/Binaries/Gloss/GLOSS.SYS

all: $(PROJECTS)

clean:
	@rm -rf $(addsuffix /Build,$(PROJECTS))

rebuild: clean all

image: Build/SlickOS.img

Build/SlickOS.img: Build/Binaries/Gloss/BOOTSECT.BIN
	@mkdir -p $(@D)
	@mkdir -p Build/Structure/FD
	@dd if=/dev/zero of=$@ bs=512 count=2880
	@mkfs.msdos -F 12 $@
	@dd if=$< of=$@ conv=notrunc bs=512 count=1
	@sudo mount -t msdos -o loop,fat=12 $@ Build/Structure/FD
	@sudo cp $(BINARIES) Build/Structure/FD
	@sudo umount Build/Structure/FD

.PHONY: Gloss-BootSect.FD
Gloss-BootSect.FD:
	cd Gloss-BootSect.FD && $(MAKE)
	cd ..
	cp Gloss-BootSect.FD/Build/BOOTSECT.BIN Build/Gloss-BootSect.FD/Binaries/BOOTSECT.BIN

.PHONY: Gloss
Gloss:
	cd Gloss && $(MAKE)
	cd ..
	cp Gloss/Build/GLOSS.SYS Build/Gloss/Binaries/GLOSS.SYS