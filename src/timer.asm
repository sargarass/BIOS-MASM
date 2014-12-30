pit_init proc near
        push ax

        mov word ptr ds:[TIMER_VALUE], 0
        ; 110110
        ; 0 - двоичный счётчик
        ; 011 переодический генератор меандра
        ; 11 - оба байта счётчика используюся
        mov al, 00110110b ; 70 Hz
        out 43h, al ; управляющий регистр

        mov ax, 17046
        out 40h, al
        mov al, ah
        out 40h, al

        pop ax

        ret
pit_init endp
