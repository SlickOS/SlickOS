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

// This function prints a character using all forms of IO available to the
// primary boot sector.
.global I8086.IO.Print.Char
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
        ret
