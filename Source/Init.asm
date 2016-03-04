.intel_syntax noprefix
.code16

.section .text

BootReal:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov sp, 0x7C00

    mov cx, SECTION_BSS_SIZE
    mov di, SECTION_BSS_START
    cld
    rep stosb

    call I8086.IO.Init
    call I8086.IO.Clear

    mov di, 0x3000
    call I8086.Memory.Map

    call I8086.GDT32.Load

    cli
    mov eax, cr0
    or al, 0x01
    mov cr0, eax

    jmp 0x08:BootProtected

.code32
BootProtected:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov edi, 0x100000
    mov cr3, edi
    xor eax, eax
    mov ecx, 0x1000
    rep stosd
    mov edi, cr3

    mov dword ptr [edi], 0x101003
    add edi, 0x1000
    mov dword ptr [edi], 0x102003
    add edi, 0x1000
    mov dword ptr [edi], 0x103003
    add edi, 0x1000

    mov ebx, 0x00000003
    mov ecx, 0x00000200

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

    call AMD64.Console.Init

    cli

    call AMD64.IDT.Init
    call AMD64.IDT.Load
    call AMD64.PIC.Init

    sti

    // mov rdi, 0x123456789ABCDEF0
    // call AMD64.Console.PrintHex8
    // call AMD64.Console.PrintHex16
    // call AMD64.Console.PrintHex32
    // call AMD64.Console.PrintHex64

    // int 0x29

    // mov rax, 0xB8012;
    // mov word ptr [rax], 0x8888;

    // mov rax, qword ptr [BSS.Memory.Map.Count]
    // mov qword ptr [BootInfo.MemoryMapCount], rax
    // mov rax, qword ptr [BSS.Memory.Map.Address]
    // mov qword ptr [BootInfo.MemoryMapAddress], rax
    // mov rax, offset GDT64
    // mov qword ptr [BootInfo.GDTAddress], rax
    // mov rax, 0x0000000000009000
    // mov qword ptr [BootInfo.PML4Address], rax

    // mov rdi, offset [BootInfo]

    // mov rdi, qword ptr [BSS.Memory.Map.Count]
    // mov rsi, qword ptr [BSS.Memory.Map.Address]
    // mov rdx, qword ptr [0x1000]
    // mov rcx, qword ptr [0x1008]
    // mov r8, qword ptr [0x1010]
    
    // Cuz' why the fuck not?
    // Trippy:
    //     mov ecx, 1000
    //     mov edi, 0x000b8000
    //     mov eax, 0x9abcdef0
    //     cld
    //     rep stosd
    //     mov ecx, 1000
    //     mov edi, 0x000b8000
    //     mov eax, 0x12345678
    //     cld
    //     rep stosd
    //     jmp Trippy

    call GlossMain

    cli
    hlt
    