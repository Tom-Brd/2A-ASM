global find_max
find_min:

   ; edi = a
   ; esi = b
   ; ecx = c

   cmp edi, esi
   ja a_max
   jmp b_max

   a_ax:
        cmp edi, ecx
        ja end
        mov edi, ecx
        jmp end

   b_max:
        cmp esi, ecx
        ja b_end
        mov edi, ecx
        jmp end

   b_end:
        mov edi, esi
        jmp end

   end:
        ret
