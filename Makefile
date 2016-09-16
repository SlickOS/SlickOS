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
all: BootHDD

# Remove built-in makefile rules & targets, as they may mess up building since
# we are not using the system toolchain.
MAKEFILE += --no-builtin-rules
.SUFFIXES:

###############################################################################
# Variables                                                                   #
###############################################################################
# vpath
# vpath %.c
# vpath %.cpp
# vpath %.asm

# OBJ_C :=
# OBJ_CXX :=
# OBJ_ASM :=

# DEP_C :=
# DEP_CXX :=
# DEP_ASM :=

# IMAGES :=
# BINARIES :=

###############################################################################
# Build Projects                                                              #
###############################################################################
# Build the Main Bootloader Module.
# BINGLOSS := Build/Binary/Gloss/Gloss.sys
# BINARIES += $(BINGLOSS)
# $(BINGLOSS): OBJ_C := $(addprefix Build/Objects/Gloss/Gloss/,$(patsubst %.c,%.o,$(shell find -L Gloss/Gloss/Source -type f -name '*.c' | sed 's/Gloss\/Gloss\/Source\///g')))
# $(BINGLOSS): OBJ_CXX := $(addprefix Build/Objects/Gloss/Gloss/,$(patsubst %.cpp,%.o,$(shell find -L Gloss/Gloss/Source -type f -name '*.cpp' | sed 's/Gloss\/Gloss\/Source\///g')))
# $(BINGLOSS): OBJ_ASM := $(addprefix Build/Objects/Gloss/Gloss/,$(patsubst %.asm,%.o,$(shell find -L Gloss/Gloss/Source -type f -name '*.asm' | sed 's/Gloss\/Gloss\/Source\///g')))
# $(BINGLOSS): $(OBJ_C) $(OBJ_CXX) $(OBJ_ASM)
# 	@echo "    Linking $(@F)"
# 	@mkdir -p $(@D)
# 	@$(CC) $(LDFLAGS) -o $@ -T Link.ld $^

# # Build the Floppy Disk Boot Sector.
# BINFLOPPY := Build/Binary/Gloss/Floppy.sys
# BINARIES += $(BINFLOPPY)
# $(BINFLOPPY): OBJ_C := $(addprefix Build/Objects/Gloss/Floppy/,$(patsubst %.c,%.o,$(shell find -L Gloss/Boot/Floppy/Source -type f -name '*.c' | sed 's/Gloss\/Boot\/Floppy\/Source\///g')))
# $(BINFLOPPY): OBJ_CXX := $(addprefix Build/Objects/Gloss/Floppy/,$(patsubst %.cpp,%.o,$(shell find -L Gloss/Boot/Floppy/Source -type f -name '*.cpp' | sed 's/Gloss\/Boot\/Floppy\/Source\///g')))
# $(BINFLOPPY): OBJ_ASM := $(addprefix Build/Objects/Gloss/Floppy/,$(patsubst %.asm,%.o,$(shell find -L Gloss/Boot/Floppy/Source -type f -name '*.asm' | sed 's/Gloss\/Boot\/Floppy\/Source\///g')))
# $(BINFLOPPY): $(OBJ_C) $(OBJ_CXX) $(OBJ_ASM)
# 	@echo "    Linking $(@F)"
# 	@mkdir -p $(@D)
# 	@$(CC) $(LDFLAGS) -o $@ -T Link.ld $^

