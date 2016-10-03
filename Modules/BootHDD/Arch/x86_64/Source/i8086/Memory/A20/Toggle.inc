//===========================================================================//
// Generic Loader for Operating System Software (GLOSS)                      //
//                                                                           //
// The purpose of this file is to toggle the status of the A20 line          //
// extensions                                                                //
//                                                                           //
// Copyright (C) 2015-2016 - Adrian J. Collado     <acollado@polaritech.net> //
//===========================================================================//
.ifndef X86_I8086_MEMORY_A20_TOGGLE_INC
.equ X86_I8086_MEMORY_A20_TOGGLE_INC, 0x01

// Seeing how AT&T assembly syntax is much more verbose than Intel assembly
// syntax, the assembly language code in this project will use Intel syntax.
.intel_syntax noprefix

// This code will be executed in a 16 bit real mode environment.
.code16

// This code is located in the .TEXT (executable) section of the binary.
.section .text

I8086.A20.Toggle:
    // Our A20 line toggle function uses each of our different toggling
    // functions in conjunction with the check function to toggle the A20 line
    // for us. The first thing we do, however, is store some state (and clear
    // the carry flag).
    clc
    push ax
    push bx
    push cx

    // Next we check the current A20 line value so we can determine what state
    // the A20 line is in to begin with.
    call I8086.A20.Check
    pushf
    pop bx
    and bx, 0x01

    // Now we attempt to toggle the A20 line using the BIOS. After trying this
    // method, we check if the A20 line is toggled using our check function.
    call I8086.A20.Toggle.BIOS
    call I8086.A20.Check
    pushf
    pop cx
    and cx, 0x01
    test cx, bx
    clc
    jne I8086.A20.Toggle.Exit

    // If our BIOS function didn't work, we attempt to toggle the A20 line
    // using the PS/2 controller. It is reasonable to assume that if the BIOS
    // function failed, then the PS/2 function will succeed. We then check the
    // A20 line status again, just to make sure.
    call I8086.A20.Toggle.PS2
    call I8086.A20.Check
    pushf
    pop cx
    and cx, 0x01
    test cx, bx
    clc
    jne I8086.A20.Toggle.Exit

    // Our last and final hope is to try the Fast A20 method. On Some systems
    // attempting this method can be extremely bad, but if we reach this point
    // then we really have nothing to lose. After calling the Fast A20 method,
    // we once again check the A20 line status.
    call I8086.A20.Toggle.Fast
    call I8086.A20.Check
    pushf
    pop cx
    and cx, 0x01
    test cx, bx
    clc
    jne I8086.A20.Toggle.Exit

    // If we reach this point, we could not toggle the A20 line. We thus return
    // a carry flag as a failure result.
    stc

    I8086.A20.Toggle.Exit:
        // The final thing we do is restore pre-function state and return to
        // the calling function.
        pop cx
        pop bx
        pop ax
        ret

.endif
// vim: set ft=intelasm:
