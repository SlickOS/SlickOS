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

// This function initializes the first serial port (COM1) at 9600 baud with no
// parity, one stop bit, and eight data bits.
.global I8086.IO.Serial.Init
I8086.IO.Serial.Init:
    xor dx, dx
    mov ax, 0x00e3
    int 0x14
    or word ptr [BSS.IO.Serial.Flags], 0x0001
    ret
