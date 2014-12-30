scanbios proc near
        cld
        mov     dx, 0C000h

cycle: mov  DS, dx
  cmp  word ptr DS:[0], 0AA55h
  jnz  short skip

        xor     si, si
        xor     cx, cx
        mov     ch, DS:[2]
        xor     bl, bl

chcksm: lodsw
        add     al, ah
        add     bl, al
        dec     cx
        jnz     short chcksm
        or      bl, bl
        jnz     short skipss
        pusha
        push ds
        push es
        push fs
        push gs
        push CS
        push offset (__ret+_TEXT32_END)
        push DS
        push 3
        retf
__ret:
        pop gs
        pop fs
        pop es
        pop ds
        popa
skipss:
          movzx cx, byte ptr DS:[2]
          sub  cl, 1
          and  cl, 0FCh
          shl  cx, 5
          add  dx, cx
skip:
          add  dx, 080h
          cmp  dx, 0F000h
          jb  cycle
          ret     0
scanbios endp