# # Build the Hard Disk Boot Sector.
# BINHARDDISK := Build/Binary/Gloss/HardDisk.sys
# BINARIES += $(BINHARDDISK)
# $(BINHARDDISK): OBJ_C := $(addprefix Build/Objects/Gloss/HardDisk/,$(patsubst %.c,%.o,$(shell find -L Gloss/Boot/HardDisk/Source -type f -name '*.c' | sed 's/Gloss\/Boot\/HardDisk\/Source\///g')))
# $(BINHARDDISK): OBJ_CXX := $(addprefix Build/Objects/Gloss/HardDisk/,$(patsubst %.cpp,%.o,$(shell find -L Gloss/Boot/HardDisk/Source -type f -name '*.cpp' | sed 's/Gloss\/Boot\/HardDisk\/Source\///g')))
# $(BINHARDDISK): OBJ_ASM := $(addprefix Build/Objects/Gloss/HardDisk/,$(patsubst %.asm,%.o,$(shell find -L Gloss/Boot/HardDisk/Source -type f -name '*.asm' | sed 's/Gloss\/Boot\/HardDisk\/Source\///g')))
# $(BINHARDDISK): $(OBJ_C) $(OBJ_CXX) $(OBJ_ASM)
# 	@echo "    Linking $(@F)"
# 	@mkdir -p $(@D)
# 	@$(CC) $(LDFLAGS) -o $@ -T Link.ld $^

# Build the CD Boot Sector.
# BINELTORITO := Build/Binary/Gloss/ElTorito.sys
# BINARIES += $(BINELTORITO)
# $(BINELTORITO): OBJ_C := $(addprefix Build/Objects/,$(patsubst %.c,%.o,$(shell find -L Gloss/Boot/ElTorito/Source -type f -name '*.c' | sed 's/Gloss\/Boot\/ElTorito\/Source\///g')))
# $(BINELTORITO): OBJ_CXX := $(addprefix Build/Objects/,$(patsubst %.cpp,%.o,$(shell find -L Gloss/Boot/ElTorito/Source -type f -name '*.cpp' | sed 's/Gloss\/Boot\/ElTorito\/Source\///g')))
# $(BINELTORITO): OBJ_ASM := $(addprefix Build/Objects/,$(patsubst %.asm,%.o,$(shell find -L Gloss/Boot/ElTorito/Source -type f -name '*.asm' | sed 's/Gloss\/Boot\/ElTorito\/Source\///g')))
# $(BINELTORITO): $(OBJ_C) $(OBJ_CXX) $(OBJ_ASM)

# Build the Kernel.
# BINKERNEL := Build/Binary/Slick/Slick.sys
# BINARIES += $(BINKERNEL)
# $(BINKERNEL): OBJ_C := $(addprefix Build/Objects/,$(patsubst %.c,%.o,$(shell find -L Kernel/Source -type f -name '*.c' | sed 's/Kernel\/Source\///g')))
# $(BINKERNEL): OBJ_CXX := $(addprefix Build/Objects/,$(patsubst %.cpp,%.o,$(shell find -L Kernel/Source -type f -name '*.cpp' | sed 's/Kernel\/Source\///g')))
# $(BINKERNEL): OBJ_ASM := $(addprefix Build/Objects/,$(patsubst %.asm,%.o,$(shell find -L Kernel/Source -type f -name '*.asm' | sed 's/Kernel\/Source\///g')))
# $(BINKERNEL): $(OBJ_C) $(OBJ_CXX) $(OBJ_ASM)

###############################################################################
# Build Images                                                                #
###############################################################################
# Build a Floppy Disk Image.
# IMAGES += Build/SlickOS.img
# Build/SlickOS.img:

# # Build a Hard Disk Image.
# IMAGES += Build/SlickOS.raw
# Build/SlickOS.raw:

# # Build a CD Image.
# IMAGES += Build/SlickOS.iso
# Build/SlickOS.iso:

###############################################################################
# Main Targets                                                                #
###############################################################################
# .PHONY: all
# all: $(BINARIES)

# .PHONY: clean
# clean:
# 	@rm -rf $(addsuffix /Build,$(PROJECTS))

# .PHONY: rebuild
# rebuild: clean all

# .PHONY: image
# image: $(IMAGES)

.PHONY: toolchain
toolchain:
	rm -rf Tools/
	bash Scripts/toolchain.sh

###############################################################################
# Rules                                                                       #
###############################################################################
# Build/Objects/%.o: %.c Makefile
# 	@echo "    Compiling $(<F)   ->   $(@F)"
# 	@mkdir -p $(@D)
# 	@$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<
# Build/Objects/%.o: %.cpp Makefile
# 	@echo "    Compiling $(<F)   ->   $(@F)"
# 	@mkdir -p $(@D)
# 	@$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<
# Build/Objects/%.o: %.asm Makefile
# 	@echo "    Compiling $(<F)   ->   $(@F)"
# 	@mkdir -p $(@D)
# 	@$(AS) $(ASFLAGS) -o $@ $<

###############################################################################
# Build A Project                                                             #
###############################################################################

define ClearVariables
SRC_C :=
SRC_CXX :=
SRC_ASM :=
OBJ_C :=
OBJ_CXX :=
OBJ_ASM :=
DEP_C :=
DEP_CXX :=
endef

define DefineLink
Build/Binaries/$(1): $$(OBJ_C) $$(OBJ_CXX) $$(OBJ_C_$(2)) $$(OBJ_CXX_$(2)) $$(OBJ_ASM_$(2))
	@echo "    Linking $$(@F)"
	@mkdir -p $$(@D)
	@Tools/bin/$(2)-elf-$$(CC) $$(LDFLAGS) -o $$@ -T Modules/$(1)/Link.ld $$^
endef

# 1.) Project Name
# 2.) Architecture
define DefineRulesArch
Build/$(1)/Arch/$(2)/%.o: Modules/$(1)/Arch/$(2)/Source/%.c
	@echo "    Compiling $$(<F)   ->   $$(@F)"
	@mkdir -p $$(@D)
	@Tools/bin/$(2)-elf-$$(CC) $$(CPPFLAGS) $$(CFLAGS) -c -o $$@ $$<
Build/$(1)/Arch/$(2)/%.o: Modules/$(1)/Arch/$(2)/Source/%.cpp
	@echo "    Compiling $$(<F)   ->   $$(@F)"
	@mkdir -p $$(@D)
	@Tools/bin/$(2)-elf-$$(CXX) $$(CPPFLAGS) $$(CXXFLAGS) -c -o $$@ $$<
Build/$(1)/Arch/$(2)/%.o: Modules/$(1)/Arch/$(2)/Source/%.asm
	@echo "    Compiling $$(<F)   ->   $$(@F)"
	@mkdir -p $$(@D)
	@Tools/bin/$(2)-elf-$$(AS) $$(ASFLAGS) -c -o $$@ $$<
endef

# 1.) Project Name
define DefineRules
Build/$(1)/%.o: Modules/$(1)/Source/%.c
	@echo "    Compiling $$(<F)   ->   $$(@F)"
	@mkdir -p $$(@D)
	@Tools/bin/$$(CC) $$(CPPFLAGS) $$(CFLAGS) -c -o $$@ $$<
Build/$(1)/%.o: Modules/$(1)/Source/%.cpp
	@echo "    Compiling $$(<F)   ->   $$(@F)"
	@mkdir -p $$(@D)
	@Tools/bin/$$(CXX) $$(CPPFLAGS) $$(CFLAGS) -c -o $$@ $$<
endef

# 1.) Project Name
# 2.) Architecture
define DefineSourcesArch
SRC_C_$(2) += $$(shell if [ -d "Modules/$(1)/Arch/$(2)/Source" ]; then find -L Modules/$(1)/Arch/$(2)/Source -type f -name '*.c'; fi)
SRC_CXX_$(2) += $$(shell if [ -d "Modules/$(1)/Arch/$(2)/Source" ]; then find -L Modules/$(1)/Arch/$(2)/Source -type f -name '*.cpp'; fi)
SRC_ASM_$(2) += $$(shell if [ -d "Modules/$(1)/Arch/$(2)/Source" ]; then find -L Modules/$(1)/Arch/$(2)/Source -type f -name '*.asm'; fi)
endef

# 1.) Project Name
# 2.) Architecture
define DefineObjectsArch
OBJ_C_$(2) += $$(patsubst %.c,%.o,$$(shell echo $$(SRC_C_$(2)) | sed 's/Modules\/$(1)\/Arch\/$(2)\/Source\//Build\/$(1)\/Arch\/$(2)\//g'))
OBJ_CXX_$(2) += $$(patsubst %.cpp,%.o,$$(shell echo $$(SRC_CXX_$(2)) | sed 's/Modules\/$(1)\/Arch\/$(2)\/Source\//Build\/$(1)\/Arch\/$(2)\//g'))
OBJ_ASM_$(2) += $$(patsubst %.asm,%.o,$$(shell echo $$(SRC_ASM_$(2)) | sed 's/Modules\/$(1)\/Arch\/$(2)\/Source\//Build\/$(1)\/Arch\/$(2)\//g'))
endef

# 1.) Project Name
define DefineSources
SRC_C += $$(shell if [ -d "Modules/$(1)/Source" ]; then find -L Modules/$(1)/Source -type f -name '*.c'; fi)
SRC_CXX += $$(shell if [ -d "Modules/$(1)/Source" ]; then find -L Modules/$(1)/Source -type f -name '*.cpp'; fi)
endef

# 1.) Project Name
define DefineObjects
OBJ_C += $$(patsubst %.c,%.o,$$(shell echo $$(SRC_C) | sed 's/Modules\/$(1)\/Source\//Build\/$(1)\//g'))
OBJ_CXX += $$(patsubst %.cpp,%.o,$$(shell echo $$(SRC_CXX) | sed 's/Modules\/$(1)\/Source\//Build\/$(1)\//g'))
endef

# 1.) Project Name
# 2.) Architecture
define DefineModuleArch
$$(info $(1) ($(2)))
$$(eval $$(call DefineSources,$(1)))
$$(eval $$(call DefineObjects,$(1)))
$$(eval $$(call DefineSourcesArch,$(1),$(2)))
$$(eval $$(call DefineObjectsArch,$(1),$(2)))
$$(eval $$(call DefineRules,$(1)))
$$(eval $$(call DefineRulesArch,$(1),$(2)))
$$(eval $$(call DefineLink,$(1),$(2)))

# $$(info - SRC_C- $$(SRC_C))
# $$(info - SRC_CXX- $$(SRC_CXX))
# $$(info - SRC_C_$(2)- $$(SRC_C_$(2)))
# $$(info - SRC_CXX_$(2)- $$(SRC_CXX_$(2)))
# $$(info - SRC_ASM_$(2)- $$(SRC_ASM_$(2)))

# $$(info - OBJ_C- $$(OBJ_C))
# $$(info - OBJ_CXX- $$(OBJ_CXX))
# $$(info - OBJ_C_$(2)- $$(OBJ_C_$(2)))
# $$(info - OBJ_CXX_$(2)- $$(OBJ_CXX_$(2)))
# $$(info - OBJ_ASM_$(2)- $$(OBJ_ASM_$(2)))
endef

# 1.) Project Name
# 2.) Project Directory
define DefineModule
include Modules/$(1)/Project.mk
$$(foreach target,$$(TARGETS), $$(eval $$(call DefineModuleArch,$(1),$$(target))))
.PHONY: $(1)
$(1): Build/Binaries/$(1)
endef

$(eval $(call DefineModule,BootHDD))
# $(eval $(call DefineModule,Gloss))


# .PHONY: all run
# all:

# # Remove built-in makefile rules & targets, as they may mess up building
# # since we are not using the system compiler.
# MAKEFILE += --no-builtin-rules
# .SUFFIXES:

# # This lists all of the subprojects of Slick OS
# PROJECTS := Gloss GlossBoot.Floppy GlossBoot.HardDisk

