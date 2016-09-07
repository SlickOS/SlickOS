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
.code16

// This code is located in the .DATA (read-write) section of the executable.
.section .data
I386.ACPI.RSDPTR: .ascii "RSD PTR "

// This code is located in the .TEXT (executable) section of the executable.
.section .text

I386.ACPI.FindRSDP:
    push ecx
    push esi
    xor edi, edi

    I386.ACPI.FindRSDP.Search:
        mov ecx, 0x08
        mov esi, I386.ACPI.RSDPTR
        push edi
        rep cmpsb
        pop edi
        je I386.ACPI.FindRSDP.Done
        add edi, 0x08
        cmp edi, 0x000FFFFF
        jl I386.ACPI.FindRSDP.Search

    xor edi, edi
    I386.ACPI.FindRSDP.Done:
        pop esi
        pop ecx
        ret
        