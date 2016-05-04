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

// This function disables the A20 line by toggling its status if necessary.
.global I8086.A20.Disable
I8086.A20.Disable:
    // Our A20 line disabling function uses our toggle function in conjunction
    // with the check function to disable the A20 line for us. The first thing
    // we do, however, is store some state.
    push ax

    // Next we check the current A20 line value. We also set the A20 line
    // status flag in our flags variable to disabled (we will reset it later on
    // the off chance we can't disable the A20 line).
    call I8086.A20.Check
    jc I8086.A20.Disable.Exit
    mov al, [BSS.A20.Status]
    and al, 0xfb
    mov [BSS.A20.Status], al

    // Now we attempt to toggle the A20 line value.
    call I8086.A20.Toggle
    jnc I8086.A20.Disable.Exit

    // If we reach this point, we cannot use any odd MiBs, as the A20 line is
    // disabled. We thus set the A20 line value in our flags variable to
    // disabled. It is possible for the bootloader to continue, however, it
    // will only be able to access even MiBs of memory.
    mov al, [BSS.A20.Status]
    or al, 0x04
    mov [BSS.A20.Status], al

    I8086.A20.Disable.Exit:
        // The final thing we do is restore state and return to the calling
        // function.
        pop ax
        ret
        