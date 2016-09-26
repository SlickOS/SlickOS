//===========================================================================//
// Generic Loader for Operating System Software (GLOSS)                      //
//                                                                           //
// The purpose of this file is to generate a memory map.                     //
//                                                                           //
// Copyright (C) 2015-2016 - Adrian J. Collado     <acollado@polaritech.net> //
//===========================================================================//
.ifndef X86_I8086_MEMORY_MAP_INC
.equ X86_I8086_MEMORY_MAP_INC, 0x01

// Seeing how AT&T assembly syntax is much more verbose than Intel assembly
// syntax, the assembly language code in this project will use Intel syntax.
.intel_syntax noprefix

// This code will be executed in a 16 bit real mode environment.
.code16

// This code is located in the .TEXT (executable) section of the binary.
.section .text

I8086.Memory.Map:
    // Currently, the only method we have for building a memory map is by using
    // the BIOS E820 function to generate one for us. This means that if this
    // function ends up being unsupported, we won't have a memory map, and thus
    // must set a status bit in the main bootloader flags. We first start by
    // storing some state.
    push di

    // xor ax, ax
    // mov es, ax
    mov di, 0x1800

    // Now we call our E820 memory map function.
    call I8086.Memory.Map.E820

    // We now restore state and return to the calling function.
    pop di

    ret

.endif
// vim: set ft=intelasm:
