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
        jl min_a_end
        mov eax, edx
        jmp min_end

   b_min:
        cmp esi, edx
        jl min_b_end
        mov eax, edx
        jmp min_end

   min_a_end:
        mov eax, edi
        jmp min_end

   min_b_end:
        mov eax, esi
        jmp min_end

   min_end:

        leave
        ret