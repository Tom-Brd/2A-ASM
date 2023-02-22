extern printf

section .data

    format: db  "%d", 10, 0
    x1: db 1
    x2: db 3
    x3: db 7
    
global main
main:


   ; edi = a
   ; esi = b
   ; ecx = c
   ; mov edi, 1
   ; mov esi, 3
   ; mov ecx, 7
   mov eax, x1 ; --> min = a

   cmp eax, x2 ;--> 
   jl a_min ; Si min < x2 alors min
   jmp b_min ; Sinon x2_min

   a_min: ; a < b 
        cmp eax, x3 ; a < c
        jl end
        mov eax, x3 ; c < a < b
        jmp end ; je pense vous pouvez regarder en bas

   b_min: ; b < a
        mov eax, x2 ; b min
        cmp eax, x3 ; b < c
        jl end
        mov eax, x3 ; c < b < a
        jmp end

   end:
     push rbp

     mov rdi, format
     mov esi, eax
     mov rax, 0
     call printf
     
     pop rbp


mov rax, 60
mov rdi, 0
syscall
ret



; global find_min

; find_min:
;     push ebp ; sauvegarde de la base de pile actuelle
;     mov ebp, esp ; initialisation de la nouvelle base de pile

;     ; récupération des paramètres
;     mov eax, [ebp + 8] ; première valeur
;     mov ebx, [ebp + 12] ; deuxième valeur
;     mov ecx, [ebp + 16] ; troisième valeur

;     ; comparaison de la première valeur avec les deux autres
;     cmp eax, ebx
;     jle cmp_ecx_eax ; si la première valeur est inférieure ou égale à la deuxième, on compare avec la troisième
;     mov eax, ebx ; sinon, la deuxième valeur est le minimum actuel

; cmp_ecx_eax:
;     cmp eax, ecx
;     jle end ; si la première valeur est inférieure ou égale à la troisième, c'est le minimum
;     mov eax, ecx ; sinon, la troisième valeur est le minimum actuel

; end:
;     ; nettoyage de la pile et retour de la valeur
;     mov esp, ebp
;     pop ebp
;     ret