global det_from_points
det_from_points:
    push rbp
    mov rbp, rsp

    ; r10d = Ax
    ; r11d = Ay
    ; r12d = Bx
    ; r13d = By
    ; r14d = Cx
    ; r15d = Cy

    ; BA
    sub r10d, r12d ;
    sub r11d, r13d ;

    ; BC
    sub r14d, r12d ;
    sub r15d, r13d ;

    mov eax, r10d
    mov ebx, r15d
    imul ebx
    mov [determinant], eax
    mov eax, r14d
    mov ebx, r11d
    imul ebx
    sub dword[determinant], eax

    leave
    ret
