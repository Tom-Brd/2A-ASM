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
        jl a_end
        mov eax, ecx
        jmp end

   b_min:
        cmp esi, ecx
        jl b_end
        mov eax, ecx
        jmp end

   a_end:
        mov eax, edi
        jmp end

   b_end:
        mov eax, esi
        jmp end

   end:
        ret
