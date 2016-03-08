//===========================================================================//
// Generic Loader for Operating System Software (GLOSS)                      //
//                                                                           //
// The purpose of this function is to load additional sectors from the disk  //
// using the BIOS interrupt 0x13 extensions.                                 //
//                                                                           //
// Copyright (C) 2015-2016 - Adrian J. Collado        <acollado@citlink.net> //
//                                                                           //
// Arguments:                                                                //
//   DX,BX,AX - 48 bit disk LBA (High word DX, Middle word BX, Low word AX)  //
//   ES:DI    - Destination Segment:Offset Pair                              //
//   CX       - Number of blocks to transfer (Maximum 0x7F on some BIOSes)   //
// Return:                                                                   //
//   AX       - Status Code                                                  //
//===========================================================================//

// Seeing how AT&T assembly syntax is much more verbose than Intel assembly
// syntax, the assembly language code in this project will use Intel syntax.
.intel_syntax noprefix

// This code wii be executed in a 16 bit real mode environment.
.code16

// This code is located in the .TEXT (executable) section of the binary.
.section .text

I8086.Storage.Load:
    // First, we establish our stack frame.
    push bp
    mov bp, sp

    // Now we align the stack to the next lowest two-byte boundary.
    and sp, 0xFFFC

    

    // We finally reset our stack frame and return to the calling function.
    leave
    ret
