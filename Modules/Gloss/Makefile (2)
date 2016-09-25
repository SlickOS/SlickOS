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

LDFLAGS := -ffreestanding -O1 -nostdlib -lgcc
CXXFLAGS := -std=c++11 -ffreestanding -O1 -Wall -Wextra
CPPFLAGS := -IInclude

.PHONY: all clean rebuild
all:

MAKEFILE += --no-builtin-rules
.SUFFIXES:

CC := x86_64-elf-gcc-6.2.0
CXX := x86_64-elf-g++-6.2.0
LD := x86_64-elf-ld-2.27
AS := x86_64-elf-as-2.27

vpath
vpath %.c Source
vpath %.cpp Source
vpath %.asm Source

OBJ_C :=   $(addprefix Build/Objects/,$(patsubst %.c,%.o,$(shell \
             find -L Source -type f -name '*.c' | \
             sed 's/Source\///g')))
OBJ_CXX := $(addprefix Build/Objects/,$(patsubst %.cpp,%.o,$(shell \
             find -L Source -type f -name '*.cpp' | \
             sed 's/Source\///g')))
OBJ_ASM := $(addprefix Build/Objects/,$(patsubst %.asm,%.o,$(shell \
             find -L Source -type f -name '*.asm' | \
             sed 's/Source\///g')))
DEP_C :=   $(addprefix Build/Dependencies/,$(patsubst %.c,%.d,$(shell \
             find -L Source -type f -name '*.c' | \
             sed 's/Source\///g')))
DEP_CXX := $(addprefix Build/Dependencies/,$(patsubst %.cpp,%.d,$(shell \
             find -L Source -type f -name '*.cpp' | \
             sed 's/Source\///g')))
DEP_ASM := $(addprefix Build/Dependencies/,$(patsubst %.asm,%.d,$(shell \
             find -L Source -type f -name '*.asm' | \
             sed 's/Source\///g')))

-include $(DEP_C) $(DEP_CXX) $(DEP_ASM)

Build/Objects/%.o: %.c Makefile
	@echo "    Compiling $(<F)   ->   $(@F)"
	@mkdir -p $(@D)
	@$(CC) $(CPPFLAGS) $(CFLAGS) -MMD -MP -MT Build/Dependencies/$*.d -c -o $@ $<
Build/Objects/%.o: %.cpp Makefile
	@echo "    Compiling $(<F)   ->   $(@F)"
	@mkdir -p $(@D)
	@$(CXX) $(CPPFLAGS) $(CXXFLAGS) -MMD -MP -MT Build/Dependencies/$*.d -c -o $@ $<
Build/Objects/%.o: %.asm Makefile
	@echo "    Compiling $(<F)   ->   $(@F)"
	@mkdir -p $(@D)
	@$(AS) $(ASFLAGS) -o $@ $<

Build/GLOSS.SYS: Build/Objects/Init.o $(OBJ_C) $(OBJ_CXX) $(OBJ_ASM)
	@echo "    Linking $(@F)"
	@mkdir -p $(@D)
	@$(CC) $(LDFLAGS) -o $@ -T Link.ld $^

.PHONY: all
all: Build/GLOSS.SYS
	@true

clean:
	@rm -rf Build

rebuild: clean all
