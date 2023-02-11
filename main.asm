extern printf
extern scanf

%define QWORD	8
%define DWORD	4
%define WORD	2
%define BYTE	1

global main

section .bss
coordonnees:    resd    6


section .data
affichage:  db  "Valeur générée : %d", 10, 0


section .txt

global rand

; la fonction permet de diviser le nombre aléatoire
rand:
    rdrand eax ;on stock le nombre aléatoire sur 32 bits dans eax
    mov ecx, 0
    mov ecx, edi ;On copie la valeur de l'argument dans rax
    xor edx, edx ;on met 0 dans le registre edx
    div ecx ;le reste de la division est contenu dans edx --> valeur modulo
ret

main:

    mov r8d, 400 ;largeur de la fenêtre
    mov edx, 0
    mov esi, 0 ;compteur

    boucle:

        mov edi, r8d
        mov rax, 0
        call rand

        mov dword[coordonnees + esi*DWORD], edx

        mov rdi,affichage ;
        movzx rsi,dword[coordonnees + esi*DWORD]
        mov rax,0
        call printf

        inc esi
        cmp esi, 6
        jne boucle


    ;fin du programme
    mov rax, 60
    mov rdi, 0
    syscall
    ret