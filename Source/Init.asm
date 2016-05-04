//===========================================================================//
// Generic Loader for Operating System Software (GLOSS)                      //
// Boot Sector Initialization                                                //
//                                                                           //
// Copyright 2015-2016 - Adrian J. Collado         <acollado@polaritech.com> //
// All Rights Reserved                                                       //
//                                                                           //
// This file is licensed under the MIT license, see the LICENSE file in the  //
// root of this project for more information. If this file was not included  //
// with the this project, see http://choosealicense.com/licenses/mit.        //
//===========================================================================//

// Seeing as how AT&T assembly syntax is much more obscure and difficult to
// read than Intel assembly syntax, the assembly language code in this project
// for x86 based architectures will be using Intel syntax.
.intel_syntax noprefix

// This code will be executed in a 16 bit real mode environment.
.code16

// This code is located in the .TEXT (executable) section of the binary.
.section .text

.global BootEntry
BootEntry:
        jmp BootStart

BootBlock.OEMIdentifier:            .skip   0x08, 0x00
BootBlock.BytesPerSector:           .word   0x0000
BootBlock.SectorsPerCluster:        .byte   0x00
BootBlock.ReservedSectors:          .word   0x0000
BootBlock.NumberOfFATs:             .byte   0x00
BootBlock.RootEntries:              .word   0x0000
BootBlock.TotalSectors:             .word   0x0000
BootBlock.Media:                    .byte   0x00
BootBlock.SectorsPerFAT:            .word   0x0000
BootBlock.SectorsPerTrack:          .word   0x0000
BootBlock.HeadsPerCylinder:         .word   0x0000
BootBlock.HiddenSectors:            .int    0x00000000
BootBlock.TotalSectorsLarge:        .int    0x00000000
BootBlock.SectorsPerFATLarge:       .int    0x00000000
BootBlock.Flags:                    .word   0x0000
BootBlock.VersionNumber:            .word   0x0000
BootBlock.RootDirectoryCluster:     .int    0x00000000
BootBlock.FileSystemInfoSector:     .word   0x0000
BootBlock.BackupBootSector:         .word   0x0000
BootBlock.Reserved:                 .skip   0x0C, 0x00
BootBlock.DriveNumber:              .byte   0x00
BootBlock.NTFlags:                  .byte   0x00
BootBlock.Signature:                .byte   0x00
BootBlock.Serial:                   .int    0x00000000
BootBlock.VolumeLabel:              .skip   0x0B, 0x00
BootBlock.FileSystem:               .skip   0x08, 0x00

BootStart:
    jmp 0x0000:BootReal

BootReal:
        xor ax, ax
        mov ds, ax
        mov es, ax
        mov fs, ax
        mov gs, ax
        mov ss, ax
        mov sp, 0x7C00

        mov [BootBlock.DriveNumber], dl

        mov si, [BootBlock.DriveNumber]
        mov di, 0x7E00
        mov ax, 0x0001
        xor bx, bx
        xor dx, dx
        mov cx, 0x10
        call I8086.Storage.Load
        test ax, 0x01
        jnz BootReal.Failure

        call I8086.Memory.ClearBSS
        call I8086.IO.Init
        call I8086.IO.Clear
//        call I8086.CPU.Query
        call I8086.A20.Enable
        call I8086.Memory.Map

        call I8086.GDT32.Load

        cli
        mov eax, cr0
        or al, 0x01
        mov cr0, eax


        jmp 0x08:BootProtected

BootReal.Failure:
    mov eax, 0xb8000
    mov [eax], word ptr 0x4080
    cli
    hlt

.include "Platform/x86/I8086/Storage/Load.inc"
.include "Platform/x86/I8086/Memory/A20/Check.inc"
.include "Platform/x86/I8086/Memory/A20/Toggle/BIOS.inc"
.include "Platform/x86/I8086/Memory/A20/Toggle/Fast.inc"
.include "Platform/x86/I8086/Memory/A20/Toggle/PS2.inc"
.include "Platform/x86/I8086/Memory/A20/Toggle.inc"
.include "Platform/x86/I8086/Memory/A20/Enable.inc"
.include "Platform/x86/I8086/Memory/A20/Disable.inc"

.org 510
.word 0xAA55

.include "Platform/x86/I8086/Memory/Map/E820.inc"
.include "Platform/x86/I8086/Memory/Map.inc"
.include "Platform/x86/I8086/Memory/ClearBSS.inc"

// This function initializes the first serial port (COM1) at 9600 baud with no
// parity, one stop bit, and eight data bits.
I8086.IO.Serial.Init:
    xor dx, dx
    mov ax, 0x00E3
    int 0x14
    or word ptr [BSS.IO.Serial.Flags], 0x0001
    ret

// This function prints a single character to the first serial port (COM1).
I8086.IO.Serial.Print:
    // The first thing we do is store some state.
    push ax
    push dx

    // Next, we clear the dx register as 0x00 in the dx register corresponds to
    // the first serial port. We then invoke the interrupt required to send
    // data using the serial port.
    xor dx, dx
    mov ah, 0x01
    int 0x14

    // We finally restore state and return to the calling function.
    pop dx
    pop ax
    ret

// This function initialized the video card to an 80x25 character text mode
// with blinking disabled and 4 bits of foreground and 4 bits of background
// color.
I8086.IO.Video.Init:
    // The first thing we do is store the pre-function state, as we dont want
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
    // what move the video card is currently in, and if we have to change any
    // of its properties. If the function failes, we assume the mode is not
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

    // Next we check the number of columns. Wer want 80 (0x50) columns, so we
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

    // If we reach this point, we will be resetting the video card's current
    // mode.
    I8086.IO.Video.Init.Reset:
        // Now we will set the video card's mode to mode 3.
        mov ax, 0x0003
        int 0x10

    // Now we will set additional properties of the video card, as they are
    // almost guaranteed to be incorrect.
    I8086.IO.Video.Init.SetProperties:
        // A few of the undesirable properties of the video card are that the
        // card most likely begins with a cursor enabled, and with the highest
        // bit of the background color dedicated to a 'blink' mode. As we don't
        // want either of these, we'll start by getting rid of the cursor.
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

// The follwoing function initialized all forms of IO that the primary boot
// sector can utilize.
I8086.IO.Init:
    // We first initialize the first serial port (COM1).
    call I8086.IO.Serial.Init

    // We next initialize the video card.
    call I8086.IO.Video.Init

    // Now we return to the calling function.
    ret

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

// The following function prints a null terminated string to all initialized
// forms of IO available to the primary boot sector.
I8086.IO.Print.String:
    // We first store some state.
    push ax
    push si
    pushf

    // Since we want to print each character one by one, we simply load each
    // byte one by one and push it to the character printing function. This
    // requires, however, that the direction flag is clear so we read the
    // correct memory.
    cld

    I8086.IO.Print.String.Execute:
        // We load a byte from the string. If it is null, then we are done
        // printing the string.
        lodsb
        test al, al
        jne I8086.IO.Print.String.Done

        // Now we simply call the character printing function.
        call I8086.IO.Print.Char

        // Now we load the next byte from the string, and continue.
        jmp I8086.IO.Print.String.Execute

    I8086.IO.Print.String.Done:
        // We finally restore state and exit to the calling function.
        popf
        pop si
        pop ax

        ret

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

// The following function loads the 32 bit GDT and installs it using the 'lgdt'
// instruction.
I8086.GDT32.Load:
    cli
    pusha
    lgdt [I8086.GDT32.Pointer]
    sti
    popa
    ret

// This code will be executed in a 32 bit protected mode environment.
.code32

BootProtected:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov eax, 0xb8000
    mov [eax], word ptr 0x4040

    cli
    hlt

// The following code is located in the .DATA (initialized variable) section of
// the binary.
.section .data

I8086.GDT32:
    I8086.GDT32.Null:
        I8086.GDT32.Null.Limit.Low:                     .word   0x0000
        I8086.GDT32.Null.Base.Low:                      .word   0x0000
        I8086.GDT32.Null.Base.Middle:                   .byte   0x00
        I8086.GDT32.Null.Access:                        .byte   0x00
        I8086.GDT32.Null.Flags:                         .byte   0x00
        I8086.GDT32.Null.Base.High:                     .byte   0x00
    I8086.GDT32.Code:
        I8086.GDT32.Code.Limit.Low:                     .word   0xFFFF
        I8086.GDT32.Code.Base.Low:                      .word   0x0000
        I8086.GDT32.Code.Base.Middle:                   .byte   0x00
        I8086.GDT32.Code.Access:                        .byte   0x9A
        I8086.GDT32.Code.Flags:                         .byte   0xCF
        I8086.GDT32.Code.Base.High:                     .byte   0x00
    I8086.GDT32.Data:
        I8086.GDT32.Data.Limit.Low:                     .word   0xFFFF
        I8086.GDT32.Data.Base.Low:                      .word   0x0000
        I8086.GDT32.Data.Base.Middle:                   .byte   0x00
        I8086.GDT32.Data.Access:                        .byte   0x92
        I8086.GDT32.Data.Flags:                         .byte   0xCF
        I8086.GDT32.Data.Base.High:                     .byte   0x00
    I8086.GDT32.Pointer:
//        .equ I8086.GDT32.Size, (I8086.GDT32.Pointer - I8086.GDT32 - 1)
        I8086.GDT32.Pointer.Limit:                      .word   (I8086.GDT32.Pointer - I8086.GDT32 - 1)
        I8086.GDT32.Pointer.Base:                       .int    I8086.GDT32

// The following code is located in the .RODATA (constant data) section of the
// binary.
.section .rodata

Message.ProductName:    .asciz "SLICK OS"

// The following code is located in the .BSS (uninitialized variable) section
// of the binary.
.section .bss

BSS.IO.Serial:
    BSS.IO.Serial.Flags:                                    .skip 0x01, 0x00
BSS.IO.Video:
    BSS.IO.Video.Flags:                                     .skip 0x01, 0x00
    BSS.IO.Video.DisplayPage:                               .skip 0x01, 0x00
    BSS.IO.Video.State:
        BSS.IO.Video.State.StaticTable:                     .skip 0x04, 0x00
        BSS.IO.Video.State.VideoMode:                       .skip 0x01, 0x00
        BSS.IO.Video.State.Display.Columns:                 .skip 0x02, 0x00
        BSS.IO.Video.State.RegenBuffer.Length:              .skip 0x02, 0x00
        BSS.IO.Video.State.RegenBuffer.Address:             .skip 0x02, 0x00
        BSS.IO.Video.State.Cursor.Page0:                    .skip 0x02, 0x00
        BSS.IO.Video.State.Cursor.Page1:                    .skip 0x02, 0x00
        BSS.IO.Video.State.Cursor.Page2:                    .skip 0x02, 0x00
        BSS.IO.Video.State.Cursor.Page3:                    .skip 0x02, 0x00
        BSS.IO.Video.State.Cursor.Page4:                    .skip 0x02, 0x00
        BSS.IO.Video.State.Cursor.Page5:                    .skip 0x02, 0x00
        BSS.IO.Video.State.Cursor.Page6:                    .skip 0x02, 0x00
        BSS.IO.Video.State.Cursor.Page7:                    .skip 0x02, 0x00
        BSS.IO.Video.State.Cursor.Type:                     .skip 0x02, 0x00
        BSS.IO.Video.State.ActiveDisplayPage:               .skip 0x01, 0x00
        BSS.IO.Video.State.CRTCPortAddress:                 .skip 0x02, 0x00
        BSS.IO.Video.State.PortSetting.P03x8:               .skip 0x01, 0x00
        BSS.IO.Video.State.PortSetting.P03x9:               .skip 0x01, 0x00
        BSS.IO.Video.State.Display.Rows:                    .skip 0x01, 0x00
        BSS.IO.Video.State.BytesPerCharacter:               .skip 0x02, 0x00
        BSS.IO.Video.State.Display.Code:                    .skip 0x01, 0x00
        BSS.IO.Video.State.Display.Code.Alternate:          .skip 0x01, 0x00
        BSS.IO.Video.State.Display.Colors:                  .skip 0x02, 0x00
        BSS.IO.Video.State.Display.Pages:                   .skip 0x01, 0x00
        BSS.IO.Video.State.Display.ScanLines:               .skip 0x01, 0x00
        BSS.IO.Video.State.Reserved:                        .skip 0x15, 0x00
BSS.Memory:
    BSS.Memory.Map:
        BSS.Memory.Map.Address:                             .skip 0x08, 0x00
        BSS.Memory.Map.Count:                               .skip 0x08, 0x00
        BSS.Memory.Map.End:                                 .skip 0x08, 0x00
BSS.A20:
    BSS.A20.Status:                                         .skip 0x01, 0x00

// vim: set ft=intelasm:
