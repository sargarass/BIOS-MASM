idtr2:
dw (IDT_SIZE - 1)
dd (CODE_PLACE + IDT_MEM_POS - CODE_PLACE_PHYSICAL)

gdtr2:
dw (GDT_SIZE - 1)
dd (CODE_PLACE + GDT_MEM_POS - CODE_PLACE_PHYSICAL)

PAGEMODE_START=$
pagemode2:
        copy_data  BDA_PLACE_PHYSICAL, BDA_PLACE_NEW_PHYSICAL, 256
        map_linear BDA_PLACE, BDA_PLACE_NEW_PHYSICAL
        map_linear CODE_PLACE, CODE_PLACE_PHYSICAL
        map_linear STACK_PLACE, STACK_PLACE_PHYSICAL
        map_linear TMP_PAGE, TMP_PAGE
        map_linear PDPT, PDPT
; Включаем PAE
        mov eax, cr4
        bts eax, 5
        mov cr4, eax
; Включаем Страничную адрессацию
        mov eax, PDPT
        mov cr3, eax
        mov eax,cr0
        or eax, 80000000h
        mov cr0,eax

        add esp, STACK_PLACE
        lgdt fword ptr [gdtr2 + CODE_PLACE]
        lidt fword ptr [idtr2 + CODE_PLACE]

        retf_to_page ZERO_PAGE
PAGEMODE_SIZE=$-PAGEMODE_START

pagemode proc near
        copy_data <PAGEMODE_START + CODE_PLACE_PHYSICAL>, TMP_PAGE, PAGEMODE_SIZE
        call_far <TMP_PAGE + pagemode2 - PAGEMODE_START>
        clear_data TMP_PAGE, PAGEMODE_SIZE
        map_clear TMP_PAGE
        map_clear PDPT
        xchg bx,bx
        ret_to_page ZERO_PAGE
pagemode endp
