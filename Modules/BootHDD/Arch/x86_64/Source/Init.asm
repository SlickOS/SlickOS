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

.include "i8086/Storage/FileSystem/FAT32/BootBlock.inc"
.include "i8086/Storage/BIOS/HDD/Load.inc"
.include "i8086/Memory/ClearBSS.inc"
.include "i8086/IO/Init.inc"
.include "i8086/IO/Clear.inc"
.include "i8086/IO/Print/Char.inc"
.include "i8086/IO/Print/String.inc"
.include "i8086/IO/Serial/BSS.inc"
.include "i8086/IO/Serial/Init.inc"
.include "i8086/IO/Serial/Print.inc"
.include "i8086/IO/Video/BSS.inc"
.include "i8086/IO/Video/Init.inc"
.include "i8086/IO/Video/Print.inc"

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

        cmp byte ptr [BSS.A20.Status], 0x01
        jne BootReal.Failure

        lea si, [Message.ProductName]
        call I8086.IO.Print.String

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

.include "i8086/CPU/GDT32/Data.inc"
.include "i8086/CPU/GDT32/Load.inc"
.include "i8086/CPU/Query.inc"
.include "i8086/Memory/A20/BSS.inc"
.include "i8086/Memory/A20/Check.inc"
.include "i8086/Memory/A20/Disable.inc"
.include "i8086/Memory/A20/Enable.inc"
.include "i8086/Memory/A20/Toggle.inc"
.include "i8086/Memory/A20/Toggle/BIOS.inc"
.include "i8086/Memory/A20/Toggle/Fast.inc"
.include "i8086/Memory/A20/Toggle/PS2.inc"
.include "i8086/Memory/Map.inc"
.include "i8086/Memory/Map/BSS.inc"
.include "i8086/Memory/Map/E820.inc"

// This code will be executed in a 32 bit protected mode environment.
.code32

BootProtected:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov edi, 0x2000000
    mov cr3, edi
    xor eax, eax
    mov ecx, 0x1000
    rep stosd
    mov edi, cr3

    mov dword ptr [edi], 0x2001003
    add edi, 0x1000
    mov dword ptr [edi], 0x2002003
    add edi, 0x1000

    mov ebx, 0x2003003
    mov ecx, 0x0200

    SetTEntry:
        mov dword ptr [edi], ebx
        add ebx, 0x1000
        add edi, 0x0008
        loop SetTEntry

    mov ebx, 0x00000003
    mov ecx, 0x00040000

    SetEntry:
        mov dword ptr [edi], ebx
        add ebx, 0x1000
        add edi, 0x0008
        loop SetEntry

    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    lgdt [GDT64.End]
    jmp 0x08:BootLong

GDT64:
GDT64.Null:
    .word 0x0000
    .word 0x0000
    .byte 0x00
    .byte 0x00
    .byte 0x00
    .byte 0x00
GDT64.Code:
    .word 0x0000
    .word 0x0000
    .byte 0x00
    .byte 0x9A
    .byte 0x20
    .byte 0x00
GDT64.Data:
    .word 0x0000
    .word 0x0000
    .byte 0x00
    .byte 0x92
    .byte 0x00
    .byte 0x00
GDT64.End:
    .word (GDT64.End - GDT64 - 1)
    .quad GDT64

BootInfo:
    BootInfo.MemoryMapCount:        .skip 8, 0x00
    BootInfo.MemoryMapAddress:      .skip 8, 0x00
    BootInfo.GDTAddress:            .skip 8, 0x00
    BootInfo.PML4Address:           .skip 8, 0x00

.code64
BootLong:
    cli
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov rsp, 0x20000

//    call Entry

    cli
    hlt

// The following code is located in the .RODATA (constant data) section of the
// binary.
.section .rodata

Message.ProductName:    .asciz "SlickOS"

// vim: set ft=intelasm:
