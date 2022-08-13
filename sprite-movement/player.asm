INCLUDE "hardware.inc"


SECTION "Player data, attributes, and routines", ROM0

	
MoveForward:
.getDirection
	ld a, %00100000
	ldh [rP1], a	; tell register we want to read directional input
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	cpl			; flip all the bits, since they are inverted in rP1
	and $0F		; lower nibble of rP1 has directional inputs
	ld b, a
	
.rightButton
	/* check if right directional button has been pressed.
	If yes, then move sprite forward by 8 pizels.
	If no, then end the routine.
	*/
	ld a, %00000001
	cp b
	jp z, .rightMove
	ret

.rightMove
	ld a, 100 ; y position
	ld [ShadowOAM + 0], a
	
	ld hl, ShadowOAM + 1  ; x position
	ld a, [hl]
	ld b, 8
	add b
	ld [ShadowOAM + 1], a
	
	ld a, 0   ; tile number
	ld [ShadowOAM + 2], a
	ld a, 0   ; sprite attributes
	ld [ShadowOAM + 3], a
	
	ld a, 100  ; y position
	ld [ShadowOAM + 8], a
	
	ld hl, ShadowOAM + 9  ; x position
	ld a, [hl]
	ld b, 8
	add b
	ld [ShadowOAM + 9], a
	
	ld a, 2   ; tile number
	ld [ShadowOAM + 10], a
	ld a, 0   ; sprite attributes
	ld [ShadowOAM + 11], a
	
	ld a, 116  ; y position
	ld [ShadowOAM + 16], a
	
	ld hl, ShadowOAM + 17  ; x position
	ld a, [hl]
	ld b, 8
	add b
	ld [ShadowOAM + 17], a
	
	ld a, 4   ; tile number
	ld [ShadowOAM + 18], a
	ld a, 0   ; sprite attributes
	ld [ShadowOAM + 19], a

	ld a, 116  ; y position
	ld [ShadowOAM + 24], a
	
	ld hl, ShadowOAM + 25  ; x position
	ld a, [hl]
	ld b, 8
	add b
	ld [ShadowOAM + 25], a
	
	ld a, 6   ; tile number
	ld [ShadowOAM + 26], a
	ld a, 0   ; sprite attributes
	ld [ShadowOAM + 27], a
	
	ret
	