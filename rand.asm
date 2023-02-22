global rand_function

; la fonction permet de diviser le nombre aléatoire
rand_function:

    xor eax, eax
    rdrand eax

    ;si rdrand n'a pas fonctionné, on recommence
    jnc rand_function
    
    ;on remplit le tableau avec la valeur générée (modulo ebx)
    xor edx, edx
    div edi