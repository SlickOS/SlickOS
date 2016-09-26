//===========================================================================//
// Generic Loader for Operating System Software (GLOSS)                      //
//                                                                           //
// The purpose of this file is to toggle the status of the A20 line          //
// extensions using standard BIOS functions.                                 //
//                                                                           //
// Copyright (C) 2015-2016 - Adrian J. Collado     <acollado@polaritech.net> //
//                                                                           //
// Return:                                                                   //
//  FLAGS    - Carry set on failure, carry clear otherwise.                  //
//===========================================================================//
.ifndef X86_I8086_MEMORY_A20_TOGGLE_BIOS_INC
.equ X86_I8086_MEMORY_A20_TOGGLE_BIOS_INC, 0x01

// Seeing how AT&T assembly syntax is much more verbose than Intel assembly
// syntax, the assembly language code in this project will use Intel syntax.
.intel_syntax noprefix

// This code will be executed in a 16 bit real mode environment.
.code16

// This code is located in the .TEXT (executable) section of the binary.
.section .text

I8086.A20.Toggle.BIOS:
    // The fastest, and arguably the safest (and most modern) method we have to
    // enable the A20 line is by using the BIOS itself. The nice thing about
    // this function is that the operation, if supported, almost always works
    // (due to being tied to the underlying hardware quite closely), and is
    // supported on most computers since the mid 1990's. Therefore, we use this
    // method befoe all others, and then if it doesn't work we move onto some
    // other method. Before proceeding, we store some state.
    push ax
    push bx

    // Next we load the function numbers 0x2401 and 0x2402. The second function
    // queries about the status of the A20 line. The first function is used to
    // enable the A20 line. Another function, 0x2400, is used to disable the
    // A20 line. The nice thing about the query function is that it returns a
    // status code, 0x00 for disabled, and 0x01 for enabled in the AX register.
    // If we subtract the status code from the register that stores the
    // function number for enabling the A20 line, we have created a toggle
    // switch for the A20 line status. If, for example, the A20 line is
    // enabled, the query function will return 0x01. We can then subtract that
    // return value from 0x2401, which is the function number for enabling the
    // A20 line. The result is 0x2400, which is the function for disabling the
    // A20 line. The process is the same if the query function returns 0x00,
    // in which case the chosen function will be 0x2401.
    mov bx, 0x2401
    mov ax, 0x2402

    // Now we simply call the query interrupt. If the function fails, the carry
    // flag will be set, allowing us to exit the function gracefully and try
    // another method.
    int 0x15
    jmp I8086.A20.Toggle.BIOS.Exit

    // Now we perform the calculation to get the correct BIOS function to call.
    // We do this, as stated above, by subtracting the return code from the
    // function number. We then swap the registers they are stored in so we can
    // call the correct BIOS function.
    sub bx, ax
    xchg bx, ax

    // Then it is just a matter of performing the interrupt. We don't have to
    // check for a carry flag this time, since if one of the A20 line functions
    // exists (and succeeds), then all of the A20 line functions exist (and
    // will succeed). However, we will still want to verify that the A20 line
    // was actually toggled, in the case of extenuating circumstances.
    int 0x15

    I8086.A20.Toggle.BIOS.Exit:
        // We finally restore the pre-function state, and return to the calling
        // function.
        pop bx
        pop ax
        ret

.endif
// vim: set ft=intelasm:
