//===========================================================================//
// Generic Loader for Operating System Software (GLOSS)                      //
//                                                                           //
// Copyright (C) 2015-2016 - Adrian J. Collado     <acollado@polaritech.net> //
//===========================================================================//
.ifndef X86_I8086_IO_PRINT_CHAR_INC
.equ X86_I8086_IO_PRINT_CHAR_INC, 0x01

// Seeing how AT&T assembly syntax is much more verbose than Intel assembly
// syntax, the assembly language code in this project will use Intel syntax.
.intel_syntax noprefix

// This code will be executed in a 16 bit real mode environment.
.code16

// This code is located in the .TEXT (executable) section of the binary.
.section .text

// The following function prints a character using all forms of IO available to
// the primary boot sector.
I8086.IO.Print.Char:
    I8086.IO.Print.Char.Serial:
        // We check if the serial port has been enabled and skip printing if it
        // is not. Otherwise, we output a character through the serial port.
        test byte ptr [BSS.IO.Serial.Flags], 0x01
        je I8086.IO.Print.Char.Video
        call I8086.IO.Serial.Print

    I8086.IO.Print.Char.Video:
        // We check if the video card has been enabled and skip printing if it
        // is not. Otherwise, we output a character through the video card.
        test byte ptr [BSS.IO.Video.Flags], 0x01
        je I8086.IO.Print.Char.Done
        call I8086.IO.Video.Print

    I8086.IO.Print.Char.Done:
        // We finally return to the calling function.
        ret

.endif
// vim: set ft=intelasm:
