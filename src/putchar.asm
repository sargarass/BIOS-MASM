updatecursor proc near
       push dx
       push ax
       push bx
       push cx
       mov bx, ds:[VM_POS]
       shr bx, 1
       mov cx, bx              ;store 'position' in CX 
       ;add cx, 1
       ;cursor LOW port to vga INDEX register 
       mov al, 0fh             ;Cursor Location Low Register -- 
       mov dx, 3d4h            ;VGA port 3D4h 
       out dx, al 
       mov ax, cx              ;restore 'postion' back to AX 
       mov dx, 3d5h            ;VGA port 3D5h 
       out dx, al              ;send to VGA hardware 
        ;cursor HIGH port to vga INDEX register 
       mov al, 0eh 
       mov dx, 3d4h            ;VGA port 3D4h 
       out dx, al 
       mov ax, cx              ;restore 'position' back to AX 
       shr ax, 8               ;get high byte in 'position' 
       mov dx, 3d5h            ;VGA port 3D5h 
       out dx, al              ;send to VGA hardware 

       pop cx
       pop bx
       pop ax
       pop dx
       ret
updatecursor endp

putchar proc near
        pusha

        mov bx, ds:[VM_POS] ; Считываем значение указателя
        cmp bx, VM_SIZE
        jl @f
        xor bx, bx
@@:
        mov gs:[bx], al
        lea bx, [bx+2]
        mov ds:[VM_POS], bx
        call updatecursor
        popa
        ret
putchar endp
