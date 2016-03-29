//===========================================================================//
// Generic Loader for Operating System Software (GLOSS)                      //
//                                                                           //
// The purpose of this function is to load additional sectors from the disk  //
// using the BIOS interrupt 0x13 extensions.                                 //
//                                                                           //
// Copyright (C) 2015-2016 - Adrian J. Collado     <acollado@polaritech.net> //
//                                                                           //
// Arguments:                                                                //
//   DX,BX,AX - 48 bit disk LBA (High word DX, Middle word BX, Low word AX)  //
//   ES:DI    - Destination Segment:Offset Pair                              //
//   SI       - Drive Number                                                 //
//   CX       - Number of blocks to transfer (Maximum 0x7F on some BIOSes)   //
// Return:                                                                   //
//   AX       - Status Code                                                  //
//===========================================================================//
.ifndef X86_I8086_STORAGE_LOAD_INC
.equ X86_I8086_STORAGE_LOAD_INC, 0x01

// Seeing how AT&T assembly syntax is much more verbose than Intel assembly
// syntax, the assembly language code in this project will use Intel syntax.
.intel_syntax noprefix

// This code wii be executed in a 16 bit real mode environment.
.code16

// This code is located in the .TEXT (executable) section of the binary.
.section .text

I8086.Storage.Load:
    // First we store the registers that we'll be changing.
    push dx
    push si
    pushf

    // Next we establish our stack frame.
    push bp
    mov bp, sp

    // Now we align the stack to the next lowest two-byte boundary.
    and sp, 0xFFFE

    // Next we construct the Disk Access Packet. We push the structure onto the
    // stack in reverse order, as the stack grows downward.
    push 0x0000
    push dx
    push bx
    push ax
    push es
    push di
    push cx
    push 0x0010

    // Now we load the address of the Disk Access Packet and store it in the SI
    // register. We then load the function number and drive number into the AH
    // and DL registers, respectively.
    xchg si, dx
    mov si, sp
    mov ah, 0x42

    // Now we execute the interrupt. If the function failed, the carry flag
    // will be set, and we will be unable to boot the bootsector.
    int 0x13

    // Now we store the carry flag in the AX register.
    pushf
    pop ax
    // and ax, 0x01

    // We finally reset our stack frame, restore state, and return to the
    // calling function.
    leave
    popf
    pop si
    pop dx
    ret

.endif
// vim: set ft=intelasm:
