section .data
    max_value dd 0        ; Valeur maximale pour les nombres aléatoires
    random_numbers times 6 dd 0 ; Tableau pour stocker les nombres aléatoires

section .text
    global _start

; Génération de nombres aléatoires en utilisant RDRAND
; Entrée: EAX - Valeur maximale pour les nombres aléatoires
; Sortie: EAX - Nombre aléatoire généré

random_number:
    push ebp        ; Sauvegarder le sommet de pile
    mov ebp, esp    ; Initialiser le sommet de pile

    ; Tenter de générer un nombre aléatoire avec RDRAND
    rdrand eax      ; Générer un nombre aléatoire avec RDRAND
    xor edx, edx    ; Initialiser EDX pour la division
    div dword [ebp + 8] ; Diviser le nombre aléatoire par max_value pour limiter sa valeur entre 0 et max_value

    pop ebp        ; Restaurer le sommet de pile
    ret            ; Retourner le nombre aléatoire généré

; Programme principal
_start:
    mov eax, [max_value] ; Récupérer la valeur maximale pour les nombres aléatoires

    ; Générer 6 nombres aléatoires et les stocker dans le tableau random_numbers
    mov ecx, 6      ; Initialiser le compteur pour la boucle
    mov ebx, 0      ; Initialiser l'index du tableau
generate_random_numbers:
    push eax        ; Pousser la valeur maximale pour les nombres aléatoires sur la pile
    call random_number ; Appeler la fonction random_number pour générer un nombre aléatoire
    mov [random_numbers + ebx], eax ; Stocker le nombre aléatoire dans le tableau
    add ebx, 4      ; Incrémenter l'index du tableau de 4 octets
    loop generate_random_numbers ; Répéter la boucle jusqu'à ce que le compteur soit épuisé

    ; Terminer le programme
    mov eax, 1      ; Code de sortie pour le système d'exploitation
    xor ebx, ebx    ; Initialiser EBX pour la sortie
    int 0x80        ; Appel système pour terminer le programme
