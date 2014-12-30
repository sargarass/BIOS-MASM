putchar proc near
        pusha

        mov ebx, dword ptr ds:[VM_POS] ; Считываем значение указателя
        cmp ebx, VM_SIZE
        jl @f
        xor ebx, ebx
@@:
        mov byte ptr gs:[ebx + VM_BASE], al
        mov byte ptr gs:[ebx + VM_BASE + 1], 005h
        add ebx, 2
        mov dword ptr ds:[VM_POS], ebx

      ;  call updatecursor

        popa
        ret
putchar endp
