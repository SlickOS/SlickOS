//===========================================================================//
// Generic Loader for Operating System Software (GLOSS)                      //
//                                                                           //
// Copyright (C) 2015-2016 - Adrian J. Collado     <acollado@polaritech.net> //
//===========================================================================//
.ifndef X86_I8086_IO_PRINT_STRING_INC
.equ X86_I8086_IO_PRINT_STRING_INC, 0x01

// Seeing how AT&T assembly syntax is much more verbose than Intel assembly
// syntax, the assembly language code in this project will use Intel syntax.
.intel_syntax noprefix

// This code will be executed in a 16 bit real mode environment.
.code16

// This code is located in the .TEXT (executable) section of the binary.
.section .text

// The following function prints a null terminated string to all initialized
// forms of IO available to the primary boot sector.
I8086.IO.Print.String:
    // We first store some state.
    push ax
    push si
    pushf

    // Since we want to print each character one by one, we simply load each
    // byte one by one and push it to the character printing function. This
    // requires, however, that the direction flag is clear so we read the
    // correct memory.
    cld

    I8086.IO.Print.String.Execute:
        // We load a byte from the string. If it is null, then we are done
        // printing the string.
        lodsb
        test al, al
        je I8086.IO.Print.String.Done

        // Now we simply call the character printing function.
        call I8086.IO.Print.Char

        // Now we load the next byte from the string, and continue.
        jmp I8086.IO.Print.String.Execute

    I8086.IO.Print.String.Done:
        // We finally restore state and exit to the calling function.
        popf
        pop si
        pop ax

        ret

.endif
// vim: set ft=intelasm:
