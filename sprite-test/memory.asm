INCLUDE "hardware.inc"


SECTION "Header", ROM0[$100]

	jp EntryPoint
	ds $150 - @, 0
	
EntryPoint:
	ld a, 0
	ld [rNR52],a

call WaitVBlank
call TurnOffLCD
call MemSet
call MemCopy
call TurnOnLCD

Loop:
	jp Loop
	

	
	
	
; Routines

WaitVBlank:
	ld a, [rLY]
	cp 144
	jp c, WaitVBlank
	ret
	
TurnOffLCD:
	ld a, 0
	ld [rLCDC], a
	ret
	
TurnOnLCD:
	ld a, %10011001
	ld [rLCDC], a
	
	ld a, %11100100
	ld [rBGP], a
	;ld [rOBP0], a
	;ld [rOBP1], a
	ret
	
MemSet:
	ld hl, _VRAM
	ld bc, $87F0 - $8000
.copy
	ld a, $00
	ld [hl], a
	inc hl
	dec bc
	ld a, b
	or a, c
	jp nz, .copy
	ret

MemCopy:
	ld hl, FaceSprite
	ld bc, FaceSpriteEnd - FaceSprite
	ld de, _VRAM
.copy
	ld a, [hl]
	ld [de], a
	inc hl
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, .copy
	ret


SECTION "Sprite data", ROM0

FaceSprite:
DB $3C,$3C,$42,$42,$81,$81,$A5,$A5
DB $81,$81,$99,$99,$42,$42,$3C,$3C
FaceSpriteEnd:
