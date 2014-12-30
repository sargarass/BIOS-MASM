EndOfInterrupt macro
        mov al, 020h
        out 020h, al
        endm

rloop macro reg, label
       dec reg
       jnz label
       endm

_TEXT32_END_ = ((_TEXT32_END - 1) SHR 4)

PutString macro string
local while
local exit
local str
        pusha

        mov ebx, offset str + 0F0000h
        jmp while
str:
        db string, 0
while:  mov al, byte ptr cs:[ebx]
        test al, al
        je exit
        call putchar
        inc bx
        jmp while
exit:
        popa
        endm

ClearWindow macro
local while
        push bx
        push ax
        call video_init
        mov bx, VM_SIZE
while:
        mov byte ptr gs:[bx - 2], ' '
        mov byte ptr gs:[bx - 1], 05h
        dec bx
        dec bx
        jnz while
        pop ax
        pop cx
endm

NewLine macro
local x
        push ax
        push bx
        mov ax, ds:[VM_POS]
        mov bl, 160
        div bl
        mul bl
        add ax, 160
        cmp ax, VM_SIZE
        jle x
        xor ax, ax
x:      mov ds:[VM_POS], ax
        call updatecursor

        pop bx
        pop ax
endm


;rem equ <;>

handler macro name
        name equ $ - _TEXT32_BEGIN  + 0F0000h
endm

copy macro _offset, _mem_pos, _size
       mov ax, cs
       mov ds, ax
       mov si, offset _offset
       mov ax, _mem_pos/16
       mov es, ax
       xor di, di
       mov cx, _size/4
       cld
       rep movsd
endm

descriptor macro parmlist:vararg
        _limit=0
        _base=0
        _g=0
        _x=0
        _l=0
        _p=1
        _dpl=0
        _c=0
        _r=-1
        _a=0
        _w=-1
        _ed=0
        _type=-1

        FOR p, <parmlist>
                ;rem    p
                _eqchar INSTR <p>, <=>
                _name SUBSTR <p>, 1, _eqchar-1
                _name2 TEXTEQU _name
                _value SUBSTR <p>, _eqchar+1
                _xerrno = 1

                FOR nm, <_limit,_base,_g,_x,_l,_p,_dpl,_c,_r,_a,_w,_ed,_type>
                        IFIDN _name2, <nm>
                                _xerrno=0
                        ENDIF
                ENDM
                IF _xerrno EQ 0
                                p
                ELSE
                        _emsg CATSTR <Wrong parameter name >, _name
                                .ERR _emsg
                ENDIF
        ENDM

        IF _limit LE 00100000h
                                dw      _limit MOD 10000h
        ELSE
                                dw      (_limit/4096) MOD 10000h
        ENDIF
                                dw      (_base) MOD 10000h
                                db      (_base/10000h) MOD 0100h
        IF _type NE -1
                IF (_type NE 0) AND (_type NE 1) AND (_type NE 9) AND (_type NE 3) AND (_type NE 11) AND (_type NE 2)
                                .ERR <Wrong type of system descriptor; can be 1,3,9,11 (TSS), 2 (LDT), 0 (x64 extended)>
                ELSE
                                db      (_p SHL 7) + (_dpl SHL 5) + (_type)
                ENDIF
        ELSE
                IF _r NE -1
                                db      (_p SHL 7) + (_dpl SHL 5) + 011000b + (_c SHL 2) + (_r SHL 1) + (_a)
                ELSE
                        IF _w NE -1
                                db      (_p SHL 7) + (_dpl SHL 5) + 010000b + (_ed SHL 2) + (_w SHL 1) + (_a)
                        ELSE
                                db      0
                        ENDIF
                ENDIF
        ENDIF
        IF _limit LE 00100000h
                                db      (_g SHL 7) + (_x SHL 6) + (_l SHL 5) + ((_limit SHR 16) MOD 10h)
        ELSE
                                db      10000000b + (_x SHL 6) + (_l SHL 5) + ((_limit SHR 28) MOD 10h)
        ENDIF
                                db      (_base SHR 24) MOD 0100h
endm

intdescriptor macro properties:vararg
        _offset=0
        _selector=0
        _t=0
        _use32=1
        _dpl=0
        _p=1

        for p, <properties>
                _sep instr <p>, <=>
                _name substr <p>, 1, _sep-1
                _valid=1
        for valid_name, <_offset, _selector, _t, _use32, _dpl, _p>
                ifidn _name, <valid_name>
                _valid=0
                endif
        endm
        if _valid eq 0
                p
        else
                _emsg catstr <Wrong parameter name >, _name
                .ERR _emsg
                endif
        endm

        dw _offset AND 0FFFFh
        dw _selector
        db 0
        db _t+6+(_use32 SHL 3)+(_dpl SHL 5)+(_p SHL 7)
        dw _offset SHR 16
endm
