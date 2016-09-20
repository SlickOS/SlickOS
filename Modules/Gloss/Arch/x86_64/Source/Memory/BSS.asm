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

// This code is located in the .BSS (uninitialized variable) section of the
// executable.
.section .bss

// This variable stores the address of the memory map.
.global I8086_Memory_Map_Address
I8086_Memory_Map_Address:
.global BSS.Memory.Map.Address
BSS.Memory.Map.Address:         .skip 8, 0x00

// This variable stores the number of entries in the memory map.
.global I8086_Memory_Map_Count
I8086_Memory_Map_Count:
.global BSS.Memory.Map.Count
BSS.Memory.Map.Count:           .skip 8, 0x00

.global I8086_Memory_Map_End
I8086_Memory_Map_End:
.global BSS.Memory.Map.End
BSS.Memory.Map.End:             .skip 8, 0x00
