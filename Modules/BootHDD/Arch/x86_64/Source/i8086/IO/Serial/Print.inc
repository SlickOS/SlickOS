//===========================================================================//
// Generic Loader for Operating System Software (GLOSS)                      //
//                                                                           //
// Copyright (C) 2015-2016 - Adrian J. Collado     <acollado@polaritech.net> //
//===========================================================================//
.ifndef X86_I8086_IO_SERIAL_PRINT_INC
.equ X86_I8086_IO_SERIAL_PRINT_INC, 0x01

// Seeing how AT&T assembly syntax is much more verbose than Intel assembly
// syntax, the assembly language code in this project will use Intel syntax.
.intel_syntax noprefix

// This code will be executed in a 16 bit real mode environment.
.code16

// This code is located in the .TEXT (executable) section of the binary.
.section .text

// This function prints a single character to the first serial port (COM1).
I8086.IO.Serial.Print:
    // The first thing we do is store some state.
    push ax
    push dx

    // Next, we clear the dx register as 0x00 in the dx register corresponds to
    // the first serial port. We then invoke the interrupt required to send
    // data using the serial port.
    xor dx, dx
    mov ah, 0x01
    int 0x14

    // We finally restore state and return to the calling function.
    pop dx
    pop ax
    ret

.endif
// vim: set ft=intelasm:
