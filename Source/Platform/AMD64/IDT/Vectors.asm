.intel_syntax noprefix
.code64
.section .text

.global ISRCallx00
ISRCallx00:
    cli
    push 0x00
    push 0x00
    jmp ISRCallCommon

.global ISRCallx01
ISRCallx01:
    cli
    push 0x00
    push 0x01
    jmp ISRCallCommon

.global ISRCallx02
ISRCallx02:
    cli
    push 0x00
    push 0x02
    jmp ISRCallCommon

.global ISRCallx03
ISRCallx03:
    cli
    push 0x00
    push 0x03
    jmp ISRCallCommon

.global ISRCallx04
ISRCallx04:
    cli
    push 0x00
    push 0x04
    jmp ISRCallCommon

.global ISRCallx05
ISRCallx05:
    cli
    push 0x00
    push 0x05
    jmp ISRCallCommon

.global ISRCallx06
ISRCallx06:
    cli
    push 0x00
    push 0x06
    jmp ISRCallCommon

.global ISRCallx07
ISRCallx07:
    cli
    push 0x00
    push 0x07
    jmp ISRCallCommon

.global ISRCallx08
ISRCallx08:
    cli
    push 0x08
    jmp ISRCallCommon

.global ISRCallx09
ISRCallx09:
    cli
    push 0x00
    push 0x09
    jmp ISRCallCommon

.global ISRCallx0A
ISRCallx0A:
    cli
    push 0x0A
    jmp ISRCallCommon

.global ISRCallx0B
ISRCallx0B:
    cli
    push 0x0B
    jmp ISRCallCommon

.global ISRCallx0C
ISRCallx0C:
    cli
    push 0x0C
    jmp ISRCallCommon

.global ISRCallx0D
ISRCallx0D:
    cli
    push 0x0D
    jmp ISRCallCommon

.global ISRCallx0E
ISRCallx0E:
    cli
    push 0x0E
    jmp ISRCallCommon

.global ISRCallx0F
ISRCallx0F:
    cli
    push 0x00
    push 0x0F
    jmp ISRCallCommon

.global ISRCallx10
ISRCallx10:
    cli
    push 0x00
    push 0x10
    jmp ISRCallCommon

.global ISRCallx11
ISRCallx11:
    cli
    push 0x11
    jmp ISRCallCommon

.global ISRCallx12
ISRCallx12:
    cli
    push 0x00
    push 0x12
    jmp ISRCallCommon

.global ISRCallx13
ISRCallx13:
    cli
    push 0x00
    push 0x13
    jmp ISRCallCommon

.global ISRCallx14
ISRCallx14:
    cli
    push 0x00
    push 0x14
    jmp ISRCallCommon

.global ISRCallx15
ISRCallx15:
    cli
    push 0x00
    push 0x15
    jmp ISRCallCommon

.global ISRCallx16
ISRCallx16:
    cli
    push 0x00
    push 0x16
    jmp ISRCallCommon

.global ISRCallx17
ISRCallx17:
    cli
    push 0x00
    push 0x17
    jmp ISRCallCommon

.global ISRCallx18
ISRCallx18:
    cli
    push 0x00
    push 0x18
    jmp ISRCallCommon

.global ISRCallx19
ISRCallx19:
    cli
    push 0x00
    push 0x19
    jmp ISRCallCommon

.global ISRCallx1A
ISRCallx1A:
    cli
    push 0x00
    push 0x1A
    jmp ISRCallCommon

.global ISRCallx1B
ISRCallx1B:
    cli
    push 0x00
    push 0x1B
    jmp ISRCallCommon

.global ISRCallx1C
ISRCallx1C:
    cli
    push 0x00
    push 0x1C
    jmp ISRCallCommon

.global ISRCallx1D
ISRCallx1D:
    cli
    push 0x00
    push 0x1D
    jmp ISRCallCommon

.global ISRCallx1E
ISRCallx1E:
    cli
    push 0x00
    push 0x1E
    jmp ISRCallCommon

.global ISRCallx1F
ISRCallx1F:
    cli
    push 0x00
    push 0x1F
    jmp ISRCallCommon

.global ISRCallx20
ISRCallx20:
    cli
    push 0x00
    push 0x20
    jmp ISRCallCommon

.global ISRCallx21
ISRCallx21:
    cli
    push 0x21
    jmp ISRCallCommon

.global ISRCallx22
ISRCallx22:
    cli
    push 0x00
    push 0x22
    jmp ISRCallCommon

.global ISRCallx23
ISRCallx23:
    cli
    push 0x00
    push 0x23
    jmp ISRCallCommon

.global ISRCallx24
ISRCallx24:
    cli
    push 0x00
    push 0x24
    jmp ISRCallCommon

.global ISRCallx25
ISRCallx25:
    cli
    push 0x00
    push 0x25
    jmp ISRCallCommon

.global ISRCallx26
ISRCallx26:
    cli
    push 0x00
    push 0x26
    jmp ISRCallCommon

.global ISRCallx27
ISRCallx27:
    cli
    push 0x00
    push 0x27
    jmp ISRCallCommon

.global ISRCallx28
ISRCallx28:
    cli
    push 0x00
    push 0x28
    jmp ISRCallCommon

.global ISRCallx29
ISRCallx29:
    cli
    push 0x00
    push 0x29
    jmp ISRCallCommon

.global ISRCallx2A
ISRCallx2A:
    cli
    push 0x00
    push 0x2A
    jmp ISRCallCommon

.global ISRCallx2B
ISRCallx2B:
    cli
    push 0x00
    push 0x2B
    jmp ISRCallCommon

.global ISRCallx2C
ISRCallx2C:
    cli
    push 0x00
    push 0x2C
    jmp ISRCallCommon

.global ISRCallx2D
ISRCallx2D:
    cli
    push 0x00
    push 0x2D
    jmp ISRCallCommon

.global ISRCallx2E
ISRCallx2E:
    cli
    push 0x00
    push 0x2E
    jmp ISRCallCommon

.global ISRCallx2F
ISRCallx2F:
    cli
    push 0x00
    push 0x2F
    jmp ISRCallCommon

.align 8
ISRCallCommon:
    push rax
    push rcx
    push rdx
    push rbx
    push rsp
    push rbp
    push rsi
    push rdi

    mov ax, ds
    push rax

    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    call ISRHandler

    pop rax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    pop rdi
    pop rsi
    pop rbp
    pop rsp
    pop rbx
    pop rdx
    pop rcx
    pop rax
    add rsp, 0x10
    sti
    iretq
