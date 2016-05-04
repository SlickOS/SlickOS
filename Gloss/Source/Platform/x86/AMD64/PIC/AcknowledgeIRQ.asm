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

.global AMD64_PIC_AcknowledgeIRQ
AMD64_PIC_AcknowledgeIRQ:
.global AMD64.PIC.AcknowledgeIRQ
AMD64.PIC.AcknowledgeIRQ:
	push rax

	mov al, 0x20
	out 0x20, al

    cmp rdi, 0x08
    jl AMD64.PIC.AcknowledgeIRQ.Done

    AMD64.PIC.AcknowledgeIRQ.Slave:
    	out 0xA0, al

    AMD64.PIC.AcknowledgeIRQ.Done:
	    pop rax
	    ret
	    