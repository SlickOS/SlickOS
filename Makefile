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
all: ImageHDD

.PHONY: clean
clean:
	@rm -rf Build

.PHONY: rebuild
rebuild: clean all

# Remove built-in makefile rules & targets, as they may mess up building since
# we are not using the system toolchain.
MAKEFILE += --no-builtin-rules
.SUFFIXES:

CC := os-gcc
CXX := os-g++
AS := os-as
LD := os-gcc

###############################################################################
# BootHDD                                                                     #
###############################################################################
.PHONY: BootHDD
BootHDD: Build/Binaries/BootHDD.sys

BootHDD_OBJINIT := Build/Arch-Objects/x86_64/BootHDD/Init.o

BootHDD_CFLAGS :=
BootHDD_CXXFLAGS :=
BootHDD_CPPFLAGS :=
BootHDD_ASFLAGS := -I Modules/BootHDD/Arch/x86_64/Source
BootHDD_LDFLAGS := -ffreestanding -O2 -nostdlib -lgcc

BootHDD_OBJC := $(addprefix Build/Objects/BootHDD/,$(patsubst %.c,%.o,$(shell find -L Modules/BootHDD/Source -type f -name '*.c' | sed 's/Modules\/BootHDD\/Source\///g')))
BootHDD_OBJC += $(addprefix Build/Arch-Objects/x86_64/BootHDD/,$(patsubst %.c,%.o,$(shell find -L Modules/BootHDD/Arch/x86_64/Source -type f -name '*.c' | sed 's/Modules\/BootHDD\/Arch\/x86_64\/Source\///g')))
BootHDD_OBJCXX := $(addprefix Build/Objects/BootHDD/,$(patsubst %.cpp,%.o,$(shell find -L Modules/BootHDD/Source -type f -name '*.cpp' | sed 's/Modules\/BootHDD\/Source\///g')))
BootHDD_OBJCXX += $(addprefix Build/Arch-Objects/x86_64/BootHDD/,$(patsubst %.cpp,%.o,$(shell find -L Modules/BootHDD/Arch/x86_64/Source -type f -name '*.cpp' | sed 's/Modules\/BootHDD\/Arch\/x86_64\/Source\///g')))

BootHDD_OBJASM := $(addprefix Build/Arch-Objects/x86_64/BootHDD/,$(patsubst %.asm,%.o,$(shell find -L Modules/BootHDD/Arch/x86_64/Source -type f -name '*.asm' | sed 's/Modules\/BootHDD\/Arch\/x86_64\/Source\///g')))
BootHDD_INCASM := $(shell find -L Modules/BootHDD/Arch/x86_64/Source -type f -name '*.inc')

BootHDD_DEPC := $(addprefix Build/Dependencies/BootHDD/,$(patsubst %.c,%.d,$(shell find -L Modules/BootHDD/Source -type f -name '*.c' | sed 's/Modules\/BootHDD\/Source\///g')))
BootHDD_DEPC += $(addprefix Build/Arch-Dependencies/x86_64/BootHDD/,$(patsubst %.c,%.d,$(shell find -L Modules/BootHDD/Arch/x86_64/Source -type f -name '*.c' | sed 's/Modules\/BootHDD\/Arch\/x86_64\/Source\///g')))
BootHDD_DEPCXX := $(addprefix Build/Dependencies/BootHDD/,$(patsubst %.cpp,%.d,$(shell find -L Modules/BootHDD/Source -type f -name '*.cpp' | sed 's/Modules\/BootHDD\/Source\///g')))
BootHDD_DEPCXX += $(addprefix Build/Arch-Dependencies/x86_64/BootHDD/,$(patsubst %.cpp,%.d,$(shell find -L Modules/BootHDD/Arch/x86_64/Source -type f -name '*.cpp' | sed 's/Modules\/BootHDD\/Arch\/x86_64\/Source\///g')))

-include $(BootHDD_DEPC) $(BootHDD_DEPCXX)

Build/Objects/BootHDD/%.o: Modules/BootHDD/Source/%.c Makefile
	@echo "    Compiling $(<F)   ->   $(@F)"
	@mkdir -p $(@D)
	@$(CC) $(BootHDD_CPPFLAGS) $(BootHDD_CFLAGS) -MMD -MP -MT Build/Dependencies/BootHDD/$*.d -c -o $@ $<
Build/Arch-Objects/x86_64/BootHDD/%.o: Modules/BootHDD/Arch/x86_64/Source/%.c Makefile
	@echo "    Compiling $(<F)   ->   $(@F)"
	@mkdir -p $(@D)
	@$(CC) $(BootHDD_CPPFLAGS) $(BootHDD_CFLAGS) -MMD -MP -MT Build/Arch-Dependencies/x86_64/BootHDD/$*.d -c -o $@ $<

Build/Objects/BootHDD/%.o: Modules/BootHDD/Source/%.cpp Makefile
	@echo "    Compiling $(<F)   ->   $(@F)"
	@mkdir -p $(@D)
	@$(CXX) $(BootHDD_CPPFLAGS) $(BootHDD_CXXFLAGS) -MMD -MP -MT Build/Dependencies/BootHDD/$*.d -c -o $@ $<
Build/Arch-Objects/x86_64/BootHDD/%.o: Modules/BootHDD/Arch/x86_64/Source/%.cpp Makefile
	@echo "    Compiling $(<F)   ->   $(@F)"
	@mkdir -p $(@D)

Build/Arch-Objects/x86_64/BootHDD/%.o: Modules/BootHDD/Arch/x86_64/Source/%.asm Makefile $(BootHDD_INCASM)
	@echo "    Compiling $(<F)   ->   $(@F)"
	@mkdir -p $(@D)
	@$(AS) $(BootHDD_ASFLAGS) -o $@ $<

Build/Binaries/BootHDD.sys: $(BootHDD_OBJINIT) $(BootHDD_OBJC) $(BootHDD_OBJCXX) $(BootHDD_OBJASM)
	@echo "    Linking $(@F)"
	@mkdir -p $(@D)
	@$(CC) $(BootHDD_LDFLAGS) -o $@ -T Modules/BootHDD/Link.ld $^

###############################################################################
# BootFDD                                                                     #
###############################################################################
.PHONY: BootFDD
BootFDD: Build/Binaries/BootFDD.sys

BootFDD_CFLAGS :=
BootFDD_CXXFLAGS :=
BootFDD_CPPFLAGS :=
BootFDD_ASFLAGS := -I Modules/BootFDD/Arch/x86_64/Source
BootFDD_LDFLAGS := -ffreestanding -O2 -nostdlib -lgcc

BootFDD_OBJINIT := Build/Arch-Objects/x86_64/BootFDD/Init.o

BootFDD_OBJC := $(addprefix Build/Objects/BootFDD/,$(patsubst %.c,%.o,$(shell find -L Modules/BootFDD/Source -type f -name '*.c' | sed 's/Modules\/BootFDD\/Source\///g')))
BootFDD_OBJC += $(addprefix Build/Arch-Objects/x86_64/BootFDD/,$(patsubst %.c,%.o,$(shell find -L Modules/BootFDD/Arch/x86_64/Source -type f -name '*.c' | sed 's/Modules\/BootFDD\/Arch\/x86_64\/Source\///g')))
BootFDD_OBJCXX := $(addprefix Build/Objects/BootFDD/,$(patsubst %.cpp,%.o,$(shell find -L Modules/BootFDD/Source -type f -name '*.cpp' | sed 's/Modules\/BootFDD\/Source\///g')))
BootFDD_OBJCXX += $(addprefix Build/Arch-Objects/x86_64/BootFDD/,$(patsubst %.cpp,%.o,$(shell find -L Modules/BootFDD/Arch/x86_64/Source -type f -name '*.cpp' | sed 's/Modules\/BootFDD\/Arch\/x86_64\/Source\///g')))

BootFDD_OBJASM := $(addprefix Build/Arch-Objects/x86_64/BootFDD/,$(patsubst %.asm,%.o,$(shell find -L Modules/BootFDD/Arch/x86_64/Source -type f -name '*.asm' | sed 's/Modules\/BootFDD\/Arch\/x86_64\/Source\///g')))
BootFDD_INCASM := $(shell find -L Modules/BootFDD/Arch/x86_64/Source -type f -name '*.inc')

BootFDD_DEPC := $(addprefix Build/Dependencies/BootFDD/,$(patsubst %.c,%.d,$(shell find -L Modules/BootFDD/Source -type f -name '*.c' | sed 's/Modules\/BootFDD\/Source\///g')))
BootFDD_DEPC += $(addprefix Build/Arch-Dependencies/x86_64/BootFDD/,$(patsubst %.c,%.d,$(shell find -L Modules/BootFDD/Arch/x86_64/Source -type f -name '*.c' | sed 's/Modules\/BootFDD\/Arch\/x86_64\/Source\///g')))
BootFDD_DEPCXX := $(addprefix Build/Dependencies/BootFDD/,$(patsubst %.cpp,%.d,$(shell find -L Modules/BootFDD/Source -type f -name '*.cpp' | sed 's/Modules\/BootFDD\/Source\///g')))
BootFDD_DEPCXX += $(addprefix Build/Arch-Dependencies/x86_64/BootFDD/,$(patsubst %.cpp,%.d,$(shell find -L Modules/BootFDD/Arch/x86_64/Source -type f -name '*.cpp' | sed 's/Modules\/BootFDD\/Arch\/x86_64\/Source\///g')))

-include $(BootFDD_DEPC) $(BootFDD_DEPCXX)

Build/Objects/BootFDD/%.o: Modules/BootFDD/Source/%.c Makefile
	@echo "    Compiling $(<F)   ->   $(@F)"
	@mkdir -p $(@D)
	@$(CC) $(BootFDD_CPPFLAGS) $(BootFDD_CFLAGS) -MMD -MP -MT Build/Dependencies/BootFDD/$*.d -c -o $@ $<
Build/Arch-Objects/x86_64/BootFDD/%.o: Modules/BootFDD/Arch/x86_64/Source/%.c Makefile
	@echo "    Compiling $(<F)   ->   $(@F)"
	@mkdir -p $(@D)
	@$(CC) $(BootFDD_CPPFLAGS) $(BootFDD_CFLAGS) -MMD -MP -MT Build/Arch-Dependencies/x86_64/BootFDD/$*.d -c -o $@ $<

Build/Objects/BootFDD/%.o: Modules/BootFDD/Source/%.cpp Makefile
	@echo "    Compiling $(<F)   ->   $(@F)"
	@mkdir -p $(@D)
	@$(CXX) $(BootFDD_CPPFLAGS) $(BootFDD_CXXFLAGS) -MMD -MP -MT Build/Dependencies/BootFDD/$*.d -c -o $@ $<
Build/Arch-Objects/x86_64/BootFDD/%.o: Modules/BootFDD/Arch/x86_64/Source/%.cpp Makefile
	@echo "    Compiling $(<F)   ->   $(@F)"
	@mkdir -p $(@D)

Build/Arch-Objects/x86_64/BootFDD/%.o: Modules/BootFDD/Arch/x86_64/Source/%.asm Makefile $(BootFDD_INCASM)
	@echo "    Compiling $(<F)   ->   $(@F)"
	@mkdir -p $(@D)
	@$(AS) $(BootFDD_ASFLAGS) -o $@ $<

Build/Binaries/BootFDD.sys: $(BootFDD_OBJINIT) $(BootFDD_OBJC) $(BootFDD_OBJCXX) $(BootFDD_OBJASM)
	@echo "    Linking $(@F)"
	@mkdir -p $(@D)
	@$(CC) $(BootFDD_LDFLAGS) -o $@ -T Modules/BootFDD/Link.ld $^

###############################################################################
# BootISO                                                                     #
###############################################################################
# .PHONY: BootISO
# BootISO: Build/Binaries/BootISO.sys

# BootISO_OBJINIT := Build/Arch-Objects/x86_64/BootISO/Init.o

# BootISO_OBJC := $(addprefix Build/Objects/BootISO/,$(patsubst %.c,%.o,$(shell find -L Modules/BootISO/Source -type f -name '*.c' | sed 's/Modules\/BootISO\/Source\///g')))
# BootISO_OBJC += $(addprefix Build/Arch-Objects/x86_64/BootISO/,$(patsubst %.c,%.o,$(shell find -L Modules/BootISO/Arch/x86_64/Source -type f -name '*.c' | sed 's/Modules\/BootISO\/Arch\/x86_64\/Source\///g')))
# BootISO_OBJCXX := $(addprefix Build/Objects/BootISO/,$(patsubst %.cpp,%.o,$(shell find -L Modules/BootISO/Source -type f -name '*.cpp' | sed 's/Modules\/BootISO\/Source\///g')))
# BootISO_OBJCXX += $(addprefix Build/Arch-Objects/x86_64/BootISO/,$(patsubst %.cpp,%.o,$(shell find -L Modules/BootISO/Arch/x86_64/Source -type f -name '*.cpp' | sed 's/Modules\/BootISO\/Arch\/x86_64\/Source\///g')))

# BootISO_OBJASM := $(addprefix Build/Arch-Objects/x86_64/BootISO/,$(patsubst %.asm,%.o,$(shell find -L Modules/BootISO/Arch/x86_64/Source -type f -name '*.asm' | sed 's/Modules\/BootISO\/Arch\/x86_64\/Source\///g')))
# BootISO_INCASM := $(shell find -L Modules/BootISO/Arch/x86_64/Source -type f -name '*.inc')

# BootISO_DEPC := $(addprefix Build/Dependencies/BootISO/,$(patsubst %.c,%.d,$(shell find -L Modules/BootISO/Source -type f -name '*.c' | sed 's/Modules\/BootISO\/Source\///g')))
# BootISO_DEPC += $(addprefix Build/Arch-Dependencies/x86_64/BootISO/,$(patsubst %.c,%.d,$(shell find -L Modules/BootISO/Arch/x86_64/Source -type f -name '*.c' | sed 's/Modules\/BootISO\/Arch\/x86_64\/Source\///g')))
# BootISO_DEPCXX := $(addprefix Build/Dependencies/BootISO/,$(patsubst %.cpp,%.d,$(shell find -L Modules/BootISO/Source -type f -name '*.cpp' | sed 's/Modules\/BootISO\/Source\///g')))
# BootISO_DEPCXX += $(addprefix Build/Arch-Dependencies/x86_64/BootISO/,$(patsubst %.cpp,%.d,$(shell find -L Modules/BootISO/Arch/x86_64/Source -type f -name '*.cpp' | sed 's/Modules\/BootISO\/Arch\/x86_64\/Source\///g')))

# -include $(BootISO_DEPC) $(BootISO_DEPCXX)

# Build/Objects/BootISO/%.o: Modules/BootISO/Source/%.c Makefile
# 	@echo "    Compiling $(<F)   ->   $(@F)"
# 	@mkdir -p $(@D)
# 	@$(CC) $(BootISO_CPPFLAGS) $(BootISO_CFLAGS) -MMD -MP -MT Build/Dependencies/BootISO/$*.d -c -o $@ $<
# Build/Arch-Objects/x86_64/BootISO/%.o: Modules/BootISO/Arch/x86_64/Source/%.c Makefile
# 	@echo "    Compiling $(<F)   ->   $(@F)"
# 	@mkdir -p $(@D)
# 	@$(CC) $(BootISO_CPPFLAGS) $(BootISO_CFLAGS) -MMD -MP -MT Build/Arch-Dependencies/x86_64/BootISO/$*.d -c -o $@ $<

# Build/Objects/BootISO/%.o: Modules/BootISO/Source/%.cpp Makefile
# 	@echo "    Compiling $(<F)   ->   $(@F)"
# 	@mkdir -p $(@D)
# 	@$(CXX) $(BootISO_CPPFLAGS) $(BootISO_CXXFLAGS) -MMD -MP -MT Build/Dependencies/BootISO/$*.d -c -o $@ $<
# Build/Arch-Objects/x86_64/BootISO/%.o: Modules/BootISO/Arch/x86_64/Source/%.cpp Makefile
# 	@echo "    Compiling $(<F)   ->   $(@F)"
# 	@mkdir -p $(@D)

