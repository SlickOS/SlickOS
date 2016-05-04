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

// This function toggles the A20 line using the "Fast" A20 method (System
// Control Port 0x92).
.global I8086.A20.Toggle.Fast
I8086.A20.Toggle.Fast:
    // This function, while called the Fast A20 method, is actually quite slow,
    // and on some systems is dangerous. This function is the least recommended
    // of all of the functions we use to toggle the A20 line. What this
    // function does is outputs a value through system control port 0x92. The
    // problem with this method is that on some computers it is unsupported,
    // while on other computers it may do something entirely different (such as
    // clearing the screen or eating your laundry). Therefore, we should only
    // use this method if we have no other choice.
    push ax
    in al, 0x92
    xor al, 0x02
    and al, 0xfe
    out 0x92, al
    pop ax
    ret
