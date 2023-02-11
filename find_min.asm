global find_min
find_min:

   ; edi = a
   ; esi = b
   ; ecx = c

   cmp edi, esi
   jl a_min
   jmp b_min

   a_min:
        cmp edi, ecx
        jl end
        mov edi, ecx
        jmp end

   b_min:
        cmp esi, ecx
        jl b_end
        mov edi, ecx
        jmp end

   b_end:
        mov edi, esi
        jmp end

   end:
        ret
