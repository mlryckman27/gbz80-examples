INCLUDE "hardware.inc"
	
	
SECTION "Memory routines", ROM0

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
	ld a, %10000111
	ld [rLCDC], a
	
	ld a, %11100100
	ld [rBGP], a
	ld [rOBP0], a
	ld [rOBP1], a
	ret
	
MemSet8000:
	ld hl, _VRAM8000
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
	
MemSet8800:
	ld hl, $8800
	ld bc, $97FF - $8800
.copy
	ld a, $00
	ld [hl], a
	inc hl
	dec bc
	ld a, c
	or a, c
	jp nz, .copy
	ret
	
MemSet9800:
	ld hl, $9800
	ld bc, $9BFF - $9800
.copy
	ld a, $00
	ld [hl], a
	inc hl
	dec bc
	ld a, c
	or a, c
	jp nz, .copy
	ret

MemSet9C00:
	ld hl, $9C00
	ld bc, $9FFF - $9C00
.copy
	ld a, $00
	ld [hl], a
	inc hl
	dec bc
	ld a, c
	or a, c
	jp nz, .copy
	ret	

; hl: tile data location
; bc: number of bytes to copy
; de: destination address
MemCopy:
	; ld hl, tile data address
	; ld bc, number of bytes to copy
	; ld de, destination address
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