# Build/Arch-Objects/x86_64/BootISO/%.o: Modules/BootISO/Arch/x86_64/Source/%.asm Makefile $(BootISO_INCASM)
# 	@echo "    Compiling $(<F)   ->   $(@F)"
# 	@mkdir -p $(@D)
# 	@$(AS) $(BootISO_ASFLAGS) -o $@ $<

# Build/Binaries/BootISO.sys: $(BootISO_OBJINIT) $(BootISO_OBJC) $(BootISO_OBJCXX) $(BootISO_OBJASM)
# 	@echo "    Linking $(@F)"
# 	@mkdir -p $(@D)
# 	@$(CC) $(BootISO_LDFLAGS) -o $@ -T Modules/BootISO/Link.ld $^

###############################################################################
# Gloss                                                                       #
###############################################################################
.PHONY: Gloss
Gloss: Build/Binaries/Gloss.sys

Gloss_OBJINIT := Build/Arch-Objects/x86_64/Gloss/Init.o

Gloss_CFLAGS :=
Gloss_CXXFLAGS := -std=c++11 -ffreestanding -O1 -Wall -Wextra
Gloss_CPPFLAGS := -IModules/Gloss/Include -IModules/Gloss/Arch/x86_64/Include
Gloss_ASFLAGS :=
Gloss_LDFLAGS := -ffreestanding -O2 -nostdlib -lgcc

Gloss_OBJC := $(addprefix Build/Objects/Gloss/,$(patsubst %.c,%.o,$(shell find -L Modules/Gloss/Source -type f -name '*.c' | sed 's/Modules\/Gloss\/Source\///g')))
Gloss_OBJC += $(addprefix Build/Arch-Objects/x86_64/Gloss/,$(patsubst %.c,%.o,$(shell find -L Modules/Gloss/Arch/x86_64/Source -type f -name '*.c' | sed 's/Modules\/Gloss\/Arch\/x86_64\/Source\///g')))
Gloss_OBJCXX := $(addprefix Build/Objects/Gloss/,$(patsubst %.cpp,%.o,$(shell find -L Modules/Gloss/Source -type f -name '*.cpp' | sed 's/Modules\/Gloss\/Source\///g')))
Gloss_OBJCXX += $(addprefix Build/Arch-Objects/x86_64/Gloss/,$(patsubst %.cpp,%.o,$(shell find -L Modules/Gloss/Arch/x86_64/Source -type f -name '*.cpp' | sed 's/Modules\/Gloss\/Arch\/x86_64\/Source\///g')))

Gloss_OBJASM := $(addprefix Build/Arch-Objects/x86_64/Gloss/,$(patsubst %.asm,%.o,$(shell find -L Modules/Gloss/Arch/x86_64/Source -type f -name '*.asm' | sed 's/Modules\/Gloss\/Arch\/x86_64\/Source\///g')))
Gloss_INCASM := $(shell find -L Modules/Gloss/Arch/x86_64/Source -type f -name '*.inc')

Gloss_DEPC := $(addprefix Build/Dependencies/Gloss/,$(patsubst %.c,%.d,$(shell find -L Modules/Gloss/Source -type f -name '*.c' | sed 's/Modules\/Gloss\/Source\///g')))
Gloss_DEPC += $(addprefix Build/Arch-Dependencies/x86_64/Gloss/,$(patsubst %.c,%.d,$(shell find -L Modules/Gloss/Arch/x86_64/Source -type f -name '*.c' | sed 's/Modules\/Gloss\/Arch\/x86_64\/Source\///g')))
Gloss_DEPCXX := $(addprefix Build/Dependencies/Gloss/,$(patsubst %.cpp,%.d,$(shell find -L Modules/Gloss/Source -type f -name '*.cpp' | sed 's/Modules\/Gloss\/Source\///g')))
Gloss_DEPCXX += $(addprefix Build/Arch-Dependencies/x86_64/Gloss/,$(patsubst %.cpp,%.d,$(shell find -L Modules/Gloss/Arch/x86_64/Source -type f -name '*.cpp' | sed 's/Modules\/Gloss\/Arch\/x86_64\/Source\///g')))

-include $(Gloss_DEPC) $(Gloss_DEPCXX)

Build/Objects/Gloss/%.o: Modules/Gloss/Source/%.c Makefile
	@echo "    Compiling $(<F)   ->   $(@F)"
	@mkdir -p $(@D)
	@$(CC) $(Gloss_CPPFLAGS) $(Gloss_CFLAGS) -MMD -MP -MT Build/Dependencies/Gloss/$*.d -c -o $@ $<
Build/Arch-Objects/x86_64/Gloss/%.o: Modules/Gloss/Arch/x86_64/Source/%.c Makefile
	@echo "    Compiling $(<F)   ->   $(@F)"
	@mkdir -p $(@D)
	@$(CC) $(Gloss_CPPFLAGS) $(Gloss_CFLAGS) -MMD -MP -MT Build/Arch-Dependencies/x86_64/Gloss/$*.d -c -o $@ $<

Build/Objects/Gloss/%.o: Modules/Gloss/Source/%.cpp Makefile
	@echo "    Compiling $(<F)   ->   $(@F)"
	@mkdir -p $(@D)
	@$(CXX) $(Gloss_CPPFLAGS) $(Gloss_CXXFLAGS) -MMD -MP -MT Build/Dependencies/Gloss/$*.d -c -o $@ $<
Build/Arch-Objects/x86_64/Gloss/%.o: Modules/Gloss/Arch/x86_64/Source/%.cpp Makefile
	@echo "    Compiling $(<F)   ->   $(@F)"
	@mkdir -p $(@D)
	@$(CXX) $(Gloss_CPPFLAGS) $(Gloss_CXXFLAGS) -MMD -MP -MT Build/Arch-Dependencies/x86_64/Gloss/$*.d -c -o $@ $<

Build/Arch-Objects/x86_64/Gloss/%.o: Modules/Gloss/Arch/x86_64/Source/%.asm Makefile $(Gloss_INCASM)
	@echo "    Compiling $(<F)   ->   $(@F)"
	@mkdir -p $(@D)
	@$(AS) $(Gloss_ASFLAGS) -o $@ $<

Build/Binaries/Gloss.sys: $(GLOSS_OBJINIT) $(Gloss_OBJC) $(Gloss_OBJCXX) $(Gloss_OBJASM)
	@echo "    Linking $(@F)"
	@mkdir -p $(@D)
	@$(CC) $(Gloss_LDFLAGS) -o $@ -T Modules/Gloss/Link.ld $^

###############################################################################
# Kernel                                                                       #
###############################################################################
# .PHONY: Kernel
# Kernel: Build/Binaries/Kernel.sys

# Kernel_OBJC := $(addprefix Build/Objects/Kernel/,$(patsubst %.c,%.o,$(shell find -L Modules/Kernel/Source -type f -name '*.c' | sed 's/Modules\/Kernel\/Source\///g')))
# Kernel_OBJC += $(addprefix Build/Arch-Objects/x86_64/Kernel/,$(patsubst %.c,%.o,$(shell find -L Modules/Kernel/Arch/x86_64/Source -type f -name '*.c' | sed 's/Modules\/Kernel\/Arch\/x86_64\/Source\///g')))
# Kernel_OBJCXX := $(addprefix Build/Objects/Kernel/,$(patsubst %.cpp,%.o,$(shell find -L Modules/Kernel/Source -type f -name '*.cpp' | sed 's/Modules\/Kernel\/Source\///g')))
# Kernel_OBJCXX += $(addprefix Build/Arch-Objects/x86_64/Kernel/,$(patsubst %.cpp,%.o,$(shell find -L Modules/Kernel/Arch/x86_64/Source -type f -name '*.cpp' | sed 's/Modules\/Kernel\/Arch\/x86_64\/Source\///g')))

