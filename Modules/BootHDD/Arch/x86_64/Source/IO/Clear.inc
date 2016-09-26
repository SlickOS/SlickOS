//===========================================================================//
// Generic Loader for Operating System Software (GLOSS)                      //
//                                                                           //
// Copyright (C) 2015-2016 - Adrian J. Collado     <acollado@polaritech.net> //
//===========================================================================//
.ifndef X86_I8086_IO_CLEAR_INC
.equ X86_I8086_IO_CLEAR_INC, 0x01

// Seeing how AT&T assembly syntax is much more verbose than Intel assembly
// syntax, the assembly language code in this project will use Intel syntax.
.intel_syntax noprefix

// This code will be executed in a 16 bit real mode environment.
.code16

// This code is located in the .TEXT (executable) section of the binary.
.section .text

// This function simply clears an 80x25 region of text (equivalent to a full
// video screen in text mode 3).
I8086.IO.Clear:
    // We first store some state.
    push ax
    push cx

    // We are going to print a total of 2000 characters, so we store that in
    // the counter register.
    mov cx, 2000

    I8086.IO.Clear.Loop:
        // Now we simply print 2000 spaces.
        mov al, 0x20
        call I8086.IO.Print.Char
        loop I8086.IO.Clear.Loop

    I8086.IO.Clear.Cursor:
        // Now we check if the video card is enabled. If it is, we move the
        // cursor to the top left of the screen.
        test byte ptr [BSS.IO.Video.Flags], 0x01
        je I8086.IO.Clear.Done
        mov ah, 0x02
        mov bh, [BSS.IO.Video.DisplayPage]
        xor dx, dx
        int 0x10

    I8086.IO.Clear.Done:
        // Now we restore state and return to the calling function.
        pop cx
        pop ax

        ret

.endif
// vim: set ft=intelasm:
