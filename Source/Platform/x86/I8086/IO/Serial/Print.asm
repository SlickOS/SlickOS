//===========================================================================//
// GLOSS - Generic Loader for Operating System Software                      //
// An extensible and configurable bootloader.                                //
//---------------------------------------------------------------------------//
// Copyright (C) 2013-2016 ~ Adrian J. Collado     <acollado@polaritech.com> //
// All Rights Reserved                                                       //
//===========================================================================//

// Seeing as how AT&T syntax is much more obscure and difficult to read (IMO)
// than Intel syntax, the assembly language code in this project for x86 based
// architectures will be using Intel syntax.
.intel_syntax noprefix

// This code will be executed in a 16 bit real mode environment.
.code16

// This code is located in the .TEXT (executable) section of the executable.
.section .text

// The following function prints a single character to the serial port.
.global I8086.IO.Serial.Print
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
    