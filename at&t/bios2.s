
.code16
.section .text
.global start

.org 0

start:
#	cli
#	mov	$0x9000, %sp
#	mov	%sp, %ss
#	mov	$0xFFFE, %sp
#	sti
	lss     %cs:STKPTR, %sp

	call	scanbios
	call	stop

STKPTR: .word   0xFFFE,0x9000
	.long	0x55FFFFAA

scanbios:
	cld
        mov     $0xC000, %dx
for:	mov	%dx, %ds
        xorw    %si, %si # обнуление si (source index)
        xorw    %cx, %cx # обнуление cx (counter)
        cmpw    $0xAA55, %ds:0
        jnz     next

        movb    %ds:2, %ch
        xorb    %bl, %bl # обнуление bl (base reg)

chcksm:	lodsw # грузим слово в AX
	addb    %ah, %al 
	addb    %al, %bl
        decw    %cx
	jnz     chcksm

	or      %bl, %bl
        jnz     round # всё плохо (модуль не нулевой), улетаем к округлению размера

        # всё хорошо - дальний вызов
	pusha # сохраняем  ax, cx, dx, bx, sp, bp, si, di
	push    %ds
	push    %es
	push    %fs
	push    %gs

	push    %cs # улетам фиг знает куда long jump
	push    $__ret
	push    %ds
	push    $0x03
	lret
__ret:
	pop     %gs
	pop     %fs
	pop     %es
	pop     %ds
        popa

round:  shrw    $4, %si  # достаём смещение и преобразовываем к сегменту
        addw    %si, %dx
        addw    $0x7f, %dx # округление dx к 0x80 вверх
        andw    $0xFF80, %dx
        jmp check
next:   addw    $0x80, %dx

check:  cmpw    $0xF000, %dx
        jb      for # > беззнаковое

	ret


stop:   cli
	hlt
	jmp     stop



# real startup entry begins at F000:FFF0
.section .ejump
	.byte   0xEA
	.word   start
	.word	0xF000

.org    0x0E
	.word   0x99FC

.end start