# Kernel_OBJASM := $(addprefix Build/Arch-Objects/x86_64/Kernel/,$(patsubst %.asm,%.o,$(shell find -L Modules/Kernel/Arch/x86_64/Source -type f -name '*.asm' | sed 's/Modules\/Kernel\/Arch\/x86_64\/Source\///g')))
# Kernel_INCASM := $(shell find -L Modules/Kernel/Arch/x86_64/Source -type f -name '*.inc')

# Kernel_DEPC := $(addprefix Build/Dependencies/Kernel/,$(patsubst %.c,%.d,$(shell find -L Modules/Kernel/Source -type f -name '*.c' | sed 's/Modules\/Kernel\/Source\///g')))
# Kernel_DEPC += $(addprefix Build/Arch-Dependencies/x86_64/Kernel/,$(patsubst %.c,%.d,$(shell find -L Modules/Kernel/Arch/x86_64/Source -type f -name '*.c' | sed 's/Modules\/Kernel\/Arch\/x86_64\/Source\///g')))
# Kernel_DEPCXX := $(addprefix Build/Dependencies/Kernel/,$(patsubst %.cpp,%.d,$(shell find -L Modules/Kernel/Source -type f -name '*.cpp' | sed 's/Modules\/Kernel\/Source\///g')))
# Kernel_DEPCXX += $(addprefix Build/Arch-Dependencies/x86_64/Kernel/,$(patsubst %.cpp,%.d,$(shell find -L Modules/Kernel/Arch/x86_64/Source -type f -name '*.cpp' | sed 's/Modules\/Kernel\/Arch\/x86_64\/Source\///g')))

# -include $(Kernel_DEPC) $(Kernel_DEPCXX)

# Build/Objects/Kernel/%.o: Modules/Kernel/Source/%.c Makefile
# 	@echo "    Compiling $(<F)   ->   $(@F)"
# 	@mkdir -p $(@D)
# 	@$(CC) $(CPPFLAGS) $(CFLAGS) -MMD -MP -MT Build/Dependencies/Kernel/$*.d -c -o $@ $<
# Build/Arch-Objects/x86_64/Kernel/%.o: Modules/Kernel/Arch/x86_64/Source/%.c Makefile
# 	@echo "    Compiling $(<F)   ->   $(@F)"
# 	@mkdir -p $(@D)
# 	@$(CC) $(CPPFLAGS) $(CFLAGS) -MMD -MP -MT Build/Arch-Dependencies/x86_64/Kernel/$*.d -c -o $@ $<

# Build/Objects/Kernel/%.o: Modules/Kernel/Source/%.cpp Makefile
# 	@echo "    Compiling $(<F)   ->   $(@F)"
# 	@mkdir -p $(@D)
# 	@$(CXX) $(CPPFLAGS) $(CXXFLAGS) -MMD -MP -MT Build/Dependencies/Kernel/$*.d -c -o $@ $<
# Build/Arch-Objects/x86_64/Kernel/%.o: Modules/Kernel/Arch/x86_64/Source/%.cpp Makefile
# 	@echo "    Compiling $(<F)   ->   $(@F)"
# 	@mkdir -p $(@D)

# Build/Arch-Objects/x86_64/Kernel/%.o: Modules/Kernel/Arch/x86_64/Source/%.asm Makefile $(Kernel_INCASM)
# 	@echo "    Compiling $(<F)   ->   $(@F)"
# 	@mkdir -p $(@D)
# 	@$(AS) $(ASFLAGS) -o $@ $<

# Build/Binaries/Kernel.sys: $(Kernel_OBJC) $(Kernel_OBJCXX) $(Kernel_OBJASM)
# 	@echo "    Linking $(@F)"
# 	@mkdir -p $(@D)
# 	@$(CC) $(LDFLAGS) -o $@ -T Modules/Kernel/Link.ld $^

###############################################################################
# SlickOS Hard Disk Image                                                     #
###############################################################################
.PHONY: ImageHDD
ImageHDD: Build/Images/SlickOS.raw

Build/Images/SlickOS.raw: Build/Binaries/BootHDD.sys Build/Binaries/Gloss.sys
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
