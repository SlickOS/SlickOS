//===========================================================================//
// Generic Loader for Operating System Software (GLOSS)                      //
//                                                                           //
// Copyright (C) 2015-2016 - Adrian J. Collado     <acollado@polaritech.net> //
//===========================================================================//
.ifndef X86_I8086_IO_VIDEO_PRINT_INC
.equ X86_I8086_IO_VIDEO_PRINT_INC, 0x01

// Seeing how AT&T assembly syntax is much more verbose than Intel assembly
// syntax, the assembly language code in this project will use Intel syntax.
.intel_syntax noprefix

// This code will be executed in a 16 bit real mode environment.
.code16

// This code is located in the .TEXT (executable) section of the binary.
.section .text

// The following function prints a single character to the video card.
I8086.IO.Video.Print:
    // The first thing we do is store some state.
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp

    // Next we check if we have a newline character (0x0A). If so, we have to
    // print an additional character, the carriage return (0x0D), to the screen
    // at the same time.
    cmp al, 0x0A
    jne I8086.IO.Video.Print.Output

    I8086.IO.Video.Print.Newline:
        // Now we print the character using the BIOS.
        mov ah, 0x0E
        mov bh, [BSS.IO.Video.DisplayPage]
        int 0x10
        mov al, 0x0D

    I8086.IO.Video.Print.Output:
        // Now we print the character using the BIOS.
        mov ah, 0x0E
        mov bh, [BSS.IO.Video.DisplayPage]
        int 0x10

    // We finally restore state and return to the calling function.
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    
    ret

.endif
// vim: set ft=intelasm:
