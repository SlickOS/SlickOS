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

.include "Storage/FileSystem/FAT32/BootBlock.inc"
.include "Storage/BIOS/HDD/Load.inc"
.include "Memory/ClearBSS.inc"
.include "IO/Init.inc"
.include "IO/Clear.inc"
.include "IO/Print/Char.inc"
.include "IO/Print/String.inc"
.include "IO/Serial/BSS.inc"
.include "IO/Serial/Init.inc"
.include "IO/Serial/Print.inc"
.include "IO/Video/BSS.inc"
.include "IO/Video/Init.inc"
.include "IO/Video/Print.inc"

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
        call I8086.CPU.Query
        call I8086.A20.Enable
        call I8086.Memory.Map

        call I8086.CPU.GDT32.Load

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

.org 510
.word 0xAA55

.include "CPU/GDT32/Data.inc"
.include "CPU/GDT32/Load.inc"
.include "CPU/Query.inc"
.include "Memory/A20/BSS.inc"
.include "Memory/A20/Check.inc"
.include "Memory/A20/Disable.inc"
.include "Memory/A20/Enable.inc"
.include "Memory/A20/Toggle.inc"
.include "Memory/A20/Toggle/BIOS.inc"
.include "Memory/A20/Toggle/Fast.inc"
.include "Memory/A20/Toggle/PS2.inc"
.include "Memory/Map.inc"
.include "Memory/Map/BSS.inc"
.include "Memory/Map/E820.inc"

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

// The following code is located in the .RODATA (constant data) section of the
// binary.
.section .rodata

Message.ProductName:    .asciz "SLICK OS"

// vim: set ft=intelasm:
