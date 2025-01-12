; ANCHOR: dummy      Lines beginning with `ANCHOR` and `ANCHOR_END` are used by mdBook <https://rust-lang.github.io/mdBook/format/mdbook.html#including-portions-of-a-file>
; ANCHOR_END: dummy  Note that lines matching /^; ANCHOR/ are stripped from the online version
; ANCHOR: includes
INCLUDE "../hardware.inc"
; ANCHOR_END: includes

; ANCHOR: header
SECTION "Header", ROM0[$100]

	jp EntryPoint

	ds $150 - @, 0 ; Make room for the header
; ANCHOR_END: header

; ANCHOR: entry
EntryPoint:
	; Do not turn the LCD off outside of VBlank
WaitVBlank:
	ld a, [rLY]
	cp 144
	jp c, WaitVBlank

	; Turn the LCD off
	ld a, 0
	ld [rLCDC], a
; ANCHOR_END: entry

; ANCHOR: title_screen
TitleScreen:
	ld de, Unbricked_Title_Screen_Tileset_Begin
	ld hl, $9000
	ld bc, Unbricked_Title_Screen_Tileset_End - Unbricked_Title_Screen_Tileset_Begin
CopyTitleScreenTiles:
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, CopyTitleScreenTiles

	ld de, Unbricked_Title_Screen_Map_Begin
	ld hl, $9800
	ld bc, Unbricked_Title_Screen_Map_End - Unbricked_Title_Screen_Map_Begin
CopyTitleScreenMap:
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, CopyTitleScreenMap

	; Turn the LCD on
	ld a, LCDCF_ON | LCDCF_BGON
	ld [rLCDC], a

	; During the first (blank) frame, initialize display registers
	ld a, %11100100
	ld [rBGP], a

TitleScreenLoop:
	call UpdateKeys
	ld a, [wCurKeys]
	and PADF_START
	jr z, TitleScreenLoop
; ANCHOR_END: title_screen

WaitVBlank2:
	ld a, [rLY]
	cp 144
	jp c, WaitVBlank2

	; Turn the LCD off
	ld a, 0
	ld [rLCDC], a

ClearVRAM:
	ld bc, $1FFF
	ld hl, $8000
.clearVRAMLoop
	xor a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .clearVRAMLoop

; ANCHOR: copy_tiles
	; Copy the tile data
	ld de, Tiles
	ld hl, $9000
	ld bc, TilesEnd - Tiles
CopyTiles:
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, CopyTiles
; ANCHOR_END: copy_tiles

; ANCHOR: copy_map
	; Copy the tilemap
	ld de, Tilemap
	ld hl, $9800
	ld bc, TilemapEnd - Tilemap
CopyTilemap:
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, CopyTilemap
; ANCHOR_END: copy_map

	; Turn the LCD on
	ld a, LCDCF_ON | LCDCF_BGON
	ld [rLCDC], a

; ANCHOR: end


Done:
	jp Done
; ANCHOR_END: end

Tiles:
	dw `33333333
	dw `33333333
	dw `33333333
	dw `33322222
	dw `33322222
	dw `33322222
	dw `33322211
	dw `33322211
	dw `33333333
	dw `33333333
	dw `33333333
	dw `22222222
	dw `22222222
	dw `22222222
	dw `11111111
	dw `11111111
	dw `33333333
	dw `33333333
	dw `33333333
	dw `22222333
	dw `22222333
	dw `22222333
	dw `11222333
	dw `11222333
	dw `33333333
	dw `33333333
	dw `33333333
	dw `33333333
	dw `33333333
	dw `33333333
	dw `33333333
	dw `33333333
	dw `33322211
	dw `33322211
	dw `33322211
	dw `33322211
	dw `33322211
	dw `33322211
	dw `33322211
	dw `33322211
	dw `22222222
	dw `20000000
	dw `20111111
	dw `20111111
	dw `20111111
	dw `20111111
	dw `22222222
	dw `33333333
	dw `22222223
	dw `00000023
	dw `11111123
	dw `11111123
	dw `11111123
	dw `11111123
	dw `22222223
	dw `33333333
	dw `11222333
	dw `11222333
	dw `11222333
	dw `11222333
	dw `11222333
	dw `11222333
	dw `11222333
	dw `11222333
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
	dw `11001100
	dw `11111111
	dw `11111111
	dw `21212121
	dw `22222222
; ANCHOR: custom_logo
	dw `22322232
	dw `23232323
	dw `33333333
	; Paste your logo here:

TilesEnd:
; ANCHOR_END: custom_logo

Tilemap:
	db $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $02, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $05, $06, $05, $06, $05, $06, $05, $06, $05, $06, $05, $06, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $05, $06, $05, $06, $05, $06, $05, $06, $05, $06, $08, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $05, $06, $05, $06, $05, $06, $05, $06, $05, $06, $05, $06, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $05, $06, $05, $06, $05, $06, $05, $06, $05, $06, $08, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $05, $06, $05, $06, $05, $06, $05, $06, $05, $06, $05, $06, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $05, $06, $05, $06, $05, $06, $05, $06, $05, $06, $08, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $07, $03, $0A, $0B, $0C, $0D, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $07, $03, $0E, $0F, $10, $11, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $07, $03, $12, $13, $14, $15, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $07, $03, $16, $17, $18, $19, $03, 0,0,0,0,0,0,0,0,0,0,0,0
	db $04, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $07, $03, $03, $03, $03, $03, $03, 0,0,0,0,0,0,0,0,0,0,0,0
TilemapEnd:

Unbricked_Title_Screen_Tileset_Begin:
	DB $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
	DB $00,$00, $00,$00, $00,$00, $01,$01, $03,$03, $07,$07, $06,$06, $0C,$0C
	DB $00,$00, $00,$00, $C0,$C0, $C0,$C0, $81,$81, $03,$03, $03,$03, $07,$07
	DB $00,$00, $00,$00, $00,$00, $C0,$C0, $C0,$C0, $81,$81, $01,$01, $03,$03
	DB $00,$00, $00,$00, $00,$00, $60,$60, $E0,$E0, $E0,$E0, $C1,$C1, $C3,$C3
	DB $00,$00, $00,$00, $60,$60, $63,$63, $CF,$CF, $8D,$8D, $81,$81, $03,$03
	DB $00,$00, $00,$00, $7C,$7C, $FE,$FE, $C3,$C3, $C3,$C3, $83,$83, $06,$06
	DB $00,$00, $00,$00, $01,$01, $07,$07, $07,$07, $02,$02, $02,$02, $04,$04
	DB $00,$00, $FC,$FC, $FE,$FE, $87,$87, $03,$03, $03,$03, $03,$03, $06,$06
	DB $00,$00, $00,$00, $00,$00, $01,$01, $01,$01, $03,$03, $06,$06, $06,$06
	DB $00,$00, $00,$00, $00,$00, $81,$81, $83,$83, $06,$06, $0C,$0C, $18,$18
	DB $00,$00, $00,$00, $70,$70, $C8,$C8, $08,$08, $08,$08, $18,$18, $30,$30
	DB $00,$00, $00,$00, $04,$04, $0C,$0C, $0C,$0C, $18,$18, $18,$18, $31,$31
	DB $00,$00, $00,$00, $00,$00, $00,$00, $06,$06, $3E,$3E, $F0,$F0, $C0,$C0
	DB $00,$00, $00,$00, $00,$00, $07,$07, $0E,$0E, $18,$18, $10,$10, $30,$30
	DB $00,$00, $00,$00, $FE,$FE, $FE,$FE, $01,$01, $03,$03, $07,$07, $01,$01
	DB $00,$00, $00,$00, $00,$00, $7C,$7C, $FF,$FF, $C3,$C3, $C1,$C1, $81,$81
	DB $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $80,$80, $80,$80
	DB $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $01,$01
	DB $18,$18, $38,$38, $30,$30, $60,$60, $60,$60, $C0,$C0, $C1,$C1, $81,$81
	DB $0E,$0E, $1E,$1E, $3C,$3C, $3C,$3C, $78,$78, $F0,$F0, $F0,$F0, $70,$70
	DB $07,$07, $0D,$0D, $09,$09, $19,$19, $11,$11, $31,$31, $61,$61, $63,$63
	DB $C2,$C2, $86,$86, $84,$84, $8C,$8C, $88,$88, $98,$98, $10,$10, $30,$30
	DB $07,$07, $06,$06, $0C,$0C, $0F,$0F, $1F,$1F, $10,$10, $20,$20, $60,$60
	DB $0E,$0E, $38,$38, $F0,$F0, $80,$80, $C0,$C0, $60,$60, $30,$30, $30,$30
	DB $04,$04, $08,$08, $08,$08, $30,$30, $3F,$3F, $3F,$3F, $70,$70, $70,$70
	DB $0E,$0E, $1C,$1C, $38,$38, $F0,$F0, $E0,$E0, $00,$00, $00,$00, $00,$00
	DB $0C,$0C, $18,$18, $18,$18, $30,$30, $60,$60, $60,$60, $C1,$C1, $C1,$C1
	DB $18,$18, $30,$30, $61,$61, $61,$61, $C0,$C0, $80,$80, $80,$80, $00,$00
	DB $30,$30, $E0,$E0, $C0,$C0, $80,$80, $01,$01, $01,$01, $03,$03, $06,$06
	DB $37,$37, $7C,$7C, $F8,$F8, $F0,$F0, $B0,$B0, $B0,$B0, $30,$30, $60,$60
	DB $00,$00, $00,$00, $00,$00, $00,$00, $01,$01, $01,$01, $03,$03, $03,$03
	DB $60,$60, $60,$60, $CF,$CF, $FF,$FF, $E0,$E0, $80,$80, $00,$00, $00,$00
	DB $03,$03, $03,$03, $86,$86, $86,$86, $0C,$0C, $0C,$0C, $18,$18, $18,$18
	DB $01,$01, $01,$01, $01,$01, $03,$03, $03,$03, $07,$07, $06,$06, $0E,$0E
	DB $80,$80, $80,$80, $80,$80, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
	DB $01,$01, $03,$03, $03,$03, $07,$07, $06,$06, $06,$06, $06,$06, $07,$07
	DB $82,$82, $06,$06, $0C,$0C, $18,$18, $10,$10, $31,$31, $61,$61, $C1,$C1
	DB $60,$60, $60,$60, $C1,$C1, $C1,$C1, $C3,$C3, $83,$83, $82,$82, $86,$86
	DB $C3,$C3, $83,$83, $83,$83, $83,$83, $03,$03, $03,$03, $03,$03, $03,$03
	DB $20,$20, $60,$60, $40,$40, $40,$40, $C1,$C1, $81,$81, $83,$83, $83,$83
	DB $40,$40, $C0,$C0, $80,$80, $80,$80, $80,$80, $01,$01, $07,$07, $FF,$FF
	DB $30,$30, $30,$30, $71,$71, $61,$61, $E3,$E3, $C2,$C2, $86,$86, $06,$06
	DB $D8,$D8, $98,$98, $8C,$8C, $0C,$0C, $06,$06, $06,$06, $03,$03, $03,$03
	DB $01,$01, $01,$01, $03,$03, $03,$03, $02,$02, $06,$06, $06,$06, $06,$06
	DB $83,$83, $83,$83, $06,$06, $06,$06, $06,$06, $06,$06, $06,$06, $07,$07
	DB $00,$00, $00,$00, $01,$01, $03,$03, $02,$02, $04,$04, $0C,$0C, $18,$18
	DB $86,$86, $8C,$8C, $0C,$0C, $18,$18, $18,$18, $10,$10, $30,$30, $30,$30
	DB $60,$60, $60,$60, $60,$60, $61,$61, $63,$63, $66,$66, $7C,$7C, $38,$38
	DB $06,$06, $06,$06, $8C,$8C, $8C,$8C, $08,$08, $18,$18, $1F,$1F, $1F,$1F
	DB $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $F8,$F8, $F8,$F8, $00,$00
	DB $38,$38, $30,$30, $30,$30, $60,$60, $60,$60, $41,$41, $C3,$C3, $CF,$CF
	DB $0C,$0C, $18,$18, $38,$38, $70,$70, $E0,$E0, $C0,$C0, $80,$80, $00,$00
	DB $03,$03, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
	DB $01,$01, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
	DB $86,$86, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
	DB $7C,$7C, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
	DB $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $FF,$FF, $80,$FF
	DB $03,$03, $01,$01, $00,$00, $00,$00, $00,$00, $00,$00, $FF,$FF, $01,$FF
	DB $F0,$F0, $C0,$C0, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
	DB $30,$30, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
	DB $18,$18, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
	DB $FC,$FC, $70,$70, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
	DB $80,$FF, $80,$FF, $80,$FF, $80,$FF, $80,$FF, $FF,$FF, $FF,$FF, $01,$FF
	DB $01,$FF, $01,$FF, $01,$FF, $01,$FF, $01,$FF, $FF,$FF, $FF,$FF, $80,$FF
	DB $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $FF,$FF, $01,$FF
	DB $80,$FF, $80,$FF, $80,$FF, $80,$FF, $80,$FF, $FF,$FF, $00,$00, $00,$00
	DB $01,$FF, $01,$FF, $01,$FF, $01,$FF, $01,$FF, $FF,$FF, $00,$00, $00,$00
	DB $00,$00, $00,$00, $00,$00, $00,$00, $03,$03, $03,$03, $03,$03, $03,$03
	DB $00,$00, $00,$00, $00,$00, $00,$00, $F0,$F0, $18,$18, $0C,$0C, $0C,$0C
	DB $00,$00, $00,$00, $00,$00, $00,$00, $03,$03, $06,$06, $0C,$0C, $0C,$0C
	DB $00,$00, $00,$00, $00,$00, $00,$00, $C0,$C0, $20,$20, $03,$03, $03,$03
	DB $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $06,$06, $06,$06
	DB $03,$03, $03,$03, $03,$03, $03,$03, $03,$03, $03,$03, $03,$03, $03,$03
	DB $0C,$0C, $0C,$0C, $18,$18, $F0,$F0, $00,$00, $00,$00, $00,$00, $00,$00
	DB $D8,$D8, $E1,$E1, $C3,$C3, $C3,$C3, $C3,$C3, $C3,$C3, $C3,$C3, $C1,$C1
	DB $F0,$F0, $98,$98, $0C,$0C, $0C,$0C, $FC,$FC, $00,$00, $00,$00, $84,$84
	DB $78,$78, $C4,$C4, $C0,$C0, $E0,$E0, $78,$78, $1C,$1C, $0C,$0C, $8C,$8C
	DB $0E,$0E, $07,$07, $03,$03, $00,$00, $00,$00, $00,$00, $00,$00, $08,$08
	DB $0F,$0F, $03,$03, $C3,$C3, $E3,$E3, $33,$33, $33,$33, $33,$33, $63,$63
	DB $C7,$C7, $08,$08, $00,$00, $00,$00, $07,$07, $0C,$0C, $0C,$0C, $0C,$0C
	DB $C3,$C3, $63,$63, $63,$63, $63,$63, $E3,$E3, $63,$63, $63,$63, $E3,$E3
	DB $7F,$7F, $86,$86, $06,$06, $06,$06, $06,$06, $06,$06, $06,$06, $06,$06
	DB $80,$80, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
	DB $C0,$C0, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
	DB $F8,$F8, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
	DB $78,$78, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
	DB $07,$07, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
	DB $C1,$C1, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
	DB $C7,$C7, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
	DB $E3,$E3, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
Unbricked_Title_Screen_Tileset_End:

Unbricked_Title_Screen_Map_Begin:
	DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, 0,0,0,0,0,0,0,0,0,0,0,0
	DB $00, $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F, $10, $11, $00, 0,0,0,0,0,0,0,0,0,0,0,0
	DB $00, $12, $13, $14, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E, $1F, $20, $21, $22, $23, $00, 0,0,0,0,0,0,0,0,0,0,0,0
	DB $00, $24, $25, $26, $27, $28, $29, $2A, $2B, $2C, $2D, $2E, $2F, $30, $31, $32, $33, $34, $00, $00, 0,0,0,0,0,0,0,0,0,0,0,0
	DB $00, $35, $36, $37, $35, $35, $38, $00, $00, $39, $3A, $3B, $3C, $00, $3D, $00, $3E, $00, $00, $00, 0,0,0,0,0,0,0,0,0,0,0,0
	DB $00, $00, $00, $00, $00, $00, $00, $00, $39, $3F, $40, $41, $00, $00, $00, $00, $00, $00, $00, $00, 0,0,0,0,0,0,0,0,0,0,0,0
	DB $00, $00, $00, $00, $00, $00, $00, $39, $3F, $40, $3F, $40, $41, $00, $00, $00, $00, $00, $00, $00, 0,0,0,0,0,0,0,0,0,0,0,0
	DB $00, $00, $00, $00, $00, $00, $39, $3F, $40, $3F, $40, $3F, $40, $41, $00, $00, $00, $00, $00, $00, 0,0,0,0,0,0,0,0,0,0,0,0
	DB $00, $00, $00, $00, $00, $39, $3F, $40, $3F, $40, $3F, $40, $3F, $40, $41, $00, $00, $00, $00, $00, 0,0,0,0,0,0,0,0,0,0,0,0
	DB $00, $00, $00, $00, $39, $3F, $40, $3F, $40, $3F, $40, $3F, $40, $3F, $40, $41, $00, $00, $00, $00, 0,0,0,0,0,0,0,0,0,0,0,0
	DB $00, $00, $00, $39, $3F, $40, $3F, $40, $3F, $40, $3F, $40, $3F, $40, $3F, $40, $41, $00, $00, $00, 0,0,0,0,0,0,0,0,0,0,0,0
	DB $00, $00, $00, $42, $43, $42, $43, $42, $43, $42, $43, $42, $43, $42, $43, $42, $43, $00, $00, $00, 0,0,0,0,0,0,0,0,0,0,0,0
	DB $00, $00, $00, $00, $44, $45, $00, $00, $00, $00, $46, $47, $00, $00, $48, $00, $00, $00, $00, $00, 0,0,0,0,0,0,0,0,0,0,0,0
	DB $00, $00, $00, $00, $49, $4A, $4B, $4C, $4D, $4D, $4E, $4F, $50, $51, $52, $53, $00, $00, $00, $00, 0,0,0,0,0,0,0,0,0,0,0,0
	DB $00, $00, $00, $00, $35, $00, $54, $55, $56, $56, $57, $58, $59, $5A, $35, $53, $00, $00, $00, $00, 0,0,0,0,0,0,0,0,0,0,0,0
	DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, 0,0,0,0,0,0,0,0,0,0,0,0
	DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, 0,0,0,0,0,0,0,0,0,0,0,0
	DB $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, 0,0,0,0,0,0,0,0,0,0,0,0
Unbricked_Title_Screen_Map_End: