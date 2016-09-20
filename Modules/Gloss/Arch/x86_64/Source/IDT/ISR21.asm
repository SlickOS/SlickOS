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

MessageWTF: .asciz "Register: "

.global AMD64.IDT.ISR21
AMD64.IDT.ISR21:
    mov rdi, 0x00
    mov rsi, 0x21
    cld

    // push rdi
    // mov rdi, offset MessageWTF
    // call AMD64.Console.Print
    // pop rdi
    // call AMD64.Console.PrintHex64
    // mov rdi, 0x0A
    // call AMD64.Console.PutChar

    // mov rdi, offset MessageWTF
    // call AMD64.Console.Print
    // mov rdi, rsi
    // call AMD64.Console.PrintHex64
    // mov rdi, 0x0A
    // call AMD64.Console.PutChar

    // mov rdi, offset MessageWTF
    // call AMD64.Console.Print
    // mov rdi, rbp
    // call AMD64.Console.PrintHex64
    // mov rdi, 0x0A
    // call AMD64.Console.PutChar

    // mov rdi, offset MessageWTF
    // call AMD64.Console.Print
    // mov rdi, rsp
    // call AMD64.Console.PrintHex64
    // mov rdi, 0x0A
    // call AMD64.Console.PutChar

    // mov rdi, offset MessageWTF
    // call AMD64.Console.Print
    // mov rdi, rdx
    // call AMD64.Console.PrintHex64
    // mov rdi, 0x0A
    // call AMD64.Console.PutChar

    // mov rdi, offset MessageWTF
    // call AMD64.Console.Print
    // mov rdi, rcx
    // call AMD64.Console.PrintHex64
    // mov rdi, 0x0A
    // call AMD64.Console.PutChar

    // mov rdi, offset MessageWTF
    // call AMD64.Console.Print
    // mov rdi, rbx
    // call AMD64.Console.PrintHex64
    // mov rdi, 0x0A
    // call AMD64.Console.PutChar

    // mov rdi, offset MessageWTF
    // call AMD64.Console.Print
    // mov rdi, rax
    // call AMD64.Console.PrintHex64
    // mov rdi, 0x0A
    // call AMD64.Console.PutChar
    // mov rdi, 0x0A
    // call AMD64.Console.PutChar
    // mov rdi, 0x0A
    // call AMD64.Console.PutChar

    mov rax, [AMD64.IDT.HandlerAddress]
    call [rax + 0x108]

    // push rdi
    // mov rdi, offset MessageWTF
    // call AMD64.Console.Print
    // pop rdi
    // call AMD64.Console.PrintHex64
    // mov rdi, 0x0A
    // call AMD64.Console.PutChar

    // mov rdi, offset MessageWTF
    // call AMD64.Console.Print
    // mov rdi, rsi
    // call AMD64.Console.PrintHex64
    // mov rdi, 0x0A
    // call AMD64.Console.PutChar

    // mov rdi, offset MessageWTF
    // call AMD64.Console.Print
    // mov rdi, rbp
    // call AMD64.Console.PrintHex64
    // mov rdi, 0x0A
    // call AMD64.Console.PutChar

    // mov rdi, offset MessageWTF
    // call AMD64.Console.Print
    // mov rdi, rsp
    // call AMD64.Console.PrintHex64
    // mov rdi, 0x0A
    // call AMD64.Console.PutChar

    // mov rdi, offset MessageWTF
    // call AMD64.Console.Print
    // mov rdi, rdx
    // call AMD64.Console.PrintHex64
    // mov rdi, 0x0A
    // call AMD64.Console.PutChar

    // mov rdi, offset MessageWTF
    // call AMD64.Console.Print
    // mov rdi, rcx
    // call AMD64.Console.PrintHex64
    // mov rdi, 0x0A
    // call AMD64.Console.PutChar

    // mov rdi, offset MessageWTF
    // call AMD64.Console.Print
    // mov rdi, rbx
    // call AMD64.Console.PrintHex64
    // mov rdi, 0x0A
    // call AMD64.Console.PutChar

    // mov rdi, offset MessageWTF
    // call AMD64.Console.Print
    // mov rdi, rax
    // call AMD64.Console.PrintHex64
    // mov rdi, 0x0A
    // call AMD64.Console.PutChar

    // cli
    // hlt

    iretq