# # This lists the disk images to make
# IMAGE := Build/SlickOS.img Build/SlickOS.raw

# # This lists the binaries to build
# BINARIES := Build/Binaries/Gloss/GLOSS.SYS

# all: $(PROJECTS) image
# 	@echo "Finished Building!"

# .PHONY: clean
# clean:
# 	@rm -rf $(addsuffix /Build,$(PROJECTS))

# .PHONY: rebuild
# rebuild: clean all

# .PHONY: image
# image: $(IMAGE)

# Build/SlickOS.img: Build/Binaries/Gloss-BootSector.FD/BOOTSECT.BIN
# 	@echo "Building Boot Image (Floppy Disk)"
# 	@mkdir -p $(@D)
# 	@mkdir -p Build/Structure/FD
# 	@dd if=/dev/zero of=$@ bs=512 count=2880 status=none
# 	@mkfs.msdos -F 12 $@ > /dev/null
# 	@dd if=$< of=$@ conv=notrunc bs=512 count=1 status=none
# 	@sudo mount -t msdos -o loop,fat=12 $@ Build/Structure/FD
# 	@sudo cp $(BINARIES) Build/Structure/FD
# 	@sleep .1
# 	@sudo umount Build/Structure/FD

# Build/SlickOS.raw: Build/Binaries/Gloss-BootSector.HD/BOOTSECT.BIN
# 	@echo "Building Boot Image (Hard Disk)"
# 	@mkdir -p $(@D)
# 	@mkdir -p Build/Structure/HD
# 	@dd if=/dev/zero of=$@ bs=512 count=204800 status=none
# 	@dd if=$< of=$@ conv=notrunc bs=512 count=128 status=none
# 	@sleep .1

# run: all
# 	@qemu-system-x86_64 -fda Build/SlickOS.img -boot a -m 2G
# #	@/opt/local/util/bin/bochs 'cpu: ips=100000000' 'boot:floppy' 'clock: sync=realtime, time0=utc' 'floppya: 1_44=Build/SlickOS.img, status=inserted' 'magic_break: enabled=1' #'romimage: file=/opt/local/util/share/bochs/bios.bin-1.7.5, address=0xfffc0000' 'vgaromimage: file=/opt/local/util/share/bochs/VGABIOS-lgpl-latest'
# #	/opt/local/util/bin/bochs
# #	bochs

# run-hdd: all
# 	@qemu-system-x86_64 -hda Build/SlickOS.raw -boot c -m 2G

# .PHONY: Gloss-BootSector.FD
# Gloss-BootSector.FD:
# 	@echo "Project: Gloss-BootSector.FD"
# 	@cd Gloss-BootSector.FD && $(MAKE) --no-print-directory
# 	@cd ..
# 	@mkdir -p Build/Binaries/Gloss-BootSector.FD
# 	@cp Gloss-BootSector.FD/Build/BOOTSECT.BIN Build/Binaries/Gloss-BootSector.FD/BOOTSECT.BIN

# .PHONY: Gloss
# Gloss:
# 	@echo "Project: Gloss"
# 	@cd Gloss && $(MAKE) --no-print-directory
# 	@cd ..
# 	@mkdir -p Build/Binaries/Gloss
# 	@cp Gloss/Build/GLOSS.SYS Build/Binaries/Gloss/GLOSS.SYS

# .PHONY: Gloss-BootSector.HD
# Gloss-BootSector.HD:
# 	@echo "Project: Gloss-BootSector.HD"
# 	@cd Gloss-BootSector.HD && $(MAKE) --no-print-directory
# 	@cd ..
# 	@mkdir -p Build/Binaries/Gloss-BootSector.HD
# 	@cp Gloss-BootSector.HD/Build/BOOTSECT.BIN Build/Binaries/Gloss-BootSector.HD/BOOTSECT.BIN
