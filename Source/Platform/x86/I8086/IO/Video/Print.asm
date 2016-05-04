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

// The following function prints a single character to the video card.
.global I8086.IO.Video.Print
I8086.IO.Video.Print:
    // The first thing we do is store some state.
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp

    // Next we check if we have a newline charcater (0x0A). If so, we have to
    // print an additional character, 0x0D, to the screen at the same time.
    cmp al, 0x0A
    jne I8086.IO.Video.Print.Output

    I8086.IO.Video.Print.NewLine:
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
