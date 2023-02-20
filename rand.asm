global rand

; la fonction permet de diviser le nombre aléatoire
rand:
    xor eax, eax ;on met 0 dans le registre eax

    rdrand eax ;on stock le nombre aléatoire sur 32 bits dans eax
    jc rand

    test eax, eax ; vérifier si eax est égal à 0
    jz rand

    mov ecx, eax
    xor edx, edx ;on met 0 dans le registre edx
    div ecx ;le reste de la division est contenu dans edx --> valeur modulo
    ret
