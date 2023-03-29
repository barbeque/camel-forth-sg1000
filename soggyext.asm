; Soggy/SG-1000 specific words
    rchead IS_SOGGY, 5, 'SOGGY?'
        push bc ; push old TOS
        
        push hl
        is_soggy_v3
        pop hl

        ld b, 0
        ld c, a ; store the result on the top of the stack

        next
