global find_max
find_max:
    push rbp
    mov rbp, rsp

   ; edi = a
   ; esi = b
   ; edx = c

   cmp edi, esi
   ja a_max
   jmp b_max

   a_max: ; a > b
        cmp edi, edx ; a > c
        ja max_a_end
        mov eax, edx ; c > a > b
        jmp max_end

   b_max:; b > a
        cmp esi, edx ; b > c
        ja max_b_end
        mov eax, edx ; c > b > a
        jmp max_end

   max_a_end:
        mov eax, edi
        jmp max_end

   max_b_end:
        mov eax, esi
        jmp max_end

   max_end:
        leave
        ret