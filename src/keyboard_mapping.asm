mapping macro scancode, symbol
local next
       cmp al, scancode
       jne next
       mov ah, symbol
       jmp convert_exit
next:
endm

mapping_command macro scancode, command
local next
       cmp al, scancode
       jne next
       call command
       jmp convert_exit
next:
endm

if_key_on macro bit_on, label
local next
       test cx, bit_on
       jne next
       jmp label
next:
endm

KEY_Q_DOWN=10h
KEY_W_DOWN=11h
KEY_E_DOWN=12h
KEY_R_DOWN=13h
KEY_T_DOWN=14h
KEY_Y_DOWN=15h
KEY_U_DOWN=16h
KEY_I_DOWN=17h
KEY_O_DOWN=18h
KEY_P_DOWN=19h
KEY_LBracket_DOWN=1Ah
KEY_RBracket_DOWN=1Bh
KEY_A_DOWN=1Eh
KEY_S_DOWN=1Fh
KEY_D_DOWN=20h
KEY_F_DOWN=21h
KEY_G_DOWN=22h
KEY_H_DOWN=23h
KEY_J_DOWN=24h
KEY_K_DOWN=25h
KEY_L_DOWN=26h
KEY_SemiColon_DOWN=27h
KEY_Quote_DOWN=028h
KEY_Space_DOWN=039h
KEY_Z_DOWN=2Ch
KEY_X_DOWN=2Dh
KEY_C_DOWN=2Eh
KEY_V_DOWN=2Fh
KEY_B_DOWN=30h
KEY_N_DOWN=31h
KEY_M_DOWN=32h
KEY_Comma_DOWN=33h
KEY_Period_DOWN=34h
KEY_Slash_DOWN=35h
KEY_LEFT_SHIFT_DOWN=2Ah
KEY_LEFT_SHIFT_UP=0AAh

KEY_RIGHT_SHIFT_DOWN=36h
KEY_RIGHT_SHIFT_UP=0B6h

KEY_0=0Bh
KEY_1=02h
KEY_2=03h
KEY_3=04h
KEY_4=05h
KEY_5=06h
KEY_6=07h
KEY_7=08h
KEY_8=09h
KEY_9=0Ah

KEY_NUMPAD_0=52h
KEY_NUMPAD_1=4fh
KEY_NUMPAD_2=50h
KEY_NUMPAD_3=51h
KEY_NUMPAD_4=4bh
KEY_NUMPAD_5=4ch
KEY_NUMPAD_6=4dh
KEY_NUMPAD_7=47h
KEY_NUMPAD_8=48h
KEY_NUMPAD_9=49h
KEY_TAB=0Fh
KEY_BACKSPACE=0Eh
KEY_ENTER=1Ch
KEY_SHIFT_ON         =00000001b
KEY_SHIFT_OFF        =11111110b
KEY_CAPSLOCK_ON      =00000010b
KEY_CAPSLOCK_OFF     =11111101b
KEY_SHIFT_AND_CAPS_ON=00000011b

KEY_CAPSLOCK_DOWN=3Ah

shift_on proc near
       push cx
       or cx, KEY_SHIFT_ON
       mov word ptr ds:[KB_BUTTON_FLAG], cx
       pop cx
       ret
shift_on endp

shift_off proc near
       push cx
       and cx, KEY_SHIFT_OFF
       mov word ptr ds:[KB_BUTTON_FLAG], cx
       pop cx
       ret
shift_off endp

capslock_on proc near
       push cx
       or cx, KEY_CAPSLOCK_ON
       mov word ptr ds:[KB_BUTTON_FLAG], cx
       pop cx
       ret
capslock_on endp

capslock_off proc near
       push cx
       and cx, KEY_CAPSLOCK_OFF
       mov word ptr ds:[KB_BUTTON_FLAG], cx
       pop cx
       ret
capslock_off endp

key_tab_func proc near
       PutString "    "
       ret
key_tab_func endp

key_backspace_func proc near
       push ebx

       mov bx, word ptr ds:[VM_POS]
       test bx, bx
       jnz @f
       mov bx, VM_SIZE
@@:
       lea ebx, [ebx-2]
       mov word ptr ds:[VM_POS], bx
       mov byte ptr gs:[ebx], ' '

       call updatecursor
       pop ebx
       ret
key_backspace_func endp

key_enter_func proc near
       NEWLINE
       ret
key_enter_func endp


convert proc near
       push cx
       mov ah, 0FFh
       mov cx, word ptr ds:[KB_BUTTON_FLAG]


       mapping_command KEY_LEFT_SHIFT_DOWN, shift_on
       mapping_command KEY_LEFT_SHIFT_UP,   shift_off
       mapping_command KEY_RIGHT_SHIFT_DOWN, shift_on
       mapping_command KEY_RIGHT_SHIFT_UP,   shift_off
       
       mapping_command KEY_ENTER, key_enter_func
       mapping_command KEY_TAB, key_tab_func
       mapping_command KEY_BACKSPACE, key_backspace_func

       mapping KEY_NUMPAD_0, '0'
       mapping KEY_NUMPAD_1, '1'
       mapping KEY_NUMPAD_2, '2'
       mapping KEY_NUMPAD_3, '3'
       mapping KEY_NUMPAD_4, '4'
       mapping KEY_NUMPAD_5, '5'
       mapping KEY_NUMPAD_6, '6'
       mapping KEY_NUMPAD_7, '7'
       mapping KEY_NUMPAD_8, '8'
       mapping KEY_NUMPAD_9, '9'
       mapping KEY_0, '0'
       mapping KEY_1, '1'
       mapping KEY_2, '2'
       mapping KEY_3, '3'
       mapping KEY_4, '4'
       mapping KEY_5, '5'
       mapping KEY_6, '6'
       mapping KEY_7, '7'
       mapping KEY_8, '8'
       mapping KEY_9, '9'
       
       
       mapping KEY_Space_DOWN, ' '
       if_key_on KEY_SHIFT_AND_CAPS_ON, convert_shift_up
       if_key_on KEY_SHIFT_ON,    convert_shitf_down
       if_key_on KEY_CAPSLOCK_ON, convert_shitf_down
convert_shift_up:
       mapping_command KEY_CAPSLOCK_DOWN, capslock_on
       mapping KEY_Q_DOWN, 'q'
       mapping KEY_W_DOWN, 'w'
       mapping KEY_E_DOWN, 'e'
       mapping KEY_R_DOWN, 'r'
       mapping KEY_T_DOWN, 't'
       mapping KEY_Y_DOWN, 'y'
       mapping KEY_U_DOWN, 'u'
       mapping KEY_I_DOWN, 'i'
       mapping KEY_O_DOWN, 'o'
       mapping KEY_P_DOWN, 'p'
       mapping KEY_A_DOWN, 'a'
       mapping KEY_S_DOWN, 's'
       mapping KEY_D_DOWN, 'd'
       mapping KEY_F_DOWN, 'f'
       mapping KEY_G_DOWN, 'g'
       mapping KEY_H_DOWN, 'h'
       mapping KEY_J_DOWN, 'j'
       mapping KEY_K_DOWN, 'k'
       mapping KEY_L_DOWN, 'l'
       mapping KEY_Z_DOWN, 'z'
       mapping KEY_X_DOWN, 'x'
       mapping KEY_C_DOWN, 'c'
       mapping KEY_V_DOWN, 'v'
       mapping KEY_B_DOWN, 'b'
       mapping KEY_N_DOWN, 'n'
       mapping KEY_M_DOWN, 'm'
       mapping KEY_LBracket_DOWN, '['
       mapping KEY_RBracket_DOWN, ']'
       mapping KEY_Comma_DOWN, ','
       mapping KEY_Period_DOWN, '.'
       mapping KEY_Slash_DOWN, '/'
       mapping KEY_SemiColon_DOWN, ';'
       mapping KEY_Quote_DOWN, 027h ; '
       jmp convert_exit
convert_shitf_down:
       mapping_command KEY_CAPSLOCK_DOWN, capslock_off

       mapping KEY_Q_DOWN, 'Q'
       mapping KEY_W_DOWN, 'W'
       mapping KEY_E_DOWN, 'E'
       mapping KEY_R_DOWN, 'R'
       mapping KEY_T_DOWN, 'T'
       mapping KEY_Y_DOWN, 'Y'
       mapping KEY_U_DOWN, 'U'
       mapping KEY_I_DOWN, 'I'
       mapping KEY_O_DOWN, 'O'
       mapping KEY_P_DOWN, 'P'
       mapping KEY_A_DOWN, 'A'
       mapping KEY_S_DOWN, 'S'
       mapping KEY_D_DOWN, 'D'
       mapping KEY_F_DOWN, 'F'
       mapping KEY_G_DOWN, 'G'
       mapping KEY_H_DOWN, 'H'
       mapping KEY_J_DOWN, 'J'
       mapping KEY_K_DOWN, 'K'
       mapping KEY_L_DOWN, 'L'
       mapping KEY_Z_DOWN, 'Z'
       mapping KEY_X_DOWN, 'X'
       mapping KEY_C_DOWN, 'C'
       mapping KEY_V_DOWN, 'V'
       mapping KEY_B_DOWN, 'B'
       mapping KEY_N_DOWN, 'N'
       mapping KEY_M_DOWN, 'M'
       mapping KEY_LBracket_DOWN, '{'
       mapping KEY_RBracket_DOWN, '}'
       mapping KEY_Comma_DOWN, '<'
       mapping KEY_Period_DOWN, '>'
       mapping KEY_Slash_DOWN, '?'
       mapping KEY_SemiColon_DOWN, ':'
       mapping KEY_Quote_DOWN, '"'

convert_exit:
       pop cx
       ret
convert endp
