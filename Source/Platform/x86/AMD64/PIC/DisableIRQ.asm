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

// This code will be executed in a 64 bit long mode environment.
.code64

// This code is located in the .TEXT (executable) section of the executable.
.section .text

.global AMD64_PIC_DisableIRQ
AMD64_PIC_DisableIRQ:
.global AMD64.PIC.DisableIRQ
AMD64.PIC.DisableIRQ:
    push rax
    push rbx
    push rcx
    push rdx
    push rdi

    cmp rdi, 0x08
    jl AMD64.PIC.DisableIRQ.Master

    AMD64.PIC.DisableIRQ.Slave:
        mov dx, 0xA1
        sub rdi, 0x08
        jmp AMD64.PIC.DisableIRQ.Mask

    AMD64.PIC.DisableIRQ.Master:
        mov dx, 0x21

    AMD64.PIC.DisableIRQ.Mask:
        in al, dx
        mov bx, 0x01
        mov cx, di
        shl bx, cl
        or al, bl
        out dx, al

    pop rdi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret
