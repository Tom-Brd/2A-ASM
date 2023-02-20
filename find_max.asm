global find_max
find_max:

   ; edi = a
   ; esi = b
   ; ecx = c

   cmp edi, esi
   ja a_max
   jmp b_max

   a_max:
        cmp edi, ecx
        ja end
        mov eax, ecx
        jmp end

   b_max:
        cmp esi, ecx
        ja b_end
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
