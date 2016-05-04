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

.section .data
GenericErrorMessage: .asciz "No handler defined for Interrupt "
//RIPMessage: .asciz "RIP: "

// This code is located in the .TEXT (executable) section of the executable.
.section .text

.global AMD64.IDT.GenericHandler
AMD64.IDT.GenericHandler:
    push rax
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi

    mov ax, ds
    push rax

    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov rax, 0xb8022
    mov dword ptr [rax], 0x40404040

    mov rax, rdi
    mov rdi, offset GenericErrorMessage
    //mov rsi, offset RIPMessage
    call AMD64.Console.Print
    //lea rsi, [rip]
    mov rdi, rax
    call AMD64.Console.PrintHex8
    mov rdi, rax
    mov rax, '.'
    call AMD64.Console.PutChar
    mov rax, 0x0A
    call AMD64.Console.PutChar

    hlt

    pop rax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    pop rsi
    pop rdi
    pop rdx
    pop rcx
    pop rbx
    pop rax 

    ret
