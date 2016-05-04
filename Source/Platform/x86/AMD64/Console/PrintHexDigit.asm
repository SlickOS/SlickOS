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

.global AMD64.Console.PrintHexDigit
AMD64.Console.PrintHexDigit:
    push rdi

    cmp rdi, 0x09
    jle AMD64.Console.PrintHexDigit.Calculate.Number

    AMD64.Console.PrintHexDigit.Calculate.Letter:
        add rdi, 0x37
        jmp AMD64.Console.PrintHexDigit.PrintDigit

    AMD64.Console.PrintHexDigit.Calculate.Number:
        add rdi, 0x30

    AMD64.Console.PrintHexDigit.PrintDigit:
        call AMD64.Console.PutChar

    pop rdi
    ret
    