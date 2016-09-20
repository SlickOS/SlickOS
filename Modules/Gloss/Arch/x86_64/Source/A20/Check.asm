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

// This function checks the A20 line status by observing if memory wraps around
// at 1 MiB.
.global I8086.A20.Check
I8086.A20.Check:
    // This function checks the status of the A20 line by observing the effect
    // of writing a byte value at the edge of memory. If the word wraps around
    // to the start of memory, then the A20 line is disabled. We start by
    // storing some state.
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
    // byte of memory after 1 MiB of total memory.
    xor ax, ax
    mov es, ax
    not ax
    mov ds, ax

    // Next we set two index registers, the destination index register and the
    // source index register, to 0x0500 and 0x0510, respectively. These
    // registers have values that are a total of 16 bytes apart, which happens
    // to be the values required to wrap around memory on machines without the
    // A20 line enabled (in conjunction with the segment registers to form a
    // segment:offset pair). Hence, when the A20 line is disabled, the memory
    // location 0x0000:0x0500 is the same as the memory location 0xFFFF:0x0510.
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
    mov byte ptr ds:[si], 0xff
    cmp byte ptr es:[di], 0xff

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
        