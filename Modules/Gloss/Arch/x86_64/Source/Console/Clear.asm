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

// This code is located in the .TEXT (executable) section of the executable.
.section .text

.global AMD64_Console_Clear
AMD64_Console_Clear:
.global AMD64.Console.Clear
AMD64.Console.Clear:
    push rax
    push rcx
    push rbx
    push rdi

    mov rdi, qword ptr [AMD64.Console.VideoMemory]
    xor rax, rax
    mov ch, byte ptr [AMD64.Console.ColorForeground]
    mov bh, byte ptr [AMD64.Console.ColorBackground]
    and ch, 0x0F
    shl bh, 0x04
    or ch, bh
    mov ah, ch
    xor al, al
    mov rcx, 2000
    rep stosw

    mov word ptr [AMD64.Console.CursorY], 0x00
    mov word ptr [AMD64.Console.CursorX], 0x00

    pop rdi
    pop rcx
    pop rbx
    pop rax
    ret
    