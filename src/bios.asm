;.586 было
.586p

include macros.asm
include data.asm
_TEXT32 segment byte public 'CODE' use32
_TEXT32_BEGIN=$
org     100h

nmi_enable proc near
        in al, CMOS_REG
        or al, 01111111b
        out CMOS_REG, al
        ret
nmi_enable endp

start32:
        mov ax, (DS_dsc - GDT)
        mov ds, ax
        mov es, ax
        mov fs, ax
        mov ax, (GS_dsc - GDT)
        mov gs, ax

        xor ebx, ebx
        mov ax, (SS_dsc - GDT)
        mov ss, ax
        mov esp, 0FFEh
        call nmi_enable
        call pit_init
        call keyboard_init
        call pic_init
        call video_init
        sti
        call stop
        include timer.asm
        include keyboard_init.asm
        include keyboard_mapping.asm
        include pic.asm
        include ivt.asm
        include kb_buffer.asm
        include getchar.asm
        include stop.asm
        include video_init.asm
        include putchar.asm
_TEXT32_END=$ - _TEXT32_BEGIN
_TEXT32   ends

_TEXT   segment byte public 'CODE' use16
assume cs:_TEXT, ds:nothing
_TEXT_BEGIN=$
start:
        cli
        lss     SP, dword ptr STKPTR
        sti ; если сотрешь напиши хотя бы nop

        call scanbios
        ; вот тут !
        call protected_mode

        include gdt.asm
        include idt.asm
        include scanbios.asm
        include protected_mode.asm
STKPTR  dw      0FFFEh,09000h

BEGSEG	dw	0C000h


; real startup entry begins at F000:FFF0
org     0FFF0h - _TEXT32_END
        db      0EAh
        dw      offset start
        dw      0F000h + _TEXT32_END_


org     0FFFEh - _TEXT32_END
        dw      99FCh

_TEXT   ends
end     start
