.code16
.intel_syntax noprefix

.section .text
.global BootEntry
BootEntry:
    jmp BootStart

BootBlock.OEMIdent:             .ascii "PotatOS "
BootBlock.BytesPerSector:       .word 512
BootBlock.SectorsPerCluster:    .byte 1
BootBlock.ReservedSectors:      .word 1
BootBlock.NumberOfFATs:         .byte 2
BootBlock.RootEntries:          .word 224
BootBlock.TotalSectors:         .word 2880
BootBlock.Media:                .byte 0xF0
BootBlock.SectorsPerFAT:        .word 9
BootBlock.SectorsPerTrack:      .word 18
BootBlock.HeadsPerCylinder:     .word 2
BootBlock.HiddenSectors:        .int 0
BootBlock.TotalSectorsBig:      .int 0
BootBlock.DriveNumber:          .byte 0
BootBlock.Unused:               .byte 0
BootBlock.Signature:            .byte 0x29
BootBlock.Serial:               .int 0x02011997
BootBlock.VolumeLabel:          .ascii "PotatOSBoot"
BootBlock.FileSystem:           .ascii "FAT12   "

Disk.Sector:                    .skip 1, 0x00
Disk.Head:                      .skip 1, 0x00
Disk.Track:                     .skip 1, 0x00
Disk.Base:                      .skip 2, 0x0000
Disk.Cluster:                   .skip 2, 0x0000
FileName:                       .ascii "GLOSS   SYS"

ClusterLBA:
    sub ax, 0x0002
    xor cx, cx
    mov cl, byte ptr [BootBlock.SectorsPerCluster]
    mul cx
    add ax, word ptr [Disk.Base]
    ret

LBACHS:
    xor dx, dx
    div word ptr [BootBlock.SectorsPerTrack]
    inc dl
    mov [Disk.Sector], dl
    xor dx, dx
    div word ptr [BootBlock.HeadsPerCylinder]
    mov [Disk.Head], dl
    mov [Disk.Track], al
    ret

ReadSectors:
    mov di, 0x0005
    ReadSectors.Read:
        push ax
        push bx
        push cx
        call LBACHS
        mov ah, 0x02
        mov al, 0x01
        mov ch, byte ptr [Disk.Track]
        mov cl, byte ptr [Disk.Sector]
        mov dh, byte ptr [Disk.Head]
        mov dl, byte ptr [BootBlock.DriveNumber]
        int 0x13
        jnc ReadSectors.Success
        xor ax, ax
        int 0x13
        dec di
        pop cx
        pop bx
        pop ax
        jnz ReadSectors.Read
        cli
        hlt
    ReadSectors.Success:
        pop cx
        pop bx
        pop ax
        add bx, word ptr [BootBlock.BytesPerSector]
        inc ax
        loop ReadSectors
        ret

BootStart:
    jmp 0x0000:BootMain

BootMain:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    mov byte ptr [BootBlock.DriveNumber], dl

LoadRoot:
    xor cx, cx
    xor dx, dx
    mov ax, 0x0020
    mul word ptr [BootBlock.RootEntries]
    div word ptr [BootBlock.BytesPerSector]
    xchg ax, cx

    mov al, byte ptr [BootBlock.NumberOfFATs]
    mul word ptr [BootBlock.SectorsPerFAT]
    add ax, word ptr [BootBlock.ReservedSectors]
    mov word ptr [Disk.Base], ax
    add word ptr [Disk.Base], cx

    mov bx, 0x7E00
    call ReadSectors

    mov cx, word ptr [BootBlock.RootEntries]
    mov di, 0x7E00

    LoadRoot.Loop:
        push cx
        mov cx, 0x000B
        mov si, offset FileName
        push di
        rep cmpsb
        pop di
        je LoadFAT
        pop cx
        add di, 0x0020
        loop LoadRoot.Loop
        jmp Failure

LoadFAT:

    mov dx, word ptr [di + 0x001A]
    mov word ptr [Disk.Cluster], dx

    xor ax, ax
    mov al, byte ptr [BootBlock.NumberOfFATs]
    mul word ptr [BootBlock.SectorsPerFAT]
    mov cx, ax

    mov ax, word ptr [BootBlock.ReservedSectors]

    mov bx, 0x7E00
    call ReadSectors

    // mov ax, 0x0700
    // mov es, ax
    mov bx, 0x8000
    push bx

LoadImage:

    mov ax, word ptr [Disk.Cluster]
    pop bx
    call ClusterLBA 
    xor cx, cx
    mov cl, byte ptr [BootBlock.SectorsPerCluster]
    call ReadSectors
    push bx

    mov ax, word ptr [Disk.Cluster]
    mov cx, ax
    mov dx, ax
    shr dx, 0x0001
    add cx, dx
    mov bx, 0x7E00
    add bx, cx
    mov dx, word ptr [bx]
    test ax, 0x0001

    jnz LoadImage.Odd

    LoadImage.Even:
        and dx, 0x0FFF
        jmp LoadImage.Done

    LoadImage.Odd:
        shr dx, 0x0004

    LoadImage.Done:
        mov word ptr [Disk.Cluster], dx

        // push dx

        // mov bp, '0'
        // mov di, 'A'
        // sub di, 10

        // push bx
        // mov ax, dx
        // xor dx, dx
        // mov bx, 4096
        // div bx
        // xchg ax, dx
        // push ax
        // mov eax, 0xb8000
        // cmp dl, 9
        // cmovbe bx, bp
        // cmova bx, di
        // add dx, bx
        // mov [eax], dl
        // pop ax
        // xor dx, dx
        // mov bx, 256
        // div bx
        // xchg ax, dx
        // push ax
        // mov eax, 0xb8002
        // cmp dl, 9
        // cmovbe bx, bp
        // cmova bx, di
        // add dx, bx
        // mov [eax], dl
        // pop ax
        // xor dx, dx
        // mov bl, 16
        // div bl
        // xchg ax, dx
        // mov eax, 0xb8004
        // push dx
        // cmp dl, 9
        // cmovbe bx, bp
        // cmova bx, di
        // add dx, bx
        // mov [eax], dl
        // pop dx
        // mov dl, dh
        // cmp dl, 9
        // cmovbe bx, bp
        // cmova bx, di
        // add dx, bx
        // mov eax, 0xb8006
        // mov [eax], dl
        // pop bx

        // pop dx

        cmp dx, 0x0FF0

        jb LoadImage 

        mov eax, 0xb8010
        mov word ptr [eax], 0x4040

        mov eax, 0xb8012
        mov word ptr [eax], 0x4040

        mov eax, 0xb8014
        mov word ptr [eax], 0x4040

        jmp 0x0000:0x8000

Failure:
    xor ah, ah
    mov eax, 0xb8030
    mov word ptr [eax], 0x4040
    cli
    hlt

.org 510
.word 0xaa55
