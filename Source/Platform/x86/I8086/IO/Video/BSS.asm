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

// This code is located in the .BSS (uninitialized variable) section of the
// executable.
.section .bss

// This variable stores the current flags associated with the video card.
.global BSS.IO.Video.Flags
BSS.IO.Video.Flags:                                 .skip 1, 0x00

.global BSS.IO.Video.DisplayPage
BSS.IO.Video.DisplayPage:                           .skip 1, 0x00

.global BSS.IO.Video.State
BSS.IO.Video.State:
    .global BSS.IO.Video.State.StaticTable
    BSS.IO.Video.State.StaticTable:                 .skip 4, 0x00
    .global BSS.IO.Video.State.VideoMode
    BSS.IO.Video.State.VideoMode:                   .skip 1, 0x00
    .global BSS.IO.Video.State.Display.Columns
    BSS.IO.Video.State.Display.Columns:             .skip 2, 0x00
    .global BSS.IO.Video.State.RegenBuffer.Length
    BSS.IO.Video.State.RegenBuffer.Length:          .skip 2, 0x00
    .global BSS.IO.Video.State.RegenBuffer.Address
    BSS.IO.Video.State.RegenBuffer.Address:         .skip 2, 0x00
    .global BSS.IO.Video.State.Cursor.Page0
    BSS.IO.VIdeo.State.Cursor.Page0:                .skip 2, 0x00
    .global BSS.IO.Video.State.Cursor.Page1
    BSS.IO.VIdeo.State.Cursor.Page1:                .skip 2, 0x00
    .global BSS.IO.Video.State.Cursor.Page2
    BSS.IO.VIdeo.State.Cursor.Page2:                .skip 2, 0x00
    .global BSS.IO.Video.State.Cursor.Page3
    BSS.IO.VIdeo.State.Cursor.Page3:                .skip 2, 0x00
    .global BSS.IO.Video.State.Cursor.Page4
    BSS.IO.VIdeo.State.Cursor.Page4:                .skip 2, 0x00
    .global BSS.IO.Video.State.Cursor.Page5
    BSS.IO.VIdeo.State.Cursor.Page5:                .skip 2, 0x00
    .global BSS.IO.Video.State.Cursor.Page6
    BSS.IO.VIdeo.State.Cursor.Page6:                .skip 2, 0x00
    .global BSS.IO.Video.State.Cursor.Page7
    BSS.IO.VIdeo.State.Cursor.Page7:                .skip 2, 0x00
    .global BSS.IO.Video.State.Cursor.Type
    BSS.IO.VIdeo.State.Cursor.Type:                 .skip 2, 0x00
    .global BSS.IO.Video.State.ActiveDisplayPage
    BSS.IO.Video.State.ActiveDisplayPage:           .skip 1, 0x00
    .global BSS.IO.Video.State.CRTCPortAddress
    BSS.IO.Video.State.CRTCPortAddress:             .skip 2, 0x00
    .global BSS.IO.Video.State.PortSetting.P03x8
    BSS.IO.Video.State.PortSetting.P03x8:           .skip 1, 0x00
    .global BSS.IO.Video.State.PortSetting.P03x9
    BSS.IO.Video.State.PortSetting.P03x9:           .skip 1, 0x00
    .global BSS.IO.Video.State.Display.Rows
    BSS.IO.Video.State.Display.Rows:                .skip 1, 0x00
    .global BSS.IO.Video.State.BytesPerCharacter
    BSS.IO.Video.State.BytesPerCharacter:           .skip 2, 0x00
    .global BSS.IO.Video.State.Display.Code
    BSS.IO.Video.State.Display.Code:                .skip 1, 0x00
    .global BSS.IO.Video.State.Display.Code.Alt
    BSS.IO.Video.State.Display.Code.Alt:            .skip 1, 0x00
    .global BSS.IO.Video.State.Display.Colors
    BSS.IO.Video.State.Display.Colors:              .skip 2, 0x00
    .global BSS.IO.Video.State.Display.Pages
    BSS.IO.Video.State.Display.Pages:               .skip 1, 0x00
    .global BSS.IO.Video.State.Display.ScanLines
    BSS.IO.Video.State.Display.ScanLines:           .skip 1, 0x00
    .global BSS.IO.Video.State.Reserved
    BSS.IO.Video.State.Reserved:                    .skip 21, 0x00
    