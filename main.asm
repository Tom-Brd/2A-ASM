; external functions from X11 library
extern XOpenDisplay
extern XDisplayName
extern XCloseDisplay
extern XCreateSimpleWindow
extern XMapWindow
extern XRootWindow
extern XSelectInput
extern XFlush
extern XCreateGC
extern XSetForeground
extern XDrawLine
extern XDrawPoint
extern XFillArc
extern XNextEvent

; external functions from stdio library (ld-linux-x86-64.so.2)
;extern find_min
extern printf
extern exit
extern find_max
extern find_min
extern det_from_points
extern rand

%define	StructureNotifyMask	131072
%define KeyPressMask		1
%define ButtonPressMask		4
%define MapNotify		19
%define KeyPress		2
%define ButtonPress		4
%define Expose			12
%define ConfigureNotify		22
%define CreateNotify 16

%define QWORD    8
%define DWORD    4
%define WORD    2
%define BYTE    1

section .data

    format: db  10, "%d", 10, 0
    format_coord: db  "c %d", 9, 0
    format_det: db   10, "det: %d", 10, 0
    format_i: db   10, "i: %d", 10, 0
    format_j: db   10, "j: %d", 10, 0
    format_min_x: db   10, "min_x: %d", 10, 0
    format_min_y: db   10, "min_y: %d", 10, 0
    format_max_x: db   10, "max_x: %d", 10, 0
    format_max_y: db   10, "max_y: %d", 10, 0
    format_jaaj:    db   10, "jaaj", 10, 0
    format_indirect:    db   10, "Il s'agit d'un trianglez uncuzqite", 10, 0
    compteur: db 0
    event:	times	24 dq 0

section .bss
    coordonnees:    resd    6
    display_name:	resq	1
    screen:			resd	1
    depth:         	resd	1
    connection:    	resd	1
    width:         	resd	1
    height:        	resd	1
    window:		resq	1
    gc:		resq	1
    min_x:		resd	1
    min_y:		resd	1
    max_x:		resd	1
    max_y:		resd	1
    determinant: resd    1

    i: resd 1
    j: resd 1

section .text


global main
main:
; ################################################
; # REMPLISSAGE DU TABLEAU DE COORDONNEES RANDOM #
; ################################################

mov ebx, 300

push rbp

rand:
    ;on vérifie que le tableau n'est pas totalement rempli
    cmp byte[compteur], 6
    jge min_label
    
    ;;;fonction rand
    ; ;on génère un nombre aléatoire
    ; xor eax, eax
    ; rdrand eax
    
    ; ;si rdrand n'a pas fonctionné, on recommence
    ; jnc rand
    
    ; ;on remplit le tableau avec la valeur générée (modulo ebx)
    ; xor edx, edx
    ; div ebx


    call rand      ;pas besoin d'argument normalement
    movzx r8d, byte[compteur]
    mov dword[coordonnees + r8d * DWORD], edx

    ;on affiche la valeur
    mov rdi, format_coord
    mov esi, dword[coordonnees + r8d * DWORD]
    mov rax, 0
    call printf

    ;on passe à l'index suivant
    inc byte[compteur]
    jmp rand
    mov byte[compteur], 0
    pop rbp
    jmp min_label
    



min_label:

    push rbp
    ; min x
    mov edi, dword[coordonnees + 0 * DWORD]
    mov esi, dword[coordonnees + 2 * DWORD]
    mov edx, dword[coordonnees + 4 * DWORD]
    call find_min
    mov rdi, format_min_x
    mov dword[min_x], eax
    mov esi, dword[min_x]
    mov rax, 0
    call printf

    ; min y
    mov edi, dword[coordonnees + 1 * DWORD]
    mov esi, dword[coordonnees + 3 * DWORD]
    mov edx, dword[coordonnees + 5 * DWORD]
    call find_min
    mov rdi, format_min_y
    mov dword[min_y], eax
    mov esi, dword[min_y]
    mov rax, 0
    call printf

    pop rbp


max_label:

    push rbp

    mov edi, dword[coordonnees + 0 * DWORD]
    mov esi, dword[coordonnees + 2 * DWORD]
    mov edx, dword[coordonnees + 4 * DWORD]
    call find_max
    mov rdi, format_max_x
    mov dword[max_x], eax
    mov esi, dword[max_x]
    mov rax, 0
    call printf

    
    mov edi, dword[coordonnees + 1 * DWORD]
    mov esi, dword[coordonnees + 3 * DWORD]
    mov edx, dword[coordonnees + 5 * DWORD]
    call find_max
    mov rdi, format_max_y
    mov dword[max_y], eax
    mov esi, dword[max_y]
    mov rax, 0
    call printf

    pop rbp
    ;jmp display

vecteurs_label:
    ; r10d = Ax
    ; r11d = Ay
    ; r12d = Bx
    ; r13d = By
    ; r14d = Cx
    ; r15d = Cy

    mov r10d, dword[coordonnees + 0 * DWORD]
    mov r11d, dword[coordonnees + 1 * DWORD]

    mov r12d, dword[coordonnees + 2 * DWORD]
    mov r13d, dword[coordonnees + 3 * DWORD]
    
    mov r14d, dword[coordonnees + 4 * DWORD]
    mov r15d, dword[coordonnees + 5 * DWORD]
    call det_from_points

    push rbp
    mov rdi, format_det
    mov esi, dword[determinant]
    mov rax, 0
    call printf                                        
    pop rbp

display:

    xor     rdi,rdi
    call    XOpenDisplay	; Création de display
    mov     qword[display_name],rax	; rax=nom du display

    ; display_name structure
    ; screen = DefaultScreen(display_name);
    mov     rax,qword[display_name]
    mov     eax,dword[rax+0xe0]
    mov     dword[screen],eax

    mov rdi,qword[display_name]
    mov esi,dword[screen]
    call XRootWindow
    mov rbx,rax

    mov rdi,qword[display_name]
    mov rsi,rbx
    mov rdx,10
    mov rcx,10
    mov r8,400	; largeur
    mov r9,400	; hauteur
    push 0xFFFFFF	; background  0xRRGGBB
    push 0x00FF00
    push 1
    call XCreateSimpleWindow
    mov qword[window],rax

    mov rdi,qword[display_name]
    mov rsi,qword[window]
    mov rdx,131077 ;131072
    call XSelectInput

    mov rdi,qword[display_name]
    mov rsi,qword[window]
    call XMapWindow

    mov rsi,qword[window]
    mov rdx,0
    mov rcx,0
    call XCreateGC
    mov qword[gc],rax

    mov rdi,qword[display_name]
    mov rsi,qword[gc]
    mov rdx,0x000000	; Couleur du crayon
    call XSetForeground

boucle: ; boucle de gestion des évènements
    mov rdi,qword[display_name]
    mov rsi,event
    call XNextEvent

    cmp dword[event],ConfigureNotify	; à l'apparition de la fenêtre
    je dessin							; on saute au label 'dessin'

    cmp dword[event],KeyPress			; Si on appuie sur une touche
    je closeDisplay						; on saute au label 'closeDisplay' qui ferme la fenêtre
    jmp boucle



dessin:

    ;compteur = 0 puis 2 puis 4
    ; inc compteur après chaque mov
    ;si compteur 
    

    ;x1 y1 x2 y2
    ;0123 --> AB
    ;2345 --> BC
    ;4501 --> CA

    ;couleur de la ligne 1
    mov rdi,qword[display_name]
    mov rsi,qword[gc]
    mov edx,0x000000	; Couleur du crayon ; noir
    call XSetForeground
    
    ; dessin de la ligne 1
    mov rdi,qword[display_name]
    mov rsi,qword[window]
    mov rdx,qword[gc]
    mov ecx,dword[coordonnees + 0 * DWORD]	; coordonnée source en x
    mov r8d,dword[coordonnees + 1 * DWORD]	; coordonnée source en y
    mov r9d,dword[coordonnees + 2 * DWORD]	; coordonnée destination en x
    push qword[coordonnees + 3 * DWORD]		; coordonnée destination en y
    call XDrawLine

    ; dessin de la ligne 2
    mov rdi,qword[display_name]
    mov rsi,qword[window]
    mov rdx,qword[gc]
    mov ecx,dword[coordonnees + 2 * DWORD]	; coordonnée source en x
    mov r8d,dword[coordonnees + 3 * DWORD]	; coordonnée source en y
    mov r9d,dword[coordonnees + 4 * DWORD]	; coordonnée destination en x
    push qword[coordonnees + 5 * DWORD]		; coordonnée destination en y
    call XDrawLine

    ; dessin de la ligne 3
    mov rdi,qword[display_name]
    mov rsi,qword[window]
    mov rdx,qword[gc]
    mov ecx,dword[coordonnees + 4 * DWORD]	; coordonnée source en x
    mov r8d,dword[coordonnees + 5 * DWORD]	; coordonnée source en y
    mov r9d,dword[coordonnees + 0 * DWORD]	; coordonnée destination en x
    push qword[coordonnees + 1 * DWORD]		; coordonnée destination en y
    call XDrawLine




    mov r8d, dword[min_x]
    mov dword[i], r8d
    mov r8d, dword[min_y]
    mov dword[j], r8d

    cmp dword[determinant], 0
    jge indirect

direct:

    mov r8d, dword[max_x]
    cmp dword[i], r8d
    jg flush

    mov r9d, dword[max_y]
    cmp dword[j], r9d
    jg next_i_direct

    mov r10d, dword[coordonnees + 2 * DWORD]
    mov r11d, dword[coordonnees + 3 * DWORD]

    mov r12d, dword[coordonnees + 0 * DWORD]
    mov r13d, dword[coordonnees + 1 * DWORD]

    mov r14d, dword[i]
    mov r15d, dword[j]
    call det_from_points

    cmp dword[determinant], 0
    jl next_j_direct

    mov r10d, dword[coordonnees + 4 * DWORD]
    mov r11d, dword[coordonnees + 5 * DWORD]

    mov r12d, dword[coordonnees + 2 * DWORD]
    mov r13d, dword[coordonnees + 3 * DWORD]

    mov r14d, dword[i]
    mov r15d, dword[j]
    call det_from_points

    cmp dword[determinant], 0
    jl next_j_direct

    mov r10d, dword[coordonnees + 0 * DWORD]
    mov r11d, dword[coordonnees + 1 * DWORD]

    mov r12d, dword[coordonnees + 4 * DWORD]
    mov r13d, dword[coordonnees + 5 * DWORD]

    mov r14d, dword[i]
    mov r15d, dword[j]
    call det_from_points

    cmp dword[determinant], 0
    jl next_j_direct

    ; Dessine point

    ; ;couleur du point 1
    ; mov rdi,qword[display_name]
    ; mov rsi,qword[gc]
    ; mov edx,0x000000	; Couleur du crayon ; noir
    ; call XSetForeground

    ; Dessin d'un point noir : coordonnées (100,200)
    mov rdi,qword[display_name]
    mov rsi,qword[window]
    mov rdx,qword[gc]
    mov ecx,dword[i]	; coordonnée source en x
    mov r8d,dword[j]	; coordonnée source en y
    call XDrawPoint

    jmp next_j_direct

    next_i_direct:
        mov r9d, dword[min_y]
        mov dword[j], r9d
        inc dword[i]
        jmp direct

    next_j_direct:
        inc dword[j]
        jmp direct


indirect:
    mov r8d, dword[max_x]
    cmp dword[i], r8d
    jg flush

    mov r9d, dword[max_y]
    cmp dword[j], r9d
    jg next_i_indirect

    mov r10d, dword[coordonnees + 2 * DWORD]
    mov r11d, dword[coordonnees + 3 * DWORD]

    mov r12d, dword[coordonnees + 0 * DWORD]
    mov r13d, dword[coordonnees + 1 * DWORD]

    mov r14d, dword[i]
    mov r15d, dword[j]
    call det_from_points

    cmp dword[determinant], 0
    jge next_j_indirect

    mov r10d, dword[coordonnees + 4 * DWORD]
    mov r11d, dword[coordonnees + 5 * DWORD]

    mov r12d, dword[coordonnees + 2 * DWORD]
    mov r13d, dword[coordonnees + 3 * DWORD]

    mov r14d, dword[i]
    mov r15d, dword[j]
    call det_from_points

    cmp dword[determinant], 0
    jge next_j_indirect

    mov r10d, dword[coordonnees + 0 * DWORD]
    mov r11d, dword[coordonnees + 1 * DWORD]

    mov r12d, dword[coordonnees + 4 * DWORD]
    mov r13d, dword[coordonnees + 5 * DWORD]

    mov r14d, dword[i]
    mov r15d, dword[j]
    call det_from_points

    cmp dword[determinant], 0
    jge next_j_indirect

    ; Dessine point

    ; ;couleur du point 1
    ; mov rdi,qword[display_name]
    ; mov rsi,qword[gc]
    ; mov edx,0x000000	; Couleur du crayon ; noir
    ; call XSetForeground

    ; Dessin d'un point noir : coordonnées (100,200)
    mov rdi,qword[display_name]
    mov rsi,qword[window]
    mov rdx,qword[gc]
    mov ecx,dword[i]	; coordonnée source en x
    mov r8d,dword[j]	; coordonnée source en y
    call XDrawPoint

    jmp next_j_indirect

    next_i_indirect:
        mov r9d, dword[min_y]
        mov dword[j], r9d
        inc dword[i]
        jmp indirect

    next_j_indirect:
        inc dword[j]
        jmp indirect

flush:
    mov rdi,qword[display_name]
    call XFlush
    jmp boucle
    mov rax,34
    syscall

closeDisplay:
    mov     rax,qword[display_name]
    mov     rdi,rax
    call    XCloseDisplay
    xor	    rdi,rdi
    call    exit
	
;fin
mov rax, 60
mov rdi, 0
syscall
ret