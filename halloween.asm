    head SPRITEPATLOAD16, 9, SPRLOAD16, docolon
        ; (d15 .. d7 d6 d5 d4 d3 d2 d1 d0 idx -- )
        
        ; Set address once and then just blast data for the rest?
        ; Address autoincrements on TMS9918 after a write.
        
        ; for 16x16, use (pattern AND 252) times 8 + start of pattern memory
        dw LIT, 252, AND, LIT, 8, STAR
        dw VDPSPRITEPATTERNS, PLUS
        dw VDPWRITE

        ; write remaining 15 rows now that we have address latched
        .rept 15
        dw VDPDATASET ; HACK
        .endm
        
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
    head PUMPKIN10, 8, PUMPKIN10, docolon
	DW LIT, $00, LIT, $00, LIT, $3c, LIT, $7f, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $fe, LIT, $ff, LIT, $7f, LIT, $3f, LIT, $1f, LIT, $00, LIT, $00, LIT, $3c, LIT, $fe, LIT, $ff, LIT, $7e, LIT, $3c, LIT, $3c, LIT, $3c, LIT, $ff, LIT, $ff, LIT, $42, LIT, $00, LIT, $24, LIT, $fc, LIT, $f8, EXIT
    head PUMPKIN11, 8, PUMPKIN11, docolon
	DW LIT, $00, LIT, $00, LIT, $3c, LIT, $7f, LIT, $ff, LIT, $fd, LIT, $fc, LIT, $fc, LIT, $fc, LIT, $ff, LIT, $ff, LIT, $f9, LIT, $fc, LIT, $7c, LIT, $3f, LIT, $1f, LIT, $00, LIT, $00, LIT, $3c, LIT, $fe, LIT, $ff, LIT, $fb, LIT, $f3, LIT, $f3, LIT, $f3, LIT, $ff, LIT, $ff, LIT, $09, LIT, $03, LIT, $92, LIT, $fc, LIT, $f8, EXIT

    head PUMPKINSHAD, 7, PSHADOW, docolon
        DW LIT, $01, LIT, $01, LIT, $3f, LIT, $7f, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $7f, LIT, $3f, LIT, $1f, LIT, $80, LIT, $80, LIT, $fc, LIT, $fe, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $ff, LIT, $fe, LIT, $fc, LIT, $f8, EXIT