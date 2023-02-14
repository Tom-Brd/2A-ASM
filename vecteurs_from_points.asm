section .bss

  vecteurs: resd    4

section .text

  global vecteurs_from_points

vecteurs_from_points:
  
  ; r10w = Ax
  ; r11w = Ay
  ; r12w = Bx
  ; r13w = By
  ; r14w = Cx
  ; r15w = Cy

  ; BA
  sub r12w, r10w ;
  sub r13w, r11w ;
 
  mov [vecteurs], r12w ; vecteurs[0] = BA.x
  mov [vecteurs + 4], r13w ; vecteurs[1] = BA.y

  ; BC
  sub r12w, r14w ;
  sub r13w, r15w ;
 
  mov [vecteurs + 8], r12w ; vecteurs[2] = BC.x
  mov [vecteurs + 12], r13w ; vecteurs[3] = BC.y
  
  mov rax, 60
  mov rdi, 0
  syscall
  ret