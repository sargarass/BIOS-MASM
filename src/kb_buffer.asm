kb_queue_init proc near
        mov word ptr ds:[KB_QUEUE_COUNT], 0
        mov word ptr ds:[KB_QUEUE_HEAD],  0
        mov word ptr ds:[KB_QUEUE_TAIL],  0
        ret
kb_queue_init endp

kb_queue_push proc near ; push al -> queue
        cli
        push ebx

        cmp word ptr ds:[KB_QUEUE_COUNT], KB_QUEUE_CAP   ; if (CAP == COUNT)
        ; обработка ошибки
        je short push_err
        ; ...

        mov bx, word ptr ds:[KB_QUEUE_TAIL]
        mov byte ptr ds:[KB_QUEUE_DATA + bx], al

        inc bx
        mov word ptr ds:[KB_QUEUE_TAIL], bx

        cmp bx, KB_QUEUE_CAP
        jne  short l1
        mov word ptr ds:[KB_QUEUE_TAIL], 0
l1:
        inc word ptr ds:[KB_QUEUE_COUNT]
push_err:
        pop ebx
        sti
        ret
kb_queue_push endp

kb_queue_pop proc near ; al <- queue
        cli
        push ebx
        mov al, 0FFh
        xor ebx, ebx
        ; if QueueEmpty ( q ): error "опустошение"
        cmp word ptr ds:[KB_QUEUE_COUNT], 0
        ; обработка ошибки
        je short pop_err

        mov bx, word ptr ds:[KB_QUEUE_HEAD]
        mov al, byte ptr ds:[KB_QUEUE_DATA + bx]

        inc bx
        mov word ptr ds:[KB_QUEUE_HEAD], bx

        cmp bx, KB_QUEUE_CAP
        jne short l2

        mov word ptr ds:[KB_QUEUE_HEAD], 0
l2:
        dec word ptr ds:[KB_QUEUE_COUNT]
pop_err:
        pop ebx
        sti
        ret

kb_queue_pop endp
