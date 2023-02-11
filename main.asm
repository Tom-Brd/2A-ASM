extern printf
extern scanf
extern rand
extern find_min
extern find_max

%define QWORD	8
%define DWORD	4
%define WORD	2
%define BYTE	1

global main

section .bss
;coordonnees:    resd    6

section .data
a:  db  2
b:  db  3
c:  db  4
format: db  "Valeur : %d", 10, 0

section .txt

main:


    mov rdi, [a]
    mov rsi, [b]
    mov rcx, [c]
    call find_min

    push rbp

    mov rdi, format
    mov rsi, eax
    call printf


    pop rbp


    ;mov r8d, 400 ;largeur de la fenêtre
    ;mov edx, 0
    ;mov esi, 0 ;compteur

    ;boucle:

    ;    mov edi, r8d
    ;    mov rax, 0
    ;    call rand

    ;    mov dword[coordonnees + esi*DWORD], edx

    ;    inc esi
    ;    cmp esi, 6
    ;    jne boucle


    ;fin du programme
    mov rax, 60
    mov rdi, 0
    syscall
    ret