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

.global AMD64.IDT.SetEntry
AMD64.IDT.SetEntry:
    mov rax, rsi
    mov word ptr [rdi + 0x00], ax

    mov word ptr [rdi + 0x02], dx
    mov byte ptr [rdi + 0x05], cl

    mov rax, rsi
    shr rax, 0x10
    mov word ptr [rdi + 0x06], ax

    mov rax, rsi
    shr rax, 0x20
    mov dword ptr [rdi + 0x08], eax

    ret
