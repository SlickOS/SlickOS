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

// This function initializes the video card to an 80x25 character text mode
// with blinking disabled and 4 bits of foreground and 4 bits of background
// color.
.global I8086.IO.Video.Init
I8086.IO.Video.Init:
    // The first thing we do is store the pre-function state, as we don't want
    // to destroy register contents.
    push ax
    push bx
    push cx

    // Now we test if a VGA compatible video card is present using the BIOS
    // function to retrieve the display combination code. If the function
    // returns anything other than 0x1A in the AL register, then the function
    // failed and we do not have a suitable video card.
    mov ax, 0x1A00
    int 0x10
    cmp al, 0x1A
    jne I8086.IO.Video.Init.Done

    // At this point we know we have a video card present, although it may not
    // yet be configured to output anything useful. We thus set the flag for
    // the presence of a video card.
    or byte ptr [BSS.IO.Video.Flags], 0x01

    // Now we get the video state information. This will allow us to determine
    // what mode the video card is currently in, and if we have to change
    // any of its properties. If the function fails, we assume the mode is not
    // correct and we set it to the mode we want.
    mov ax, 0x1B00
    xor bx, bx
    mov di, offset BSS.IO.Video.State
    int 0x10
    cmp al, 0x1B
    jne I8086.IO.Video.Init.Reset

    // Now we check the various properties of the video card. We first check if
    // the current mode is equal to the mode we want, which is 80x25 characters
    // with 16 foreground and background colors. This corresponds to mode 3, so
    // if the mode value doesn't match, we reset the video card.
    cmp byte ptr [BSS.IO.Video.State.VideoMode], 0x03
    jne I8086.IO.Video.Init.Reset

    // Next we check the number of columns. We want 80 (0x50) columns, so we
    // compare the value the video card gave us and reset if necessary.
    cmp byte ptr [BSS.IO.Video.State.Display.Columns], 0x50
    jne I8086.IO.Video.Init.Reset

    // Next we check the number of rows. Apparently, some BIOSes are funky and
    // output the number of rows or the number of rows minus one for the value,
    // so we check for both. If the number matches either then we know that we
    // have the correct video properties and can skip resetting the mode.
    cmp byte ptr [BSS.IO.Video.State.Display.Rows], 0x19
    je I8086.IO.Video.Init.SetProperties
    cmp byte ptr [BSS.IO.Video.State.Display.Rows], 0x18
    je I8086.IO.Video.Init.SetProperties

    I8086.IO.Video.Init.Reset:
        // At this point, the video mode was determined to be incorrect and we
        // thus set it to the proper mode.
        mov ax, 0x0003
        int 0x10

    I8086.IO.Video.Init.SetProperties:
        // Now set a few miscellaneous things in the video card to desirable
        // values. We first disable the cursor, as we don't need it yet since
        // this portion of the bootloader is non-interactive.
        mov ah, 0x01
        mov cx, 0x2D0E
        int 0x10

        // Now we disable blinking, which will give us 16 background colors
        // instead of only 8.
        mov ax, 0x1003
        xor bx, bx
        int 0x10

        // We finally retrieve the current display page, which is necessary to
        // output text to the screen.
        xor bx, bx
        mov ah, 0x0F
        int 0x10
        mov [BSS.IO.Video.DisplayPage], bh

    I8086.IO.Video.Init.Done:
        // We finally restore state and return to the calling function.
        pop cx
        pop bx
        pop ax
        ret
        