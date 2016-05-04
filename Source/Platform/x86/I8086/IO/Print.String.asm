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

// This code is located in the .TEXT (executable) section of the executable.
.section .text

// The following function prints a null terminated string to all initialized
// forms of IO.
.global I8086.IO.Print.String
I8086.IO.Print.String:
    // We first store some state.
    push ax
    push si

    // Since we want to print each character one by one, we simply load each
    // byte one by one and push it to the character printing function. This
    // requires, however, that the direction flag is cleared so we read the
    // correct memory.
    cld

    // We print, then load in this function so we must skip over the first
    // printing of the character.
    jmp I8086.IO.Print.String.Load

    I8086.IO.Print.String.Char:
        // Now we simply call the character printing function.
        call I8086.IO.Print.Char

    I8086.IO.Print.String.Load:
        // We load a byte from the string. If it is null, then we are done
        // printing the string.
        lodsb
        test al, al
        jne I8086.IO.Print.String.Char

    // We finally restore state and exit to the calling function.
    pop si
    pop ax
    ret
    