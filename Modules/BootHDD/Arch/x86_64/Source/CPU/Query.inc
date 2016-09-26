//===========================================================================//
// Generic Loader for Operating System Software (GLOSS)                      //
//                                                                           //
// Copyright (C) 2015-2016 - Adrian J. Collado     <acollado@polaritech.net> //
//===========================================================================//
.ifndef X86_I8086_CPU_QUERY_INC
.equ X86_I8086_CPU_QUERY_INC, 0x01

// Seeing how AT&T assembly syntax is much more verbose than Intel assembly
// syntax, the assembly language code in this project will use Intel syntax.
.intel_syntax noprefix

// This code will be executed in a 16 bit real mode environment.
.code16

// This code is located in the .TEXT (executable) section of the binary.
.section .text

// The following function loads the 32 bit GDT and installs it using the 'lgdt'
// instruction.
I8086.CPU.Query:
    ret

.endif
// vim: set ft=intelasm:
