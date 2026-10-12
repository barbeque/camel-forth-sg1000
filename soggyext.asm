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

    chead PSGNOISESET, 8, PSGNOISE
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
        and $7 ; noise is only 3-bits long...
        or c
        
        out (PSG_REGISTERS), a

        pop bc ; pop new TOS
        next

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
    

    ; TODO: word for PSG Volume (4-bit) and word for PSG Tone (10-bit) and word for PSG Noise (3-bit)
    ; offer words for "just data" as well and build it up, but have the PSGTONE word always latch
    ; tempo words and stuff would be neat too

    ; TODO: How does bitmasking work? Let's just do it in assembly?

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