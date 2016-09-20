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

.global AMD64_Console_Print
AMD64_Console_Print:
.global AMD64.Console.Print
AMD64.Console.Print:
    push rsi
    push rax
    push rdi

    mov rsi, rdi

    AMD64.Console.Print.GetChar:
        lodsb
        test al, al
        jz AMD64.Console.Print.Done
        mov rdi, rax
        call AMD64.Console.PutChar
        jmp AMD64.Console.Print.GetChar

    AMD64.Console.Print.Done:
        pop rdi
        pop rax
        pop rsi
        ret
