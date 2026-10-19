; Soggy-specific functionality
    rchead IS_SOGGY, 6, 'SOGGY?'
        push bc ; push old TOS
        
        push hl
        is_soggy_v3
        pop hl

        ld b, 0
        ld c, a ; store the result on the top of the stack

        next

    ; PSG data/control register
    head PSGPORT,7,PSGPORT,docolon
        dw lit,PSG_REGISTERS,EXIT

    ; VDP data register
    head VDPDATA,7,VDPDATA,docolon
        dw lit,VDP_DATA,EXIT

    ; VDP control register
    head VDPCTRL,7,VDPCTRL,docolon
        dw lit,VDP_REGISTERS,EXIT

    ; PSG words

    ; Set volume of a channel
    chead PSGVOLUMESET, 6, PSGVOL
        pop hl ; data in HL
        
        ; channel in C
        ld a, c
        and $3 ; cut to two bits
        rl a ; shift left one
        or %1001 ; "latch" bit and "volume" bit

        ; ...put channel in upper nibble
        rl a
        rl a
        rl a
        rl a
        ld c, a ; store this for a second
        
        ; ...put data portion in lower nibble
        ld a, l
        and $f
        or c
        
        out (PSG_REGISTERS), a

        pop bc ; pop new TOS
        next

    ; Make the PSG latch the upper 4 bits of tone data (or all of noise data)
    chead PSGLATCHSET, 8, PSGLATCH
        pop hl ; noise data in HL
        
        ; channel in C
        ld a, c
        and $3 ; cut to two bits
        rl a ; shift left one
        or %1000 ; "latch" bit set and unset "tone/noise" bit

        ; ...put channel in upper nibble
        rl a
        rl a
        rl a
        rl a
        ld c, a ; store this for a second
        
        ; ...put data portion in lower nibble
        ld a, l
        and $f ; noise is only 3-bits long, but the top bit is ignored;
        ; tone data will need all 4-bits
        or c
        
        out (PSG_REGISTERS), a

        pop bc ; pop new TOS
        next

    ; Convenience function to latch noise
    head PSGNOISESET, 8, PSGNOISE, docolon
        dw LIT, 3, PSGLATCHSET, EXIT

    ; Set the full 10-bit tone value for a channel
    head PSGTONESET, 7, PSGTONE, docolon
        ; double up the arguments, into the same order as input
        dw TWODUP
        ; write top 4 bits by mangling bottom 6 bits
        dw SWOP, LIT, 6, RSHIFT, SWOP, PSGLATCHSET
        ; PSGLATCHSET destroyed the previous 2, so write bottom 6 bits
        dw DROP, SWOP, LIT, 63, AND, SWOP, PSGDATASET
        dw EXIT

    ; Set the volume for channel 0
    head VOL0SET, 4, VOL0, docolon
        dw LIT, 0, PSGVOLUMESET, EXIT

    ; Set the volume for channel 1
    head VOL1SET, 4, VOL1, docolon
        dw LIT, 1, PSGVOLUMESET, EXIT

    ; Set the volume for channel 3
    head VOL2SET, 4, VOL2, docolon
        dw LIT, 2, PSGVOLUMESET, EXIT

    ; Set the volume for the noise channel
    head VOL3SET, 4, VOL3, docolon
        dw LIT, 3, PSGVOLUMESET, EXIT

    ; Mute channel 0
    head MUTE0SET, 5, MUTE0, docolon
        dw LIT, 0xF, LIT, 0, PSGVOLUMESET, EXIT

    ; Mute channel 1
    head MUTE1SET, 5, MUTE1, docolon
        dw LIT, 0xF, LIT, 1, PSGVOLUMESET, EXIT

    ; Mute channel 2
    head MUTE2SET, 5, MUTE2, docolon
        dw LIT, 0xF, LIT, 2, PSGVOLUMESET, EXIT

    ; Mute the noise channel
    head MUTE3SET, 5, MUTE3, docolon
        dw LIT, 0xF, LIT, 3, PSGVOLUMESET, EXIT

    head TONE0SET, 5, TONE0, docolon
        dw LIT, 0, PSGTONESET, EXIT
    
    head TONE1SET, 5, TONE1, docolon
        dw LIT, 1, PSGTONESET, EXIT

    head TONE2SET, 5, TONE2, docolon
        dw LIT, 2, PSGTONESET, EXIT

    chead VDPWRITE, 4, VDP!
        ; Set address from BC (TOS)
        ld a, c
        out (VDP_REGISTERS), a
        ld a, b
        or 64 ; set write bit
        out (VDP_REGISTERS), a

        pop bc ; retrieve data
        ld a, c
        out (VDP_DATA), a

        pop bc ; pop new tos
        next

    chead VDPREAD, 4, VDP@
        ; Set address from BC (TOS)
        ld a, c
        out (VDP_REGISTERS), a
        ld a, b
        out (VDP_REGISTERS), a

        in a, (VDP_DATA)

        pop bc ; pop new tos
        next

    chead VDPREGISTERWRITE, 4, VDP#
        di
        ; VDP address (register index) is TOS
        ld a, c
        or $80 ; this bit indicates "write"
        ld l, a

        ; VDP data is right underneath it
        pop bc
        ld a, c

        ; Latch data first, then tell it which register
        out (VDP_REGISTERS), a

        ld a, l
        out (VDP_REGISTERS), a

        pop bc ; pop new tos
        ei
        next

    ; TODO: Convenience word for enabling sprites?

    chead VDPSTATUSREAD, 4, VDP$
        ; no arguments necessary, it's a straight read
        in a, (VDP_REGISTERS)

        push bc
        ld b, 0
        ld c, a
        next

    ; Expose constants for VDP tables
    head VDPTILESBASE, 12, VDPTILESBASE, docolon
        dw LIT, TILES_BASE, EXIT

    head VDPCOLOURSBASE, 14, VDPCOLOURSBASE, docolon
        dw LIT, COLOURS_BASE, EXIT

    head VDPPATTERNSBASE, 15, VDPPATTERNSBASE, docolon
        dw LIT, PATTERNS_BASE, EXIT

    head VDPSPRITEATTRIBS, 16, VDPSPRITEATTRIBS, docolon
        dw LIT, SPRITE_ATTRIBS_BASE, EXIT

    head VDPSPRITEPATTERNS, 17, VDPSPRITEPATTERNS, docolon
        dw LIT, SPRITE_PATTERNS_BASE, EXIT

    ; Sprite attribute words
    head SPRITEATTRIBPTR, 6, SPRPTR, docolon
        ; Calculate offset into VDP memory for a sprite's
        ; attribute data, based on the index
        ; TODO: this might be faster to do with shifts? is there a convenience function?
        dw LIT, 4, STAR, VDPSPRITEATTRIBS, PLUS
        dw EXIT

    ; SPRY! set Y-coordinate of a sprite
    head SPRITEYSET, 5, SPRY!, docolon
        dw SPRITEATTRIBPTR
        ; Y-coordinate is first index, so don't add, just call
        dw VDPWRITE
        dw EXIT

    ; SPRX! set X-coordinate of a sprite
    head SPRITEXSET, 5, SPRX!, docolon
        dw SPRITEATTRIBPTR
        ; X-coordinate is second index
        dw ONEPLUS
        dw VDPWRITE
        dw EXIT

    ; SPRPAT! set pattern index of a sprite
    head SPRITEPATTERNSET, 7, SPRPAT!, docolon
        dw SPRITEATTRIBPTR
        ; pattern index is third index
        dw LIT, 2, PLUS
        dw VDPWRITE
        dw EXIT

    ; SPRCOL! set colour of a sprite
    head SPRITECOLOURSET, 7, SPRCOL!, docolon
        dw SPRITEATTRIBPTR
        ; colour index is fourth index
        dw LIT, 3, PLUS
        dw VDPWRITE
        dw EXIT

    head SPRITEROWLOAD, 7, SPRROW!, docolon
        ; ( data row idx -- )
        ; Don't call this directly...
        dw LIT, 8, STAR, VDPSPRITEPATTERNS, PLUS
        dw PLUS ; Add row
        dw VDPWRITE
        dw EXIT

    chead PSGDATASET, 8, PSGDATA2
        ; load the remaining 6 bits of PSG data
        ; do not use this on its own!

        ; PSG data in BC... truncate to 6 bits
        ld a, c
        and $3f

        ; header doesn't need to be applied, it should be %00 anyway
        ; or something has gone really wrong
        
        out (PSG_REGISTERS), a

        pop bc ; pop new TOS
        next

    ; TODO: convenience word for PSG Tone
    ;   1. capture bottom two bits of data.H
    ;   2. shift data.H left by 2
    ;   3. store data.L somewhere safe
    ;   4. capture top two bits of data.L
    ;   5. shift data.L left by 2, wrapping around
    ;   6. OR data.H and data.L together
    ;   7. feed to PSGNOISE to set first nibble of tone data
    ;   8. retrieve the data.L from "somewhere safe"
    ;   9. capture bottom six bits of data.L
    ;   10. feed to PSGDATA2 to set the second 6 bits of tone data

