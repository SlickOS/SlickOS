//===========================================================================//
// Generic Loader for Operating System Software (GLOSS)                      //
//                                                                           //
// Copyright (C) 2015-2016 - Adrian J. Collado     <acollado@polaritech.net> //
//===========================================================================//
.ifndef X86_I8086_CPU_GDT32_DATA_INC
.equ X86_I8086_CPU_GDT32_DATA_INC, 0x01

// Seeing how AT&T assembly syntax is much more verbose than Intel assembly
// syntax, the assembly language code in this project will use Intel syntax.
.intel_syntax noprefix

// This code will be executed in a 16 bit real mode environment.
.code16

// The following code is located in the .DATA (initialized variable) section of
// the binary.
.section .data

.global I8086.CPU.GDT32
I8086.CPU.GDT32:
    .global I8086.CPU.GDT32.Null
    I8086.CPU.GDT32.Null:
        I8086.CPU.GDT32.Null.Limit.Low:                     .word   0x0000
        I8086.CPU.GDT32.Null.Base.Low:                      .word   0x0000
        I8086.CPU.GDT32.Null.Base.Middle:                   .byte   0x00
        I8086.CPU.GDT32.Null.Access:                        .byte   0x00
        I8086.CPU.GDT32.Null.Flags:                         .byte   0x00
        I8086.CPU.GDT32.Null.Base.High:                     .byte   0x00
    .global I8086.CPU.GDT32.Code
    I8086.CPU.GDT32.Code:
        I8086.CPU.GDT32.Code.Limit.Low:                     .word   0xFFFF
        I8086.CPU.GDT32.Code.Base.Low:                      .word   0x0000
        I8086.CPU.GDT32.Code.Base.Middle:                   .byte   0x00
        I8086.CPU.GDT32.Code.Access:                        .byte   0x9A
        I8086.CPU.GDT32.Code.Flags:                         .byte   0xCF
        I8086.CPU.GDT32.Code.Base.High:                     .byte   0x00
    .global I8086.CPU.GDT32.Data
    I8086.CPU.GDT32.Data:
        I8086.CPU.GDT32.Data.Limit.Low:                     .word   0xFFFF
        I8086.CPU.GDT32.Data.Base.Low:                      .word   0x0000
        I8086.CPU.GDT32.Data.Base.Middle:                   .byte   0x00
        I8086.CPU.GDT32.Data.Access:                        .byte   0x92
        I8086.CPU.GDT32.Data.Flags:                         .byte   0xCF
        I8086.CPU.GDT32.Data.Base.High:                     .byte   0x00
    .global I8086.CPU.GDT32.Pointer
    I8086.CPU.GDT32.Pointer:
        .equ I8086.CPU.GDT32.Size, (I8086.CPU.GDT32.Pointer - I8086.CPU.GDT32 - 1)
        I8086.CPU.GDT32.Pointer.Limit:                      .word   I8086.CPU.GDT32.Size
        I8086.CPU.GDT32.Pointer.Base:                       .int    I8086.CPU.GDT32

.endif
// vim: set ft=intelasm:
