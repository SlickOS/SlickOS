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

.global AMD64_Console_Scroll
AMD64_Console_Scroll:
.global AMD64.Console.Scroll
AMD64.Console.Scroll:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi

    mov rcx, 0x780
    mov rsi, [AMD64.Console.VideoMemory]
    add rsi, 0xA0
    mov rdi, [AMD64.Console.VideoMemory]
    rep movsw

    xor rax, rax
    mov ch, byte ptr [AMD64.Console.ColorForeground]
    mov bh, byte ptr [AMD64.Console.ColorBackground]
    and ch, 0x0F
    shl bh, 0x04
    or ch, bh
    mov ah, ch
    xor al, al
    mov rcx, 0x50
    rep stosw

    dec word ptr [AMD64.Console.CursorY]

    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax

    ret
