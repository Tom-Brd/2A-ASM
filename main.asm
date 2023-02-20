extern printf
extern scanf
extern rand
extern find_min
extern find_max
extern vecteurs_from_points

%define QWORD	8
%define DWORD	4
%define WORD	2
%define BYTE	1

global main

section .bss
coordonnees:    resd    6
vecteurs:   resd    4
min_x:    resd    1
max_x:    resd    1
min_y:    resd    1
max_y:    resd    1

section .data
format: db  "Valeur : %d", 0

section .txt

main:

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;REMPLIR LE TABLEAU COORDONNEES AVEC DES VALEURS ALÉATOIRES;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    mov r8d, 400 ;largeur de la fenêtre
    mov edx, 0
    mov esi, 0 ;compteur

    boucle:

        mov edi, r8d
        mov rax, 0
        call rand

        mov dword[coordonnees + esi*DWORD], edx

        inc esi
        cmp esi, 6
        jne boucle


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;DÉTERMINER LES VALEURS MAX ET MIN DES COORDONNEES;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    mov edi, dword[coordonnees + 0*DWORD]
    mov esi, dword[coordonnees + 2*DWORD]
    mov ecx, dword[coordonnees + 4*DWORD]
    call find_min

    push rbp

    mov rdi, format
    movzx rsi, byte[eax] ; Dans eax, on est censé récupérer la valeur renvoyée par la fonction find_min
    mov rax, 0
    call printf

    pop rbp

    mov [min_x], eax ;on affecte la valeur minimum de x à la variable min_x


    mov edi, dword[coordonnees + 0*DWORD]
    mov esi, dword[coordonnees + 2*DWORD]
    mov ecx, dword[coordonnees + 4*DWORD]
    call find_max

    push rbp

    mov rdi, format
    movzx rsi, byte[eax] ; Dans eax, on est censé récupéré la valeur renvoyée par la fonction find_max
    mov rax, 0
    call printf

    mov [max_x], eax ;on affecte la valeur maximum de x à la variable max_x


    pop rbp


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;APPEL DE LA FONCTION VECTEURS_FROM_POINTS;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    mov r10d, dword[coordonnees + 0 * DWORD] ;Ax
    mov r11d, dword[coordonnees + 1 * DWORD] ;Ay
    mov r12d, dword[coordonnees + 2 * DWORD] ;Bx
    mov r13d, dword[coordonnees + 3 * DWORD] ;By
    mov r14d, dword[coordonnees + 4 * DWORD] ;Cx
    mov r15d, dword[coordonnees + 5 * DWORD] ;Cy
    call vecteurs_from_points




    ;fin du programme
    mov rax, 60
    mov rdi, 0
    syscall
    ret