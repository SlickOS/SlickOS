//===========================================================================//
// Generic Loader for Operating System Software (GLOSS)                      //
//                                                                           //
// The purpose of this file is to check whether the A20 line extensions are  //
// enabled.                                                                  //
//                                                                           //
// Copyright (C) 2015-2016 - Adrian J. Collado     <acollado@polaritech.net> //
//                                                                           //
// Return:                                                                   //
//  FLAGS    - Carry set when A20 is disabled, carry clear otherwise.        //
//===========================================================================//
.ifndef X86_I8086_MEMORY_A20_CHECK_INC
.equ X86_I8086_MEMORY_A20_CHECK_INC, 0x01

// Seeing how AT&T assembly syntax is much more verbose than Intel assembly
// syntax, the assembly language code in this project will use Intel syntax.
.intel_syntax noprefix

// This code will be executed in a 16 bit real mode environment.
.code16

// This code is located in the .TEXT (executable) section of the binary.
.section .text

I8086.A20.Check:
    // This function checks the status of the A20 line by observing the effect
    // of writing a byte value at the edge of the IBM PC's memory span. If the
    // word wraps around to the start of memory, then the A20 line is disabled.
    // We start by storing some state.
    push ax
    push ds
    push es
    push di
    push si

    // Next we disable interrupts. If memory does wrap around in this function,
    // then (very) bad things will happen if a CPU interrupt occurs, as the
    // start of memory on an x86 system is the location of the real mode IVT
    // (Interrupt Vector Table). If an interrupt occurs, it will attempt to use
    // the function addresses stored in the table, and if those addresses are
    // invalid, junk code will execute.
    cli

    // Next we set two segment registers, the data segment register and the
    // extra segment register, to 0x0000 and 0xFFFF, respectively. We do this
    // since we will soon want to access the first byte of memory and the first
    // byte of memory after 1MiB of total memory.
    xor ax, ax
    mov es, ax
    not ax
    mov ds, ax

    // Next we set two index registers, the destinatin index register and the
    // source index register, to 0x0500 and 0x0510, respectively. These
    // registers have values, when used in the proper segment, refer to
    // locations exactly 1 MiB apart.
    mov di, 0x0500
    mov si, 0x0510

    // We now store the current bytes at our test memory locations. We do this
    // because, as stated above, we don't want to mess up the real mode IVT. At
    // this point in the bootloader, we will still need BIOS interrupts.
    mov al, es:[di]
    push ax
    mov al, ds:[si]
    push ax

    // Now we write two distinct bytes to both memory locations. This allows us
    // to check to see if, when we wrote the second value, that the first value
    // was overwritten. If this is the case, then our memory wraps around, and
    // the A20 line is not enabled. If it doesn't overwrite the first value,
    // then the A20 line is enabled.
    mov byte ptr es:[di], 0x00
    mov byte ptr ds:[si], 0xFF
    cmp byte ptr es:[di], 0xFF

    // Now we restore the original values that were at the memory locations. We
    // don't have to worry about corrupting the result of the previous
    // comparison, as none of the instructions that we execute right now affect
    // the FLAGS register.
    pop ax
    mov ds:[si], al
    pop ax
    mov es:[di], al

    // Now we set a status value by using the carry flag. If memory did not
    // wrap around, then we clear the carry flag. If it did wrap around, then
    // we set the carry flag.
    clc
    je I8086.A20.Check.Exit
    stc

    I8086.A20.Check.Exit:
        // Now we can re-enable interrupts, as the real mode IVT was returned
        // to normal.
        sti

        // We finally reset all of the registers that we used back to their
        // previous values and return to the calling function.
        pop si
        pop di
        pop es
        pop ds
        pop ax
        ret

.endif
// vim: set ft=intelasm:
