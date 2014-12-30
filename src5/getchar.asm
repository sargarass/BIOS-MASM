;; Функция getchar
;; Получает символ с клавиатуры.
;; Если очередь не пуста, то элемент извлекается из очереди (Максимальное колво элементов в очереди - 16)
;; Иначе, выполняется ожидание нажатия клавиши.
;; Возращаемое значение помещается в al
;; Возращаются как коды нажатия, так и отжатия

getchar proc near
	push bx
.wait:
        call kb_queue_pop
        call convert
        cmp ah, 0FFh; Если FF => буффер пуст Ожидаем символ
        je .error
        
        mov bl, al
        mov al, ah
        mov ah, bl
        
        pop bx
        ret
.error:
        hlt
        jmp .wait
getchar endp
