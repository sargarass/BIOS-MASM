KB_ACK    equ 0FAh
KB_TESTOK equ 0AAh


KB_INIT_TABLE:
;  КОД | ПОРТ |ОТВЕТ(ы)
db 0AAh, 064h, 055h
db 0ABh, 064h, 000h
db 0AEh, 064h
db 0FFh, 060h, KB_ACK, KB_TESTOK
db 0F5h, 060h, KB_ACK
db 060h, 064h
db 061h, 060h
db 0F4h, 060h, KB_ACk

KB_ANSWER_CHECK macro answer
        call kb_wait_answer
        in al, 060h
        cmp al, answer
        jne on_error
endm

CMOS_READ_TIME macro
       mov al, 0
       out 70h, al
       in al, 71h
endm

KB_GET_TIMEOUT macro
local wait
local wait2
       push cx
       CMOS_READ_TIME
       xor cx, cx
       mov ah, al

wait:
       CMOS_READ_TIME
       cmp ah, al
       je wait
       mov ah, al

wait2:
       inc cx
       CMOS_READ_TIME
       cmp ah, al
       je wait2

       mov bx, 040h
       mov ds, bx

       mov word ptr ds:[KB_TIMEOUT], cx
       pop cx
endm

keyboard_init proc near
        push ax
        push es
        push cx
        push bx
        KB_GET_TIMEOUT()

        xor ax,ax
        mov es, ax

        mov es:[09h*4], offset int09_handler
        mov es:[09h*4+2], cs

        mov es:[016h*4], offset int16_handler
        mov es:[016h*4+2], cs

        call kb_queue_init

        call kb_wait_free_buffer
        mov al, 0AAh
        out 064h, al
        KB_ANSWER_CHECK(055h)

        call kb_wait_free_buffer
        mov al, 0ABh
        out 064h, al
        KB_ANSWER_CHECK(0)

        call kb_wait_free_buffer
        mov al, 0AEh
        out 064h, al

        call kb_wait_free_buffer
        mov al, 0FFh
        out 060h, al
        KB_ANSWER_CHECK(KB_ACK)
        KB_ANSWER_CHECK(KB_TESTOK)

        call kb_wait_free_buffer
        mov al, 0F5h
        out 060h, al
        KB_ANSWER_CHECK(KB_ACK)

        call kb_wait_free_buffer
        mov al, 060h
        out 064h, al

        call kb_wait_free_buffer
        mov al, 061h
        out 060h, al

        call kb_wait_free_buffer
        mov al, 0F4h
        out 060h, al
        KB_ANSWER_CHECK(KB_ACK)
        pop bx
        pop cx
        pop es
        pop ax
        ret

on_error:
        mov al, 'e'
        out 0E9h, al
        mov al, 'r'
        out 0E9h, al
        mov al, 'r'
        out 0E9h, al
        mov al, 'o'
        out 0E9h, al
        mov al, 'r'
        out 0E9h, al
        mov al, ' '
        out 0E9h, al
        jmp on_error
keyboard_init endp 
