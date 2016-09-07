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

// This code will be executed in a 64 bit long mode environment.
.code64

// This code is located in the .DATA (read-write) section of the executable.
.section .bss

// This variable stores the start address of the IDT entries.
.global AMD64.IDT.Start
AMD64.IDT.Start:                .skip 8, 0x00

// This variable stores the start address of the interrupt handlers.
.global AMD64.IDT.HandlerAddress
AMD64.IDT.HandlerAddress:       .skip 8, 0x00

// This variable stores the pointer to the 64 bit IDT.
.align 16
.global AMD64.IDT.Pointer
// .skip 2, 0x00
AMD64.IDT.Pointer:
    .global AMD64.IDT.Pointer.Limit
    AMD64.IDT.Pointer.Limit:    .skip 2, 0x00
    .global AMD64.IDT.Pointer.Offset
    AMD64.IDT.Pointer.Offset:   .skip 8, 0x00
    