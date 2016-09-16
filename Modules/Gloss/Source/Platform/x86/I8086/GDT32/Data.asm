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

// This code is located in the .DATA (read-write) section of the executable.
.section .data

.global I8086.GDT32
.global I8086.GDT32.Null
.global I8086.GDT32.Code
.global I8086.GDT32.Data
.global I8086.GDT32.End

I8086.GDT32:
I8086.GDT32.Null:
    .word 0x0000
    .word 0x0000
    .byte 0x00
    .byte 0x00
    .byte 0x00
    .byte 0x00
I8086.GDT32.Code:
    .word 0xFFFF
    .word 0x0000
    .byte 0x00
    .byte 0x9A
    .byte 0xCF
    .byte 0x00
I8086.GDT32.Data:
    .word 0xFFFF
    .word 0x0000
    .byte 0x00
    .byte 0x92
    .byte 0xCF
    .byte 0x00
I8086.GDT32.End:
    .word (I8086.GDT32.End - I8086.GDT32 - 1)
    .int I8086.GDT32
    