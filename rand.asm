global rand

; la fonction permet de diviser le nombre aléatoire
rand:
    rdrand eax ;on stock le nombre aléatoire sur 32 bits dans eax
    mov ecx, 0
    mov ecx, edi ;On copie la valeur de l'argument dans rax
    xor edx, edx ;on met 0 dans le registre edx
    div ecx ;le reste de la division est contenu dans edx --> valeur modulo
    ret
