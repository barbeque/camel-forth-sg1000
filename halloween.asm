    macro newpump #index, #x, #y
        ; Configure the pumpkin to appear (sprite 2)
        dw LIT, #x, LIT, #index, SPRITEXSET
        dw LIT, #y, LIT, #index, SPRITEYSET
        dw LIT, 0x0a, LIT, #index, SPRITECOLOURSET
        dw LIT, 0, LIT, #index, SPRITEPATTERNSET ; 0 x 4
        ; Configure the shadow to appear (sprite 3)
        dw LIT, #x, LIT, #index + 1, SPRITEXSET
        dw LIT, #y, LIT, #index + 1, SPRITEYSET
        dw LIT, 0x01, LIT, #index + 1 , SPRITECOLOURSET
        dw LIT, 48, LIT, #index + 1, SPRITEPATTERNSET ; 12 x 4
    endm

    head PUMPTEST, 8, PUMPTEST, docolon
        ; Enable metatile (16x16) sprites
        dw METATILESPRITESET
        ; Load the pumpkin sprite pattern data into VRAM
        dw PUMPKIN0, LIT, 0, SPRITEPATLOAD16
        dw PUMPKIN1, LIT, 1, SPRITEPATLOAD16
        dw PUMPKIN2, LIT, 2, SPRITEPATLOAD16
        dw PUMPKIN3, LIT, 3, SPRITEPATLOAD16
        dw PUMPKIN4, LIT, 4, SPRITEPATLOAD16
        dw PUMPKIN5, LIT, 5, SPRITEPATLOAD16
        dw PUMPKIN6, LIT, 6, SPRITEPATLOAD16
        dw PUMPKIN7, LIT, 7, SPRITEPATLOAD16
        dw PUMPKIN8, LIT, 8, SPRITEPATLOAD16
        dw PUMPKIN9, LIT, 9, SPRITEPATLOAD16
        dw PUMPKIN10, LIT, 10, SPRITEPATLOAD16
        dw PUMPKIN11, LIT, 11, SPRITEPATLOAD16
        dw PUMPKINSHADOW, LIT, 12, SPRITEPATLOAD16
        
        ; Set up some pumpkin sprites at n (body) and n+1 (shadow)
        newpump 0, $55, $55
        newpump 2, $65, $65
        newpump 4, $75, $75
        newpump 6, $85, $85

        dw EXIT

    ; Get the next pattern for a pumpkin after the current one
    ; ( frame -- frame )
    ; 0 -> 4, 4 -> 8, etc.
    ; 48 -> 0
    chead NEXTPUMPFRAME, 7, NPUMPKIN
#local
        ld a, c
        cp a, 44
        jr z, start_over
step:
        add 4
        ld c, a
        jr all_done
start_over:
        ld c, 0
all_done:
        ld b, 0 ; for insurance
#endlocal
        next

    ; Advance a pumpkin at sprite index to the next frame,
    ; wrapping around if necessary
    ; ( sprite_idx -- )
    head STEPPUMP, 8, STEPPUMP, docolon
        dw DUP ; make sure the index sticks around
        dw SPRITEPATGET ; now TOS = the sprite pattern number
        dw NEXTPUMPFRAME ; TOS = the NEW sprite pattern number
        dw SWOP ; put it back in {pattern} {index} order
        dw SPRITEPATTERNSET
        dw EXIT
        
    ; Get the current pattern of a sprite
    ; ( sprite_idx -- pattern_idx )
    head SPRITEPATGET, 7, SPRPAT@, docolon
        dw SPRITEATTRIBPTR
        dw LIT, 2, PLUS ; pattern number is 3rd item
        dw VDPREAD
        dw EXIT

    head DANCE, 5, DANCE, docolon
        dw BEGIN
        dw LIT, 0, STEPPUMP
        dw PAUSE
        dw REPEAT
        dw EXIT

    ; Busy-wait for the animation
    chead PAUSE, 5, PAUSE
        ld hl, $1337
#local
_busywait_inner:
        dec hl
        ld a,h
        or l
        jr nz, _busywait_inner
#endlocal
        next

    ; Get the VDP memory address for sprite patterns for a 16x16 sprite
    ; ( sprite_idx -- )
    head SPRPATADDR16, 9, SPRADDR16, docolon
        dw LIT, 32, STAR
        dw VDPSPRITEPATTERNS, PLUS
        dw EXIT

    ; Get the attribute pointer for sprite attributes for a 16x16 sprite
    head SPRITEATTRIBPTR16, 8, SPRPTR16, docolon
        ; Calculate offset into VDP memory for a sprite's
        ; attribute data, based on the index
        dw LIT, 252, AND, LIT, 8, STAR
        dw VDPSPRITEATTRIBS, PLUS
        dw EXIT

    ; Load a 16x16 sprite into memory at a given index
    head SPRITEPATLOAD16, 9, SPRLOAD16, docolon
        ; (d31 .. d7 d6 d5 d4 d3 d2 d1 d0 sprite_idx -- )
        
        ; Set address once and then just blast data for the rest.
        ; Address autoincrements on TMS9918 after a write.
        dw SPRPATADDR16
        dw VDPWRITE

        ; write remaining 31 rows now that we have address latched
        .rept 31
        dw VDPDATASET ; HACK
        .endm
        
        dw EXIT

; Sprite definitions
; Sorry they're so wasteful. I'm sure there's an easier way to read memory
; and put all the values on the stack, but I'm out of time.
    head PUMPKIN0, 8, PUMPKIN0, docolon
	DW LIT, $f8, LIT, $fc, LIT, $4e, LIT, $0f, LIT, $27, LIT, $ff, LIT, $ff, LIT, $cf, LIT, $cf, LIT, $cf, LIT, $ef, LIT, $ff, LIT, $fe, LIT, $3c, LIT, $00, LIT, $00, LIT, $1f, LIT, $3f, LIT, $72, LIT, $f0, LIT, $e4, LIT, $ff, LIT, $ff, LIT, $f3, LIT, $f3, LIT, $f3, LIT, $f7, LIT, $ff, LIT, $7f, LIT, $3c, LIT, $00, LIT, $00, EXIT
    head PUMPKIN1, 8, PUMPKIN1, docolon
	DW LIT, $f8, LIT, $fc, LIT, $3e, LIT, $3f, LIT, $9f, LIT, $ff, LIT, $ff, LIT, $3f, LIT, $3f, LIT, $3f, LIT, $bf, LIT, $ff, LIT, $fe, LIT, $3c, LIT, $00, LIT, $00, LIT, $1f, LIT, $3f, LIT, $49, LIT, $c0, LIT, $90, LIT, $ff, LIT, $ff, LIT, $cf, LIT, $cf, LIT, $cf, LIT, $df, LIT, $ff, LIT, $7f, LIT, $3c, LIT, $00, LIT, $00, EXIT
    head PUMPKIN2, 8, PUMPKIN2, docolon
	DW LIT, $f8, LIT, $fc, LIT, $fe, LIT, $ff, LIT, $7f, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $fe, LIT, $3c, LIT, $00, LIT, $00, LIT, $1f, LIT, $3f, LIT, $24, LIT, $00, LIT, $42, LIT, $ff, LIT, $ff, LIT, $3c, LIT, $3c, LIT, $3c, LIT, $7e, LIT, $ff, LIT, $7f, LIT, $3c, LIT, $00, LIT, $00, EXIT
    head PUMPKIN3, 8, PUMPKIN3, docolon
	DW LIT, $f8, LIT, $fc, LIT, $fe, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $fe, LIT, $3c, LIT, $00, LIT, $00, LIT, $1f, LIT, $3f, LIT, $13, LIT, $03, LIT, $09, LIT, $ff, LIT, $ff, LIT, $73, LIT, $73, LIT, $73, LIT, $fb, LIT, $ff, LIT, $7f, LIT, $3c, LIT, $00, LIT, $00, EXIT
    head PUMPKIN4, 8, PUMPKIN4, docolon
	DW LIT, $f8, LIT, $fc, LIT, $fe, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $fe, LIT, $3c, LIT, $00, LIT, $00, LIT, $1f, LIT, $3f, LIT, $1f, LIT, $9f, LIT, $cf, LIT, $ff, LIT, $ff, LIT, $9f, LIT, $9f, LIT, $9f, LIT, $df, LIT, $ff, LIT, $7f, LIT, $3c, LIT, $00, LIT, $00, EXIT
    head PUMPKIN5, 8, PUMPKIN5, docolon
	DW LIT, $f8, LIT, $fc, LIT, $fe, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $fe, LIT, $3c, LIT, $00, LIT, $00, LIT, $1f, LIT, $3f, LIT, $7f, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $7f, LIT, $3c, LIT, $00, LIT, $00, EXIT
    head PUMPKIN6, 8, PUMPKIN6, docolon
	DW LIT, $f8, LIT, $fc, LIT, $fe, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $fe, LIT, $3c, LIT, $00, LIT, $00, LIT, $1f, LIT, $3f, LIT, $7f, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $7f, LIT, $3c, LIT, $00, LIT, $00, EXIT
    head PUMPKIN7, 8, PUMPKIN7, docolon
	DW LIT, $f8, LIT, $fc, LIT, $fe, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $fe, LIT, $3c, LIT, $00, LIT, $00, LIT, $1f, LIT, $3f, LIT, $7f, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $7f, LIT, $3c, LIT, $00, LIT, $00, EXIT
    head PUMPKIN8, 8, PUMPKIN8, docolon
	DW LIT, $f8, LIT, $fc, LIT, $f8, LIT, $f9, LIT, $f3, LIT, $ff, LIT, $ff, LIT, $f9, LIT, $f9, LIT, $f9, LIT, $fb, LIT, $ff, LIT, $fe, LIT, $3c, LIT, $00, LIT, $00, LIT, $1f, LIT, $3f, LIT, $7f, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $7f, LIT, $3c, LIT, $00, LIT, $00, EXIT
    head PUMPKIN9, 8, PUMPKIN9, docolon
	DW LIT, $f8, LIT, $fc, LIT, $c8, LIT, $c0, LIT, $90, LIT, $ff, LIT, $ff, LIT, $ce, LIT, $ce, LIT, $ce, LIT, $df, LIT, $ff, LIT, $fe, LIT, $3c, LIT, $00, LIT, $00, LIT, $1f, LIT, $3f, LIT, $7f, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $7f, LIT, $3c, LIT, $00, LIT, $00, EXIT
    head PUMPKIN10, 9, PUMPKIN10, docolon
	DW LIT, $f8, LIT, $fc, LIT, $24, LIT, $00, LIT, $42, LIT, $ff, LIT, $ff, LIT, $3c, LIT, $3c, LIT, $3c, LIT, $7e, LIT, $ff, LIT, $fe, LIT, $3c, LIT, $00, LIT, $00, LIT, $1f, LIT, $3f, LIT, $7f, LIT, $ff, LIT, $fe, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $7f, LIT, $3c, LIT, $00, LIT, $00, EXIT
    head PUMPKIN11, 9, PUMPKIN11, docolon
	DW LIT, $f8, LIT, $fc, LIT, $92, LIT, $03, LIT, $09, LIT, $ff, LIT, $ff, LIT, $f3, LIT, $f3, LIT, $f3, LIT, $fb, LIT, $ff, LIT, $fe, LIT, $3c, LIT, $00, LIT, $00, LIT, $1f, LIT, $3f, LIT, $7c, LIT, $fc, LIT, $f9, LIT, $ff, LIT, $ff, LIT, $fc, LIT, $fc, LIT, $fc, LIT, $fd, LIT, $ff, LIT, $7f, LIT, $3c, LIT, $00, LIT, $00, EXIT
    head PUMPKINSHADOW, 7, PSHADOW, docolon
        DW LIT, $f8, LIT, $fc, LIT, $fe, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $fe, LIT, $fc, LIT, $80, LIT, $80, LIT, $1f, LIT, $3f, LIT, $7f, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $7f, LIT, $3f, LIT, $01, LIT, $01, EXIT