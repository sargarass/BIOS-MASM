pic_init proc near
        push ax
        EndOfInterrupt()

        mov al, 11h ; ICW 1
        out PIC_C0, al
        out PIC_C1, al

        mov al, 20h ; ICW 2
        out PIC_D0, al

        mov al, 04h ; ICW 3
        out PIC_D0, al

        mov al, 05h ; ICW 4
        out PIC_D0, al

        mov al, 28h ; ICW 2
        out PIC_D1, al

        mov al, 02h ; ICW 3
        out PIC_D1, al

        mov al, 01h ; ICW 4
        out PIC_D1, al

        mov al, 0B8h ; маска IRQ
        out PIC_D0, al

        mov al, 08Fh ; маска IRQ
        out PIC_D1, al

        pop ax

        ret
pic_init endp 
