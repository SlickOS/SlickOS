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

.global AMD64_Console_PutChar
AMD64_Console_PutChar:
.global AMD64.Console.PutChar
AMD64.Console.PutChar:
    push rdx
    push rcx
    push rbx
    push rax
    push rdi

    mov rax, rdi

    xchg rax, rbx
    xor rax, rax

    mov cx, 0x0A0
    mov ax, word ptr [AMD64.Console.CursorY]
    mul cx
    add ax, word ptr [AMD64.Console.CursorX]
    add ax, word ptr [AMD64.Console.CursorX]
    mov rdx, qword ptr [AMD64.Console.VideoMemory]
    add rdx, rax

    xchg rax, rbx
    xor rbx, rbx
    xor rcx, rcx

    mov ch, byte ptr [AMD64.Console.ColorForeground]
    mov bh, byte ptr [AMD64.Console.ColorBackground]
    and ch, 0x0F
    shl bh, 0x04
    or ch, bh
    mov ah, ch

    cmp al, 0x08
    je AMD64.Console.PutChar.HandleBackspace
    cmp al, 0x0A
    je AMD64.Console.PutChar.HandleNewline
    cmp al, 0x0D
    je AMD64.Console.PutChar.HandleCarriageReturn
    cmp al, 0x09
    je AMD64.Console.PutChar.HandleTab
    cmp al, 0x20
    jl AMD64.Console.PutChar.EOL
    jmp AMD64.Console.PutChar.HandleVisible

    AMD64.Console.PutChar.HandleBackspace:
        mov bx, word ptr [AMD64.Console.CursorX]
        test bx, bx
        jz AMD64.Console.PutChar.EOL
        sub word ptr [AMD64.Console.CursorX], 0x02
        sub rdx, 0x02
        mov al, 0x20
        jmp AMD64.Console.PutChar.HandleVisible

    AMD64.Console.PutChar.HandleNewline:
        inc word ptr [AMD64.Console.CursorY]

    AMD64.Console.PutChar.HandleCarriageReturn:
        mov word ptr [AMD64.Console.CursorX], 0x00
        jmp AMD64.Console.PutChar.EOL

    AMD64.Console.PutChar.HandleTab:
        xchg bx, dx
        xchg cx, ax
        mov ax, word ptr [AMD64.Console.CursorX]
        mov dx, word ptr [AMD64.Console.TabWidth]
        div dl
        sub dl, ah
        add word ptr [AMD64.Console.CursorX], dx
        xchg cx, ax
        xchg bx, dx
        jmp AMD64.Console.PutChar.EOL

    AMD64.Console.PutChar.HandleVisible:
        mov byte ptr [rdx], al
        mov byte ptr [rdx + 0x01], ah
        inc word ptr [AMD64.Console.CursorX]

    AMD64.Console.PutChar.EOL:
        cmp word ptr [AMD64.Console.CursorX], 0x50
        jl AMD64.Console.PutChar.Scroll
        mov word ptr [AMD64.Console.CursorX], 0x00
        inc word ptr [AMD64.Console.CursorY]

    AMD64.Console.PutChar.Scroll:
        cmp word ptr [AMD64.Console.CursorY], 0x19
        jl AMD64.Console.PutChar.Done
        call AMD64.Console.Scroll

    AMD64.Console.PutChar.Done:
        pop rdi
        pop rax
        pop rbx
        pop rcx
        pop rdx

        ret
