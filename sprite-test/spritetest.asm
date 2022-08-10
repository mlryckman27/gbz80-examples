INCLUDE "hardware.inc"


SECTION "Header", ROM0[$100]

	jp EntryPoint
	ds $150 - @, 0
	
EntryPoint:
	ld a, 0
	ld [rNR52],a
	
	
call CopyDMARoutine
call WaitVBlank
call TurnOffLCD

MemSet:
	ld hl, $8000
	ld a, $00
	ld bc, 40
.zeroLoop
	ld [hli], a
	dec bc
	jr nz, .zeroLoop

call CopySprite
call hOAMDMA

OAMConfig:
	ld hl, $FE00
	ld [hl], 8
	inc hl
	ld [hl], 8
	inc hl
	ld [hl], $00
	inc hl
	ld a, %00000000
	ld [hl], a

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
	
CopySprite:
	ld a, FaceSprite
	ld [de], a
	ld hl, $8000
	ld bc, FaceSpriteEnd - FaceSprite
.spriteLoop
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, .spriteLoop
	ret
	
TurnOnLCD:
	ld a, %10000011
	ld [rLCDC], a
	
	ld a, %11100100
	ld [rBGP], a
	ld [rOBP0], a
	ld [rOBP1], a
	ret

CopyDMARoutine:
	ld hl, DMARoutine
	ld b, DMARoutineEnd - DMARoutine
	ld c, LOW(hOAMDMA)
.copy
	ld a, [hli]
	ldh [c], a
	inc c
	dec b
	jr nz, .copy
	ret
	
DMARoutine:
	ld a, HIGH($8000)
	ldh [$FF46], a
	ld a, 40
.wait
	dec a
	jr nz, .wait
	ret
DMARoutineEnd:


SECTION "OAM HRAM", HRAM

hOAMDMA:
	ds DMARoutineEnd - DMARoutine
	
	
SECTION "Sprite data", ROM0

FaceSprite:
DB $3C,$3C,$42,$42,$81,$81,$A5,$A5
DB $81,$81,$99,$99,$42,$42,$3C,$3C
FaceSpriteEnd:

