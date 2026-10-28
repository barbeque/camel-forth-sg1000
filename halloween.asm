    head PUMPTEST, 8, PUMPTEST, docolon
        ; Enable metatile (16x16) sprites
        dw METATILESPRITESET
        ; Load the pumpkin sprite pattern data into VRAM
        dw PUMPKIN0, LIT, 0, SPRITEPATLOAD16
        ; Configure the pumpkin to appear
        dw LIT, 0x55, LIT, 0, SPRITEXSET16
        dw LIT, 0x55, LIT, 0, SPRITEYSET16
        dw LIT, 0x0a, LIT, 0, SPRITECOLOURSET16
        dw LIT, 0, LIT, 0, SPRITEPATTERNSET16
        dw EXIT

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

        ; TODO: Why is this not loading all the rows?

        ; write remaining 31 rows now that we have address latched
        .rept 31
        dw VDPDATASET ; HACK
        .endm
        
        dw EXIT

    ; SPRY! set Y-coordinate of a sprite
    head SPRITEYSET16, 7, SPRY16!, docolon
        dw SPRITEATTRIBPTR16
        ; Y-coordinate is first index, so don't add, just call
        dw VDPWRITE
        dw EXIT

    ; SPRX! set X-coordinate of a sprite
    head SPRITEXSET16, 7, SPRX16!, docolon
        dw SPRITEATTRIBPTR16
        ; X-coordinate is second index
        dw ONEPLUS
        dw VDPWRITE
        dw EXIT

    ; SPRPAT! set pattern index of a sprite
    head SPRITEPATTERNSET16, 9, SPRPAT16!, docolon
        dw SPRITEATTRIBPTR16
        ; pattern index is third index
        dw LIT, 2, PLUS
        dw VDPWRITE
        dw EXIT

    ; SPRCOL! set colour of a sprite
    head SPRITECOLOURSET16, 9, SPRCOL16!, docolon
        dw SPRITEATTRIBPTR16
        ; colour index is fourth index
        dw LIT, 3, PLUS
        dw VDPWRITE
        dw EXIT

; Sprite definitions
; Sorry they're so wasteful. I'm sure there's an easier way to read memory
; and put all the values on the stack, but I'm out of time.
    head PUMPKIN0, 8, PUMPKIN0, docolon
	DW LIT, $00, LIT, $00, LIT, $3c, LIT, $7f, LIT, $ff, LIT, $f7, LIT, $f3, LIT, $f3, LIT, $f3, LIT, $ff, LIT, $ff, LIT, $e4, LIT, $f0, LIT, $72, LIT, $3f, LIT, $1f, LIT, $00, LIT, $00, LIT, $3c, LIT, $fe, LIT, $ff, LIT, $ef, LIT, $cf, LIT, $cf, LIT, $cf, LIT, $ff, LIT, $ff, LIT, $27, LIT, $0f, LIT, $4e, LIT, $fc, LIT, $f8, EXIT
    head PUMPKIN1, 8, PUMPKIN1, docolon
	DW LIT, $00, LIT, $00, LIT, $3c, LIT, $7f, LIT, $ff, LIT, $df, LIT, $cf, LIT, $cf, LIT, $cf, LIT, $ff, LIT, $ff, LIT, $90, LIT, $c0, LIT, $49, LIT, $3f, LIT, $1f, LIT, $00, LIT, $00, LIT, $3c, LIT, $fe, LIT, $ff, LIT, $bf, LIT, $3f, LIT, $3f, LIT, $3f, LIT, $ff, LIT, $ff, LIT, $9f, LIT, $3f, LIT, $3e, LIT, $fc, LIT, $f8, EXIT
    head PUMPKIN2, 8, PUMPKIN2, docolon
	DW LIT, $00, LIT, $00, LIT, $3c, LIT, $7f, LIT, $ff, LIT, $7e, LIT, $3c, LIT, $3c, LIT, $3c, LIT, $ff, LIT, $ff, LIT, $42, LIT, $00, LIT, $24, LIT, $3f, LIT, $1f, LIT, $00, LIT, $00, LIT, $3c, LIT, $fe, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $7f, LIT, $ff, LIT, $fe, LIT, $fc, LIT, $f8, EXIT
    head PUMPKIN3, 8, PUMPKIN3, docolon
	DW LIT, $00, LIT, $00, LIT, $3c, LIT, $7f, LIT, $ff, LIT, $fb, LIT, $73, LIT, $73, LIT, $73, LIT, $ff, LIT, $ff, LIT, $09, LIT, $03, LIT, $13, LIT, $3f, LIT, $1f, LIT, $00, LIT, $00, LIT, $3c, LIT, $fe, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $fe, LIT, $fc, LIT, $f8, EXIT
    head PUMPKIN4, 8, PUMPKIN4, docolon
	DW LIT, $00, LIT, $00, LIT, $3c, LIT, $7f, LIT, $ff, LIT, $df, LIT, $9f, LIT, $9f, LIT, $9f, LIT, $ff, LIT, $ff, LIT, $cf, LIT, $9f, LIT, $1f, LIT, $3f, LIT, $1f, LIT, $00, LIT, $00, LIT, $3c, LIT, $fe, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $fe, LIT, $fc, LIT, $f8, EXIT
    head PUMPKIN5, 8, PUMPKIN5, docolon
	DW LIT, $00, LIT, $00, LIT, $3c, LIT, $7f, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $7f, LIT, $3f, LIT, $1f, LIT, $00, LIT, $00, LIT, $3c, LIT, $fe, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $fe, LIT, $fc, LIT, $f8, EXIT
    head PUMPKIN6, 8, PUMPKIN6, docolon
	DW LIT, $00, LIT, $00, LIT, $3c, LIT, $7f, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $7f, LIT, $3f, LIT, $1f, LIT, $00, LIT, $00, LIT, $3c, LIT, $fe, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $fe, LIT, $fc, LIT, $f8, EXIT
    head PUMPKIN7, 8, PUMPKIN7, docolon
	DW LIT, $00, LIT, $00, LIT, $3c, LIT, $7f, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $7f, LIT, $3f, LIT, $1f, LIT, $00, LIT, $00, LIT, $3c, LIT, $fe, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $fe, LIT, $fc, LIT, $f8, EXIT
    head PUMPKIN8, 8, PUMPKIN8, docolon
	DW LIT, $00, LIT, $00, LIT, $3c, LIT, $7f, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $7f, LIT, $3f, LIT, $1f, LIT, $00, LIT, $00, LIT, $3c, LIT, $fe, LIT, $ff, LIT, $fb, LIT, $f9, LIT, $f9, LIT, $f9, LIT, $ff, LIT, $ff, LIT, $f3, LIT, $f9, LIT, $f8, LIT, $fc, LIT, $f8, EXIT
    head PUMPKIN9, 8, PUMPKIN9, docolon
	DW LIT, $00, LIT, $00, LIT, $3c, LIT, $7f, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $7f, LIT, $3f, LIT, $1f, LIT, $00, LIT, $00, LIT, $3c, LIT, $fe, LIT, $ff, LIT, $df, LIT, $ce, LIT, $ce, LIT, $ce, LIT, $ff, LIT, $ff, LIT, $90, LIT, $c0, LIT, $c8, LIT, $fc, LIT, $f8, EXIT
    head PUMPKIN10, 9, PUMPKIN10, docolon
	DW LIT, $00, LIT, $00, LIT, $3c, LIT, $7f, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $fe, LIT, $ff, LIT, $7f, LIT, $3f, LIT, $1f, LIT, $00, LIT, $00, LIT, $3c, LIT, $fe, LIT, $ff, LIT, $7e, LIT, $3c, LIT, $3c, LIT, $3c, LIT, $ff, LIT, $ff, LIT, $42, LIT, $00, LIT, $24, LIT, $fc, LIT, $f8, EXIT
    head PUMPKIN11, 9, PUMPKIN11, docolon
	DW LIT, $00, LIT, $00, LIT, $3c, LIT, $7f, LIT, $ff, LIT, $fd, LIT, $fc, LIT, $fc, LIT, $fc, LIT, $ff, LIT, $ff, LIT, $f9, LIT, $fc, LIT, $7c, LIT, $3f, LIT, $1f, LIT, $00, LIT, $00, LIT, $3c, LIT, $fe, LIT, $ff, LIT, $fb, LIT, $f3, LIT, $f3, LIT, $f3, LIT, $ff, LIT, $ff, LIT, $09, LIT, $03, LIT, $92, LIT, $fc, LIT, $f8, EXIT

    head PUMPKINSHAD, 7, PSHADOW, docolon
        DW LIT, $01, LIT, $01, LIT, $3f, LIT, $7f, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $7f, LIT, $3f, LIT, $1f, LIT, $80, LIT, $80, LIT, $fc, LIT, $fe, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $fe, LIT, $fc, LIT, $f8, EXIT