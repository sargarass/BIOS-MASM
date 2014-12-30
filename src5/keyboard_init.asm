KB_ACK    equ 0FAh
KB_TESTOK equ 0AAh


KB_INIT_TABLE:
;  КОД | ПОРТ |КОЛВО ОТВЕТОВ | ОТВЕТ(ы)
db 0AAh, 064h, 1, 055h
db 0ABh, 064h, 1, 000h
db 0AEh, 064h, 0
db 0FFh, 060h, 2, KB_ACK, KB_TESTOK
db 0F5h, 060h, 1, KB_ACK
db 060h, 064h, 0
db 061h, 060h, 0
db 0F4h, 060h, 1, KB_ACk
db 0h

CMOS_READ_TIME macro
        mov al, 0
        out 70h, al
        in al, 71h
endm

KB_GET_TIMEOUT macro
local wait
local wait2
       pusha
       push ecx
       CMOS_READ_TIME
       xor ecx, ecx
       mov ah, al

wait:
       CMOS_READ_TIME
       cmp ah, al
       je wait
       mov ah, al

wait2:
       inc ecx
       CMOS_READ_TIME
       cmp ah, al
       je wait2
       mov dword ptr ds:[KB_TIMEOUT], ecx
       pop ecx
       popa
endm

keyboard_init proc near
        pusha
        push ecx
        KB_GET_TIMEOUT()

        call kb_queue_init

        mov word ptr ds:[KB_BUTTON_FLAG], 0
        xor ebx, ebx
wrepeat:
;;====Ожидание пустого буффера====

        mov ecx, dword ptr ds:[KB_TIMEOUT] ; CMOS - 1 секунда
w0:     in al, 64h ; считываем из порта
        test al, 02h
        jz short w01
        rloop ecx, w0
        jmp on_error
;;================================
w01:
        mov al, byte ptr ds:[ebx + (KB_INIT_TABLE ) + CODE_PLACE] ; команда в al
        movzx dx, byte ptr ds:[ebx + (KB_INIT_TABLE + 1 ) + CODE_PLACE] ; закидываем порт
        out dx, al
        mov ah, byte ptr ds:[ebx + (KB_INIT_TABLE + 2 ) + CODE_PLACE] ; колво ответов
        lea ebx, [ebx + 3]

        cmp ah, 0 ;; Нужно ли ждать ответы?
        je wnext

wanswer:

        mov ecx, dword ptr ds:[KB_TIMEOUT]
;;====Ожидание ответа====
w1:     in al, 064h
        test al, 01h
        jnz short w11
        rloop ecx, w1
        jmp on_error
;;=======================
w11:
        in al, 060h
        mov dl, byte ptr ds:[ebx + (KB_INIT_TABLE) + CODE_PLACE] ;; Ожидаемый ответ
        inc ebx
        cmp al, dl ; Полученный == Ожидаемый?
        jne on_error

        dec ah
        jnz wanswer

wnext:
        cmp [ebx], 0 ; Дошли ли до конца таблицы
        jne wrepeat ; Если нет, продолжаем посылать команды
        pop ecx
        popa
        ret

on_error:
        PutString "| ERROR |"
        jmp on_error
keyboard_init endp 
