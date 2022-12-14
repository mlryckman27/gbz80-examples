INCLUDE "hardware.inc"
INCLUDE "memory.asm"
INCLUDE "oamdma.asm"


SECTION "Header", ROM0[$100]
	
	jp EntryPoint
	ds $150 - @, 0
	
EntryPoint:
	ld a, 0
	ld [rNR52],a
	
	call WaitVBlank
	call TurnOffLCD
	call MemSet8000
	
	call InitShadowOAM
	
	ld hl, ShegoTiles
	ld bc, ShegoTilesEnd - ShegoTiles
	ld de, $8000
	call MemCopy
	
	call OAMDMA
		
	ld hl, Background0Tiles
	ld bc, Background0TilesEnd - Background0Tiles
	ld de, $9000
	call MemCopy
	
	ld hl, Background0Map
	ld bc, Background0MapEnd - Background0Map
	ld de, $9800
	call MemCopy
	
	xor a
	ld [rSCX], a
	ld [rSCY], a
	
	; move Shgo sprite tiles into position
	ld a, 100 ; y position
	ld [$FE00 + 0], a
	ld a, 8  ; x position
	ld [$FE00 + 1], a
	ld a, 0   ; tile number
	ld [$FE00 + 2], a
	ld a, 0   ; sprite attributes
	ld [$FE00 + 3], a
	
	ld  a, 100  ; y position
	ld [$FE00 + 4], a
	ld a, 16  ; x position
	ld [$FE00 + 5], a
	ld a, 1   ; tile number
	ld [$FE00 + 6], a
	ld a, 0   ; sprite attributes
	ld [$FE00 + 7], a
	
	call TurnOnLCD
	

	

; game loop
Loop:
	xor a
	ld b, 1
	ld a, [rSCX]
	add a, b
	ld [rSCX], a
	
	ld bc, $8888
.frametime
	nop
	dec bc
	ld a, b
	or a, c
	jr nz, .frametime
	
	jp Loop


SECTION "Tiles and sprites", ROM0

Background0Tiles:
DB $00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00
DB $FF,$FF,$00,$FF,$00,$FF,$F0,$0F
DB $FC,$03,$FF,$00,$FF,$00,$FF,$00
DB $FF,$FF,$00,$FF,$00,$FF,$0F,$F0
DB $3F,$C0,$FF,$00,$FF,$00,$FF,$00
DB $FF,$FF,$00,$FF,$00,$FF,$FF,$00
DB $FF,$00,$FF,$00,$FF,$00,$FF,$00
DB $FF,$00,$FF,$00,$FF,$00,$FF,$00
DB $FF,$00,$FF,$00,$FF,$00,$FF,$00
DB $01,$00,$02,$01,$04,$03,$08,$07
DB $10,$0F,$20,$1F,$40,$3F,$80,$7F
DB $80,$00,$40,$80,$20,$C0,$10,$E0
DB $08,$F0,$04,$F8,$02,$FC,$01,$FE
DB $00,$FF,$00,$FF,$00,$FF,$00,$FF
DB $00,$FF,$00,$FF,$00,$FF,$00,$FF
Background0TilesEnd:

Background0Map:
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$05,$06,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$05,$07
DB $07,$06,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$05
DB $07,$07,$07,$07,$06,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $05,$07,$07,$07,$07,$07,$07,$06,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$05,$07,$07,$07,$07,$07,$07,$07,$07
DB $06,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$05,$07,$07,$07,$07,$07,$07,$07
DB $07,$07,$07,$06,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$05,$07,$07,$07,$07,$07,$07
DB $07,$07,$07,$07,$07,$07,$06,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$05,$07,$07,$07,$07,$07
DB $07,$07,$07,$07,$07,$07,$07,$07,$07,$06
DB $02,$03,$03,$03,$03,$03,$03,$03,$03,$03
DB $03,$03,$03,$03,$03,$03,$03,$03,$03,$03
DB $03,$03,$03,$03,$03,$03,$03,$03,$03,$03
DB $03,$01,$04,$04,$04,$04,$04,$04,$04,$04
DB $04,$04,$04,$04,$04,$04,$04,$04,$04,$04
DB $04,$04,$04,$04,$04,$04,$04,$04,$04,$04
DB $04,$04,$04,$04,$04,$04,$04,$04,$04,$04
DB $04,$04,$04,$04,$04,$04,$04,$04,$04,$04
DB $04,$04,$04,$04,$04,$04,$04,$04,$04,$04
DB $04,$04,$04,$04,$04,$04,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DB $00,$00,$00,$00
Background0MapEnd:

ShegoTiles:
DB $00,$00,$03,$03,$0F,$0F,$1F,$1F
DB $3F,$3D,$7F,$78,$3F,$3A,$3F,$38
DB $3F,$3C,$7F,$7E,$3E,$3F,$3E,$3F
DB $1C,$1F,$3C,$3B,$18,$17,$1C,$13
DB $00,$00,$C0,$C0,$E0,$E0,$E0,$E0
DB $E0,$60,$F0,$70,$F0,$F0,$F0,$70
DB $F0,$70,$78,$F8,$38,$F8,$38,$F8
DB $38,$F8,$38,$D8,$30,$D0,$20,$C0
DB $08,$0F,$00,$07,$07,$01,$00,$07
DB $00,$07,$00,$06,$00,$06,$00,$06
DB $00,$06,$06,$06,$02,$02,$02,$02
DB $06,$06,$00,$00,$00,$00,$00,$00
DB $40,$80,$40,$80,$C0,$00,$00,$C0
DB $00,$C0,$00,$C0,$00,$C0,$00,$E0
DB $40,$70,$30,$30,$18,$18,$08,$08
DB $08,$08,$04,$04,$00,$00,$00,$00
ShegoTilesEnd:
