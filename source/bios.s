
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
	mov     $0xC000, %si
	mov	%si, %ds

	xorw    %si, %si
	xorw    %cx, %cx
	movb    %ds:2, %ch
	xorb    %bl, %bl

  1:	lodsw
	addb    %ah, %al
	addb    %al, %bl
	decw    %cx
	jnz     1b

	or      %bl, %bl
	jnz     3f

	pusha
	push    %ds
	push    %es
	push    %fs
	push    %gs

	push    %cs
	push    $2f
	push    %ds
	push    $0x03
	lret
  2:
	pop     %gs
	pop     %fs
	pop     %es
	pop     %ds
	popa

  3:	ret


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
