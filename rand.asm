global rand

; la fonction permet de diviser le nombre aléatoire
rand:
    ;on génère un nombre aléatoire
    xor eax, eax
    rdrand eax
    
    ;si rdrand n'a pas fonctionné, on recommence
    jnc rand
    
    ;on remplit le tableau avec la valeur générée (modulo ebx)
    xor edx, edx
    div ebx