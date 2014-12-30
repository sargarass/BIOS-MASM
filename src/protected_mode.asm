protected_mode proc near
        cli ; Запрещаем прерывания
        call nmi_disable; Запрещаем NMI
        call open_A20
        call load_gdt
        call load_idt

        ; включаем битик cr0
        mov eax, cr0
        or al, 1
        mov cr0, eax

        db 066h ; смена разрядности
        db 0EAh
        dd offset start32 + 0F0000h
        dw 8

protected_mode endp

load_gdt proc near
        copy GDT, GDT_MEM_POS, GDT_SIZE
        lgdt fword ptr gdtr
        ret
load_gdt endp

load_idt proc near
        copy IDT, IDT_MEM_POS, IDT_SIZE
        lidt fword ptr idtr
        ret
load_idt endp

open_A20 proc near
        in al, SYS_CONTROL_PORT_A
        or al, 10b ; Bit 1 (rw): 0: disable A20, 1: enable A20.
        out SYS_CONTROL_PORT_A, al
        ret
open_A20 endp

nmi_disable proc near
        in al, CMOS_REG
        or al, 10000000b
        out CMOS_REG, al
        ret
nmi_disable endp
