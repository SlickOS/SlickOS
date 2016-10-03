//===========================================================================//
// Generic Loader for Operating System Software (GLOSS)                      //
//                                                                           //
// Copyright (C) 2015-2016 - Adrian J. Collado     <acollado@polaritech.net> //
//===========================================================================//
.ifndef X86_I8086_IO_VIDEO_BSS_INC
.equ X86_I8086_IO_VIDEO_BSS_INC, 0x01

// Seeing how AT&T assembly syntax is much more verbose than Intel assembly
// syntax, the assembly language code in this project will use Intel syntax.
.intel_syntax noprefix

// This code will be executed in a 16 bit real mode environment.
.code16

// The following code is located in the .BSS (uninitialized variable) section
// of the binary.
.section .bss

.global BSS.IO.Video
BSS.IO.Video:
    .global BSS.IO.Video.Flags
    BSS.IO.Video.Flags:                                     .skip 0x01, 0x00
    .global BSS.IO.Video.DisplayPage
    BSS.IO.Video.DisplayPage:                               .skip 0x01, 0x00
    .global BSS.IO.Video.State
    BSS.IO.Video.State:
        .global BSS.IO.Video.State.StaticTable
        BSS.IO.Video.State.StaticTable:                     .skip 0x04, 0x00
        .global BSS.IO.Video.State.VideoMode
        BSS.IO.Video.State.VideoMode:                       .skip 0x01, 0x00
        .global BSS.IO.Video.State.Display.Columns
        BSS.IO.Video.State.Display.Columns:                 .skip 0x02, 0x00
        .global BSS.IO.Video.State.RegenBuffer.Length
        BSS.IO.Video.State.RegenBuffer.Length:              .skip 0x02, 0x00
        .global BSS.IO.Video.State.RegenBuffer.Address
        BSS.IO.Video.State.RegenBuffer.Address:             .skip 0x02, 0x00
        .global BSS.IO.Video.State.Cursor.Page0
        BSS.IO.Video.State.Cursor.Page0:                    .skip 0x02, 0x00
        .global BSS.IO.Video.State.Cursor.Page1
        BSS.IO.Video.State.Cursor.Page1:                    .skip 0x02, 0x00
        .global BSS.IO.Video.State.Cursor.Page2
        BSS.IO.Video.State.Cursor.Page2:                    .skip 0x02, 0x00
        .global BSS.IO.Video.State.Cursor.Page3
        BSS.IO.Video.State.Cursor.Page3:                    .skip 0x02, 0x00
        .global BSS.IO.Video.State.Cursor.Page4
        BSS.IO.Video.State.Cursor.Page4:                    .skip 0x02, 0x00
        .global BSS.IO.Video.State.Cursor.Page5
        BSS.IO.Video.State.Cursor.Page5:                    .skip 0x02, 0x00
        .global BSS.IO.Video.State.Cursor.Page6
        BSS.IO.Video.State.Cursor.Page6:                    .skip 0x02, 0x00
        .global BSS.IO.Video.State.Cursor.Page7
        BSS.IO.Video.State.Cursor.Page7:                    .skip 0x02, 0x00
        .global BSS.IO.Video.State.Cursor.Type
        BSS.IO.Video.State.Cursor.Type:                     .skip 0x02, 0x00
        .global BSS.IO.Video.State.ActiveDisplayPage
        BSS.IO.Video.State.ActiveDisplayPage:               .skip 0x01, 0x00
        .global BSS.IO.Video.State.CRTCPortAddress
        BSS.IO.Video.State.CRTCPortAddress:                 .skip 0x02, 0x00
        .global BSS.IO.Video.State.PortSetting.P03x8
        BSS.IO.Video.State.PortSetting.P03x8:               .skip 0x01, 0x00
        .global BSS.IO.Video.State.PortSetting.P03x9
        BSS.IO.Video.State.PortSetting.P03x9:               .skip 0x01, 0x00
        .global BSS.IO.Video.State.Display.Rows
        BSS.IO.Video.State.Display.Rows:                    .skip 0x01, 0x00
        .global BSS.IO.Video.State.BytesPreCharacter
        BSS.IO.Video.State.BytesPerCharacter:               .skip 0x02, 0x00
        .global BSS.IO.Video.State.Display.Code
        BSS.IO.Video.State.Display.Code:                    .skip 0x01, 0x00
        .global BSS.IO.Video.State.Display.Code.Alternate
        BSS.IO.Video.State.Display.Code.Alternate:          .skip 0x01, 0x00
        .global BSS.IO.Video.State.Display.Colors
        BSS.IO.Video.State.Display.Colors:                  .skip 0x02, 0x00
        .global BSS.IO.Video.State.Display.Pages
        BSS.IO.Video.State.Display.Pages:                   .skip 0x01, 0x00
        .global BSS.IO.Video.State.Display.ScanLines
        BSS.IO.Video.State.Display.ScanLines:               .skip 0x01, 0x00
        .global BSS.IO.Video.State.Reserved
        BSS.IO.Video.State.Reserved:                        .skip 0x15, 0x00

.endif
// vim: set ft=intelasm:
