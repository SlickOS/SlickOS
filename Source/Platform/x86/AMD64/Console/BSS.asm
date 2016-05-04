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

// This code is located in the .BSS (uninitialized variable) section of the
// executable.
.section .bss

.global AMD64.Console.CursorY
AMD64.Console.CursorY:                  .skip 2, 0x00

.global AMD64.Console.CursorX
AMD64.Console.CursorX:                  .skip 2, 0x00

.global AMD64.Console.VideoMemory
AMD64.Console.VideoMemory:              .skip 8, 0x00

.global AMD64.Console.ColorBackground
AMD64.Console.ColorBackground:          .skip 1, 0x00

.global AMD64.Console.ColorForeground
AMD64.Console.ColorForeground:          .skip 1, 0x00

.global AMD64.Console.TabWidth
AMD64.Console.TabWidth:                 .skip 2, 0x00
