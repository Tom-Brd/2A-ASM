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

    format: db  10, "%d", 0
    format_coord: db  "c %d", 9, 0
    amin:    db   10, "amin %d", 0
    bmin:    db   10, "bmin %d", 0
    format_min_x: db   10, "min_x: %d",10, 0
    format_min_y: db   10, "min_y: %d",10, 0
    format_jaaj:    db   10, "jaaj", 0
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

section .text


global main
main:
; ################################################
; # REMPLISSAGE DU TABLEAU DE COORDONNEES RANDOM #
; ################################################

mov ebx, 400

push rbp

rand:
    ;on vérifie que le tableau n'est pas totalement rempli
    cmp byte[compteur], 6
    jge min_label
    
    ;on génère un nombre aléatoire
    xor eax, eax
    rdrand eax
    
    ;si rdrand n'a pas fonctionné, on recommence
    jnc rand
    
    ;on remplit le tableau avec la valeur générée (modulo ebx)
    xor edx, edx
    div ebx
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

    mov edi, 0
    mov esi, 0
    mov edx, 0


    mov edi, dword[coordonnees + 0 * DWORD]
    mov esi, dword[coordonnees + 2 * DWORD]
    mov edx, dword[coordonnees + 4 * DWORD]
    call find_min
    mov rdi, format_min_x
    mov dword[min_x], eax
    mov esi, dword[min_x]
    mov rax, 0
    call printf

    
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
    ;jmp display



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

    jmp flush

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
	

mov rax, 60
mov rdi, 0
syscall
ret


global find_min
find_min:
    push rbp
    mov rbp, rsp

   ; edi = a
   ; esi = b
   ; edx = c

   cmp edi, esi
   jl a_min
   jmp b_min

   a_min:
        cmp edi, edx
        jl a_end
        mov eax, edx
        jmp end

   b_min:
        cmp esi, edx
        jl b_end
        mov eax, edx
        jmp end

   a_end:
        mov eax, edi
        jmp end

   b_end:
        mov eax, esi
        jmp end

   end:

        leave
        ret
