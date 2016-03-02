.intel_syntax noprefix

.code64

.section .text

.global FlushIDT
FlushIDT:
    mov rax, rdi
    lidt [rax]
    sti
    ret