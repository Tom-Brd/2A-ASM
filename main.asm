extern printf

%define QWORD    8
%define DWORD    4
%define WORD    2
%define BYTE    1

section .data
format: db  "%d", 10, 0
compteur: db 0

section .bss
coordonnees:    resd    6

section .text

global main
main:

mov ebx, 400

push rbp

rand:
    cmp byte[compteur], 6
    jge fin_rand
    xor eax, eax
    rdrand eax
    xor edx, edx
    div ebx
    movzx r8d, byte[compteur]
    mov dword[coordonnees + r8d * DWORD], edx


    mov rdi, format
    mov esi, dword[coordonnees + r8d * DWORD]
    ;movzx esi, byte[compteur]
    mov rax, 0
    call printf

    inc byte[compteur]
    jmp rand
fin_rand:

pop rbp


mov rax, 60
mov rdi, 0
syscall
ret
