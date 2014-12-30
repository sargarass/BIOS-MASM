IDT:
       rept 32
        dd 0, 0
       endm
       intdescriptor _offset=int08, _selector=8
       intdescriptor _offset=int09, _selector=8
RIDTR: dw 3FFh
       dd 0

IDT_SIZE equ $ - IDT
idtr:
       dw IDT_SIZE - 1
       dd IDT_MEM_POS
