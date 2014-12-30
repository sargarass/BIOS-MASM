stop    proc near
        ClearWindow
        PutString "Hello world"
        NewLine
.while_:
        call getchar
        call putchar
        jmp .while_
.exit_:
        ClearWindow
        PutString "|___|___|___|___|___|___|___|___|___|___|___|___|"
        NewLine
        PutString "__|___|___|___|___|___|___|___|___|___|___|___|___"
        NewLine
        PutString "|___|___|___|___|___|___|___|___|___|___|___|___|"
        NewLine
        PutString "__|___|___|___|_bitsya galavoi suda___|___|___|___"
        NewLine
        PutString "|___|___|___|___|___|___|___|___|___|___|___|___|"
        NewLine
        PutString "__|___|___|___|___|___|___|___|___|___|___|___|___"
        NewLine
        PutString "|___|___|___|___|___|___|___|___|___|___|___|___|"
        NewLine
        cli
        hlt
        jmp .exit_
stop    endp
