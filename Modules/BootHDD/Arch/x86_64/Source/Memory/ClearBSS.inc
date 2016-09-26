//===========================================================================//
// Generic Loader for Operating System Software (GLOSS)                      //
//                                                                           //
// The purpose of this file is to clear the .BSS section of the executable.  //
//                                                                           //
// Copyright (C) 2015-2016 - Adrian J. Collado     <acollado@polaritech.net> //
//===========================================================================//
.ifndef X86_I8086_MEMORY_CLEARBSS_INC
.equ X86_I8086_MEMORY_CLEARBSS_INC, 0x01

// Seeing how AT&T assembly syntax is much more verbose than Intel assembly
// syntax, the assembly language code in this project will use Intel syntax.
.intel_syntax noprefix

// This code will be executed in a 16 bit real mode environment.
.code16

// This code is located in the .TEXT (executable) section of the binary.
.section .text

I8086.Memory.ClearBSS:
    // First, we store some state.
    push ax
    push cx
    push di
    pushf

    // Now we set the size, location, and fill byte. Both the size and location
    // of the .BSS section are defined by the linker, so these constants are
    // not located in the current source file. The fill byte is nulled, as we
    // want fully empty memory.
    mov cx, SECTION_BSS_SIZE
    mov di, SECTION_BSS_START
    xor ax, ax

    // Now we clear the direction flag so we don't write-out the wrong portion
    // of memory.
    cld

    // We finally store the nulled byte throughout the entire .BSS section.
    rep stosb

    // We now restore state and return to the calling function.
    popf
    pop di
    pop cx
    pop ax

    ret

.endif
// vim: set ft=intelasm:
