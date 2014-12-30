;typedef struct Timer{
TIMER_VALUE equ 400h
;}

;typedef struct Queue{
KB_QUEUE_CAP   equ  00Fh ; 16 элементов
KB_QUEUE_COUNT equ  404h
KB_QUEUE_HEAD  equ  406h
KB_QUEUE_TAIL  equ  408h
KB_QUEUE_DATA  equ  40Ah ; 40:0A - 40:4A KB_DATA
KB_TIMEOUT     equ  450h
KB_BUTTON_FLAG equ  452h;
;}

;typedef struct Video{
VM_POS equ 060h
VM_BASE equ 0B800h
VM_SIZE equ 4000
;}

GDT_MEM_POS equ 1000h
IDT_MEM_POS equ 1500h


PIC_C0 equ 020h ; command PIC 0
PIC_C1 equ 0A0h ; command PIC 1
PIC_D0 equ 021h ; data PIC 0
PIC_D1 equ 0A1h ; data PIC 1
CMOS_REG=070h
SYS_CONTROL_PORT_A=92h
