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
.code64

// This code is located in the .TEXT (executable) section of the executable.
.section .text

.global AMD64.IDT.Init
AMD64.IDT.Init:
    xor rdi, rdi
    xor rax, rax
    mov rcx, 0x200
    rep stosq

    xor rdi, rdi
    mov qword ptr [AMD64.IDT.Start], 0x00
    mov qword ptr [AMD64.IDT.Pointer.Offset], 0x00
    mov word ptr [AMD64.IDT.Pointer.Limit], (0x10 * 0x100) - 1

    mov rdx, 0x08
    mov rcx, 0x8E

    mov rsi, offset AMD64.IDT.ISR00
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR01
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR02
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR03
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR04
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR05
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR06
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR07
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR08
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR09
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR0A
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR0B
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR0C
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR0D
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR0E
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR0F
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR10
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR11
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR12
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR13
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR14
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR15
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR16
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR17
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR18
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR19
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR1A
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR1B
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR1C
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR1D
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR1E
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR1F
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR20
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR21
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR22
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR23
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR24
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR25
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR26
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR27
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR28
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR29
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR2A
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR2B
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR2C
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR2D
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR2E
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    mov rsi, offset AMD64.IDT.ISR2F
    call AMD64.IDT.SetEntry
    add rdi, 0x10

    // mov rdi, 0x1000
    // mov rcx, 0x0200
    // xor rax, rax
    // rep stosq

    mov rdi, 0x1000
    mov rcx, 0x0100
    mov rax, offset AMD64.IDT.GenericHandler
    rep stosq

    mov rdi, 0x1000

    mov qword ptr [AMD64.IDT.HandlerAddress], rdi

    ret
