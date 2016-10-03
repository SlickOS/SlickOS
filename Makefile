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
# Set the default target
.PHONY: all
all: x86_64-BootHDD

.PHONY: clean
clean:
	@rm -rf Build

.PHONY: rebuild
rebuild: clean all

# Remove built-in makefile rules & targets, as they may mess up building since
# we are not using the system toolchain.
MAKEFILE += --no-builtin-rules
.SUFFIXES:

CC := clang
CXX := clang++
AS_x86_64 := as
AS_i386 := as
AS_i8086 := as
LD := lld

###############################################################################
# Targets                                                                     #
###############################################################################
define __ARCH_RULES
Build/Arch-Objects/$1/$2/%.o: Modules/$1/Arch/$2/Source/%.c Makefile
	@echo "    Compiling $$(<F)   ->   $$(@F)"
	@mkdir -p $$(@D)
	@$$(CC) -target $2-elf $$($1_CPPFLAGS) $$($1_CFLAGS) -MMD -MP -MT Build/Arch-Dependencies/$1/$2/$$*.d -c -o $$@ $$<

Build/Arch-Objects/$1/$2/%.o: Modules/$1/Arch/$2/Source/%.cpp Makefile
	@echo "    Compiling $$(<F)   ->   $$(@F)"
	@mkdir -p $$(@D)
	@$$(CXX) -target $2-elf $$($1_CPPFLAGS) $$($1_CXXFLAGS) -MMD -MP -MT Build/Arch-Dependencies/$1/$2/$$*.d -c -o $$@ $$<

Build/Arch-Objects/$1/$2/%.o: Modules/$1/Arch/$2/Source/%.asm Makefile
	@echo "    Compiling $$(<F)   ->   $$(@F)"
	@mkdir -p $$(@D)
	@$$(AS_$2) $$($1_ASFLAGS) -o $$@ $$<
endef

define __RULES
Build/Objects/$1/$2/%.o: Modules/$1/Source/%.c Makefile
	@echo "    Compiling $$(<F)   ->   $$(@F)"
	@mkdir -p $$(@D)
	@$$(CC) -target $2-elf $$($1_CPPFLAGS) $$($1_CFLAGS) -MMD -MP -MT Build/Dependencies/$1/$$*.d -c -o $$@ $$<

Build/Objects/$1/$2/%.o: Modules/$1/Source/%.cpp Makefile
	@echo "    Compiling $$(<F)   ->   $$(@F)"
	@mkdir -p $$(@D)
	@$$(CXX) -target $2-elf $$($1_CPPFLAGS) $$($1_CXXFLAGS) -MMD -MP -MT Build/Dependencies/$1/$$*.d -c -o $$@ $$<

Build/Binaries/$2/$1.sys: $$($1_OBJINIT) $$($1_OBJC) $$($1_OBJCXX) $$($1_OBJASM)
	@echo "    Linking $$(@F)"
	@mkdir -p $$(@D)
	@$$(CC) -target $2-elf $$($1_LDFLAGS) -o $$@ -T Modules/$1/Link.ld $$^

Build/Binaries/$2-$1.sys: Build/Binaries/$2/$1.sys
	@cp $$^ $$@
endef

define __ARCH_FILES
$1_OBJC += $$(addprefix Build/Arch-Objects/$1/$2/,$$(patsubst %.c,%.o,$$(shell find -L Modules/$1/Arch/$2/Source -type f -name '*.c' | sed 's/Modules\/$1\/Arch\/$2\/Source\///g')))
$1_OBJCXX += $$(addprefix Build/Arch-Objects/$1/$2/,$$(patsubst %.cpp,%.o,$$(shell find -L Modules/$1/Arch/$2/Source -type f -name '*.cpp' | sed 's/Modules\/$1\/Arch\/$2\/Source\///g')))
$1_OBJASM += $$(addprefix Build/Arch-Objects/$1/$2/,$$(patsubst %.asm,%.o,$$(shell find -L Modules/$1/Arch/$2/Source -type f -name '*.asm' | sed 's/Modules\/$1\/Arch\/$2\/Source\///g')))

$1_DEPC += $$(addprefix Build/Arch-Dependencies/$1/$2/,$$(patsubst %.c,%.d,$$(shell find -L Modules/$1/Arch/$2/Source -type f -name '*.c' | sed 's/Modules\/$1\/Arch\/$2\/Source\///g')))
$1_DEPCXX += $$(addprefix Build/Arch-Dependencies/$1/$2/,$$(patsubst %.cpp,%.d,$$(shell find -L Modules/$1/Arch/$2/Source -type f -name '*.cpp' | sed 's/Modules\/$1\/Arch\/$2\/Source\///g')))
$1_INCASM := $$(shell find -L Modules/$1/Arch/$2/Source -type f -name '*.inc')
endef

define __FILES
$1_OBJC := $$(addprefix Build/Objects/$1/,$$(patsubst %.c,%.o,$$(shell find -L Modules/$1/Source -type f -name '*.c' | sed 's/Modules\/$1\/Source\///g')))
$1_OBJCXX := $$(addprefix Build/Objects/$1/,$$(patsubst %.cpp,%.o,$$(shell find -L Modules/$1/Source -type f -name '*.cpp' | sed 's/Modules\/$1\/Source\///g')))

$1_DEPC := $$(addprefix Build/Dependencies/$1/,$$(patsubst %.c,%.d,$$(shell find -L Modules/$1/Source -type f -name '*.c' | sed 's/Modules\/$1\/Source\///g')))
$1_DEPCXX := $$(addprefix Build/Dependencies/$1/,$$(patsubst %.cpp,%.d,$$(shell find -L Modules/$1/Source -type f -name '*.cpp' | sed 's/Modules\/$1\/Source\///g')))
endef

define __DEPENDENCIES
$$(eval -include $$($1_DEPC))
$$(eval -include $$($1_DEPCXX))
endef

define __PROJECT
include Modules/$1/Build.mk
$$(eval $$(call __FILES,$1,$$(firstword $2)))
$$(foreach arch,$2,$$(eval $$(call __ARCH_FILES,$1,$$(arch))))
$$(eval $$(call __DEPENDENCIES,$1,$$(firstword $2)))
$$(foreach arch,$2,$$(eval $$(call __ARCH_RULES,$1,$$(arch))))
$$(eval $$(call __RULES,$1,$$(firstword $2)))

.PHONY: $$(firstword $2)-$1
$$(firstword $2)-$1: Build/Binaries/$$(firstword $2)-$1.sys
endef

$(eval $(call __PROJECT,BootHDD,x86_64 i386 i8086))
$(eval $(call __PROJECT,Gloss,x86_64 i386 i8086))

###############################################################################
# SlickOS Hard Disk Image                                                     #
###############################################################################
.PHONY: ImageHDD
ImageHDD: Build/Images/SlickOS.raw

Build/Images/SlickOS.raw: Build/Binaries/x86_64/BootHDD.sys
	@echo "Building Boot Image (Hard Disk)"
	@mkdir -p $(@D) Build/Structure/HDD
	@dd if=/dev/zero of=$@ bs=512 count=204800 status=none
	@dd if=$< of=$@ conv=notrunc bs=512 count=128 status=none
	@sleep .1

###############################################################################
# SlickOS Floppy Disk Image                                                   #
###############################################################################
.PHONY: ImageFDD
ImageFDD: Build/Images/SlickOS.img

Build/Images/SlickOS.img: Build/Binaries/BootFDD.sys Build/Binaries/Gloss.sys
	echo "Building Boot Image (Floppy Disk)"
	mkdir -p $(@D) Build/Structure/FDD
	dd if=/dev/zero of=$@ bs=512 count=2880 status=none
	mkfs.msdos -F 12 $@ > /dev/null
	dd if=$< of=$@ conv=notrunc bs=512 count=1 status=none
	sudo mount -t msdos -o loop,fat=12 $@ Build/Structure/FDD
	sudo cp $^ Build/Structure/FDD
	sudo umount Build/Structure/FDD

###############################################################################
# SlickOS Compact Disk Image                                                   #
###############################################################################
.PHONY: ImageISO
ImageISO: Build/Binaries/ImageISO.sys Build/Binaries/Gloss.sys
	@echo "Building Boot Image (Compact Disk)"
	@mkdir -p $(@D) Build/Structure/ISO
	@dd if=/dev/zero of=$@ bs=512 count=2880 status=none
	@mkfs.msdos -F 12 $@ > /dev/null
	@dd if=$< of=$@ conv=notrunc bs=512 count=1 status=none
	@sudo mount -t msdos -o loop,fat=12 $@ Build/Structure/FD
	@sudo cp $^ Build/Structure/ISO
	@sudo umount Build/Structure/ISO

# all: $(PROJECTS) image
# 	@echo "Finished Building!"

run: ImageHDD
	@qemu-system-x86_64 -hda Build/Images/SlickOS.raw -boot c -m 2G
# #	@/opt/local/util/bin/bochs 'cpu: ips=100000000' 'boot:floppy' 'clock: sync=realtime, time0=utc' 'floppya: 1_44=Build/SlickOS.img, status=inserted' 'magic_break: enabled=1' #'romimage: file=/opt/local/util/share/bochs/bios.bin-1.7.5, address=0xfffc0000' 'vgaromimage: file=/opt/local/util/share/bochs/VGABIOS-lgpl-latest'
# #	/opt/local/util/bin/bochs
# #	bochs

# run-hdd: all
# 	@qemu-system-x86_64 -hda Build/SlickOS.raw -boot c -m 2G
