PDPT=0600000h
PD  =0601000h
ZERO_PAGE =0A00000h
CODE_PLACE=0AF0000h
STACK_PLACE=0400000h
BDA_PLACE=  0000400h
TMP_PAGE=0800000h
CODE_PLACE_PHYSICAL=0F0000h
STACK_PLACE_PHYSICAL=09F000h
BDA_PLACE_PHYSICAL=  000400h
BDA_PLACE_NEW_PHYSICAL=0200000h
VM_PAGE=ZERO_PAGE
;typedef struct Timer{
TIMER_VALUE = 400h
;}

;typedef struct Queue{
KB_QUEUE_CAP   =  0Fh; 16 элементов
KB_QUEUE_COUNT =  404h
KB_QUEUE_HEAD  =  406h
KB_QUEUE_TAIL  =  408h
KB_QUEUE_DATA  =  40Ah ; 40:0A - 40:4A KB_DATA
KB_TIMEOUT     =  450h
KB_BUTTON_FLAG =  452h;
;}

;typedef struct Video{
VM_POS = 460h 
VM_BASE=0B8000h + VM_PAGE
VM_SIZE = 4000
;}


GDT_MEM_POS=1000h
IDT_MEM_POS=1500h


PIC_C0 = 020h ; command PIC 0
PIC_C1 = 0A0h ; command PIC 1
PIC_D0 = 021h ; data PIC 0
PIC_D1 = 0A1h ; data PIC 1
CMOS_REG=070h
SYS_CONTROL_PORT_A=92h



