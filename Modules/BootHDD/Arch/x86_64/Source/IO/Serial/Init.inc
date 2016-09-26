//===========================================================================//
// Generic Loader for Operating System Software (GLOSS)                      //
//                                                                           //
// Copyright (C) 2015-2016 - Adrian J. Collado     <acollado@polaritech.net> //
//===========================================================================//
.ifndef X86_I8086_IO_SERIAL_INIT_INC
.equ X86_I8086_IO_SERIAL_INIT_INC, 0x01

// Seeing how AT&T assembly syntax is much more verbose than Intel assembly
// syntax, the assembly language code in this project will use Intel syntax.
.intel_syntax noprefix

// This code will be executed in a 16 bit real mode environment.
.code16

// This code is located in the .TEXT (executable) section of the binary.
.section .text

// This function initializes the first serial port (COM1) at 9600 baud with no
// parity, one stop bit, and eight data bits.
I8086.IO.Serial.Init:
    xor dx, dx
    mov ax, 0x00E3
    int 0x14
    or word ptr [BSS.IO.Serial.Flags], 0x0001
    ret

.endif
// vim: set ft=intelasm:
