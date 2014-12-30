
.code16
.section .text
.global start

.org 0

.macro EndOfInterrupt
       movb $0x20, %al
       outb %al, $PIC_C0
.endm

.macro KB_ANSWER_CHEAK answer
        call kb_wait_answer
        inb $0x60
        cmp \answer, %al
        jne on_error
.endm

PIC_C0=0x20 # command PIC 0
PIC_C1=0xA0 # command PIC 1
PIC_D0=0x21 # data PIC 0
PIC_D1=0xA1 # data PIC 1

start:
#	cli
#	mov	$0x9000, %sp
#	mov	%sp, %ss
#	mov	$0xFFFE, %sp
#	sti
        lss     %cs:STKPTR, %sp

        call    pic_init
        call	scanbios
        call	stop

pic_init:
        cli # запрещаем прерывания
        push %ax
        EndOfInterrupt
        outb $PIC_C1

        call    pit_init
        call    keyboard_init

        mov $0x11, %al # ICW 1
        outb $PIC_C0
        outb $PIC_C1

        mov $0x08, %al # ICW 2
        outb $PIC_D0

        mov $0x04, %al # ICW 3
        outb $PIC_D0

        mov $0x05, %al # ICW 4
        outb $PIC_D0



        mov $0x70, %al # ICW 2
        outb $PIC_D1

        mov $0x02, %al # ICW 3
        outb $PIC_D1

        mov $0x01, %al # ICW 4
        outb $PIC_D1

        mov $0xB8, %al # маска IRQ
        outb $PIC_D0

        mov $0x8F, %al # маска IRQ
        outb $PIC_D1

        pop %ax
        sti # разрешаем прерывания
        ret
#typedef struct Timer{
.equ TIMER_VALUE, 0x00
#}

pit_init:
        push %ax
        push %es

        xor %ax, %ax
        mov %ax, %es

        movw $int08_handler, %es:0x08*4
        mov  %cs, %es:0x08*4+2

        mov $0x40, %ax
        movw %ax, %es

        movb $0, %es:TIMER_VALUE
        #movb $0, %es:0x7C
        #110110
        # 0 - двоичный счётчик
        # 011 переодический генератор меандра
        # 11 - оба байта счётчика используюся
        mov $0b00110110, %al     #70 Hz
        outb $0x43 # управляющий регистр

        mov $17046, %ax
        outb $0x40
        mov %ah, %al
        outb $0x40

        pop %es
        pop %ax

        ret

#typedef struct Queue{
.equ    KB_QUEUE_CAP,   0x0F # 16 элементов
.equ    KB_QUEUE_COUNT, 0x04
.equ    KB_QUEUE_HEAD,  0x06
.equ    KB_QUEUE_TAIL,  0x08
.equ    KB_QUEUE_DATA,  0x0A # 40:0A - 40:4A KB_DATA
#}

kb_queue_init:
        push %ds
        push %dx

        mov $0x40, %dx
        mov %dx, %ds

        movw $0, %ds:KB_QUEUE_COUNT
        movw $0, %ds:KB_QUEUE_HEAD
        movw $0, %ds:KB_QUEUE_TAIL

        pop %dx
        pop %ds
        ret

kb_queue_push: # push al -> queue
        cli
        push %ds
        push %bx

        mov $0x40, %bx
        mov %bx, %ds

        movw %ds:KB_QUEUE_COUNT, %bx
        cmpw $KB_QUEUE_CAP, %bx   # if (CAP == COUNT)

        # обработка ошибки
        je push_err
        # ...

        mov %ds:KB_QUEUE_TAIL, %bx
        mov %al, %ds:KB_QUEUE_DATA(%bx)

        inc %bx
        movw %bx, %ds:KB_QUEUE_TAIL

        cmpw $KB_QUEUE_CAP, %bx
        jne l1
        movw $0, %ds:KB_QUEUE_TAIL
l1:
        incw %ds:KB_QUEUE_COUNT
push_err:
        pop %bx
        pop %ds
        sti
        ret

kb_queue_pop: # al <- queue
        cli
        push %ds
        push %bx

        mov $0x40, %bx
        mov %bx, %ds
        #if QueueEmpty ( q ): error "опустошение"
        movw %ds:KB_QUEUE_COUNT, %bx # if (COUNT == 0)
        cmpw %bx, 0x00
        # обработка ошибки
        je pop_err

        movw %ds:KB_QUEUE_HEAD, %bx
        movb %ds:KB_QUEUE_DATA(%bx), %al

        incw %bx
        movw %bx, %ds:KB_QUEUE_HEAD

        cmpw $KB_QUEUE_CAP, %bx
        jne l2
        movw $0x0, %ds:KB_QUEUE_HEAD
l2:
        decw %ds:KB_QUEUE_COUNT
pop_err:
        pop %bx
        pop %ds
        sti
        ret

kb_wait_free_buffer:
        mov $0xFFFF, %ecx
w0:     inb $0x64
        testb $2, %al
        jz w01
        
        dec %ecx
        jnz w0
        jz on_error
w01:
        ret

kb_wait_answer:
        mov $0x3000, %ecx
w1:     inb $0x64, %al
        testb $1, %al
        jz w11
        
        dec %ecx
        jnz w1
        jz on_error
w11:
        ret


keyboard_init:

        push %ax
        push %es
        push %cx
        push %dx
        mov %sp, %dx

        xor %ax, %ax
        mov %ax, %es

        movw $int09_handler, %es:0x09*4
        mov %cs, %es:0x09*4+2

        movw $int16_handler, %es:0x16*4
        mov %cs, %es:0x16*4+2

        call kb_queue_init
        
        call kb_wait_free_buffer
        mov $0xAA, %al
        outb $0x64
        KB_ANSWER_CHEAK $0x55

        call kb_wait_free_buffer
        mov $0xAB, %al
        outb $0x64
        KB_ANSWER_CHEAK $0x00


        call kb_wait_free_buffer
        mov $0xAE, %al
        outb $0x64

        call kb_wait_free_buffer
        mov $0xFF, %al
        outb $0x60
        KB_ANSWER_CHEAK $0xFA
        KB_ANSWER_CHEAK $0xAA

        call kb_wait_free_buffer
        mov $0xF5, %al
        outb $0x60
        KB_ANSWER_CHEAK $0xFA

        call kb_wait_free_buffer
        mov $0x60, %al
        outb $0x64


        call kb_wait_free_buffer
        mov $0x61, %al
        outb $0x60

        call kb_wait_free_buffer
        mov $0xF4, %al
        outb $0x60
        KB_ANSWER_CHEAK $0xFA

        #panic
        mov %dx, %sp
        pop %dx

        pop %cx
        pop %es
        pop %ax
        ret

on_error:
        jmp on_error

int08_handler:
        push %ax
        push %es

        mov  $0x40, %ax
        movw %ax, %es
        incl %es:TIMER_VALUE

        EndOfInterrupt

        pop %es
        pop %ax
        iret

int09_handler:
        push %ax
        push %bx

        mov $0xAD, %al
        outb $0x64
        xor %ax, %ax

        inb $0x60

skip1:  # Обработка
        call kb_queue_push

        EndOfInterrupt

        mov $0xAE, %al
        outb $0x64

        pop %bx
        pop %ax

        iret

int16_handler:
        iret

STKPTR: .word   0xFFFE,0x9000
	.long	0x55FFFFAA

scanbios:
        cli
	cld
        mov     $0xBF80, %dx
for:	addw    $0x80, %dx
check:  cmpw    $0xF000, %dx
        jae     skip

        mov	%dx, %ds
        xorw    %si, %si # обнуление si (source index)
        xorw    %cx, %cx # обнуление cx (counter)

        cmpw    $0xAA55, %ds:0
        jnz     for

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
        addw    $0x7F, %dx # округление dx к 0x80 вверх
        andw    $0xFF80, %dx
        jmp check
skip:
        sti
        ret


stop:   #cli # если случается NMI
        #hlt
        jmp     stop

# real startup entry begins at F000:FFF0
.section .ejump
	.byte   0xEA
	.word   start
	.word	0xF000

.org    0x0E
	.word   0x99FC

.end start