; As per Enri (http://cmpslv3.stars.ne.jp/Sg1000/EnrSG.htm):
;  Port 0DCH-0DFH: For SK-1100
;　It uses 8255, and uses 0DCH-0DFH.
;　PA is 0DCH, PB is 0DDH, PC is 0DEH, CW is 0DFH
;　The lower 3 bits of 0DEH become the key select.
;　For numbers 0-6, ports 0DDH and 0DCH are used for keyboard data, and the data is read as PB and PA.
;　In case No. 7, ports 0DDH and 0DCH are used to read data as the JOY terminals on the main unit.

SOGGY_KEYMAP:
    ; 1, Q, A, Z, 0, ,, K, I, 8, 0, 0, 0
    .db 0x31, 0x51, 0x41, 0x5a, 0x0, 0x2c, 0x4b, 0x49, 0x38, 0x0, 0x0, 0x0
    ; 2, W, S, X,  , ., L, O, 9, 0, 0, 0
    .db 0x32, 0x57, 0x53, 0x58, 0x20, 0x2e, 0x4c, 0x4f, 0x39, 0x0, 0x0, 0x0
    ; 3, E, D, C, 0, /, ;, P, 0, 0, 0, 0
    .db 0x33, 0x45, 0x44, 0x43, 0x0, 0x2f, 0x3b, 0x50, 0x30, 0x0, 0x0, 0x0
    ; 4, R, F, V, BKSP, 0, :, @, -, 0, 0, 0
    .db 0x34, 0x52, 0x46, 0x56, 0x08, 0x0, 0x3a, 0x40, 0x2d, 0x0, 0x0, 0x0
    ; 5, T, G, B, 0, 0, ], [, ^, 0, 0, 0
    .db 0x35, 0x54, 0x47, 0x42, 0x0, 0x0, 0x5d, 0x5b, 0x5e, 0x0, 0x0, 0x0
    ; 6, Y, H, N, 0, 0, 13, 0, 0, 0, 0, 0
    .db 0x36, 0x59, 0x48, 0x4e, 0x0, 0x0, 0xd, 0x0, 0x0, 0x0, 0x0, 0x0
    ; 7, U, J, M, 0, 0, 0, 0, 0, 0, 0, 0
    .db 0x37, 0x55, 0x4a, 0x4d, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0

SOGGY_KEYMAP_LOWERCASE:
	; !, q, a, z, 0, <, k, i, (, 0, 0, 0
    .db 0x21, 0x71, 0x61, 0x7a, 0x0, 0x3c, 0x6b, 0x69, 0x28, 0x0, 0x0, 0x0
        ; ", w, s, x,  , >, l, o, ), 0, 0, 0
    .db 0x22, 0x77, 0x73, 0x78, 0x20, 0x3e, 0x6c, 0x6f, 0x29, 0x0, 0x0, 0x0
        ; #, e, d, c, 0, ?, +, p, 0, 0, 0, 0
    .db 0x23, 0x65, 0x64, 0x63, 0x0, 0x3f, 0x2b, 0x70, 0x0, 0x0, 0x0, 0x0
        ; $, r, f, v, 8, 0, *, `, =, 0, 0, 0
    .db 0x24, 0x72, 0x66, 0x76, 0x8, 0x0, 0x2a, 0x60, 0x3d, 0x0, 0x0, 0x0
        ; %, t, g, b, 0, 0, }, {, ~, 0, 0, 0
    .db 0x25, 0x74, 0x67, 0x62, 0x0, 0x0, 0x7d, 0x7b, 0x7e, 0x0, 0x0, 0x0
        ; &, y, h, n, 0, 0, 13, 0, 0, 0, 0, 0
    .db 0x26, 0x79, 0x68, 0x6e, 0x0, 0x0, 0xd, 0x0, 0x0, 0x0, 0x0, 0x0
        ; ', u, j, m, 0, 0, 0, 0, 0, 0, 0, 0
    .db 0x27, 0x75, 0x6a, 0x6d, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0