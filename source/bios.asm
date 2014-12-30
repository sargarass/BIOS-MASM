.586

_TEXT   segment byte public 'CODE' use16
assume cs:_TEXT, ds:nothing

org     100h
start:
        cli
        lss     SP, dword ptr STKPTR
        sti

        call scanbios

        call stop
        
STKPTR  dw      0FFFEh,09000h

BEGSEG	dw	0C000h

scanbios proc near
        cld
        mov     DS, word ptr BEGSEG

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
        jnz     short skip

        pusha
        push    ds
        push    es
        push    fs
        push    gs

        push    CS
        push    offset __ret
        push    DS
        push    3h
        retf
__ret:
        pop     gs
        pop     fs
        pop     es
        pop     ds
        popa
        
skip:
        ret     0
scanbios endp


stop    proc near
        cli
        hlt
        jmp     short stop
stop    endp


; real startup entry begins at F000:FFF0
org     0FFF0h
        db      0EAh
        dw      offset start
        dw      0F000h


org     0FFFEh
        dw      99FCh

_TEXT   ends
end     start
