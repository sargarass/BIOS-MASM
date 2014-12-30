GDT:
DESCRIPTOR
CS_dsc:	DESCRIPTOR	_limit=0FFFFFFFFh, _base=000000h,	_r=1, _x=1	; код
DS_dsc:	DESCRIPTOR	_limit=0FFFFFFFFh, _base=000000h,	_w=1,           ; данные
GS_dsc:	DESCRIPTOR	_limit=0FFFFFFFFh, _base=000000h,	_w=1, 		; видео
SS_dsc:	DESCRIPTOR      _limit=0FFFFFFFFh, _base=000000h,	_w=1, _x=1	; стек
DESCRIPTOR _base=0F0000h, _r=1, _g=1, _x=0, _limit=0Fh
GDT_SIZE equ $ - GDT
gdtr:
dw	GDT_SIZE - 1						; Table Limit
dd	GDT_MEM_POS
