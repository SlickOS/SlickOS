//===========================================================================//
// Generic Loader for Operating System Software (GLOSS)                      //
//                                                                           //
// Copyright (C) 2015-2016 - Adrian J. Collado     <acollado@polaritech.net> //
//===========================================================================//
.ifndef X86_I8086_IO_INIT_INC
.equ X86_I8086_IO_INIT_INC, 0x01

// Seeing how AT&T assembly syntax is much more verbose than Intel assembly
// syntax, the assembly language code in this project will use Intel syntax.
.intel_syntax noprefix

// This code will be executed in a 16 bit real mode environment.
.code16

// This code is located in the .TEXT (executable) section of the binary.
.section .text

// The follwoing function initialized all forms of IO that the primary boot
// sector can utilize.
I8086.IO.Init:
    // We first initialize the first serial port (COM1).
    call I8086.IO.Serial.Init

    // We next initialize the video card.
    call I8086.IO.Video.Init

    // Now we return to the calling function.
    ret

.endif
// vim: set ft=intelasm:
