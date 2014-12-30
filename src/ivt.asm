handler int08
        inc  dword ptr es:[TIMER_VALUE]
        EndOfInterrupt()
        iretd

handler int09
        push ax
        push bx
        mov al, 0ADh
        out 064h, al
        xor ax, ax

        in al, 060h

       ; Обработка

        call kb_queue_push

        EndOfInterrupt()

        mov al, 0AEh
        out 064h, al

        pop bx
        pop ax

        iretd
