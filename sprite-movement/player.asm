INCLUDE "hardware.inc"
INCLUDE "oamdma-alternative.asm"


SECTION "Player coordinates", HRAM

PlayerX::
	DS 1

PlayerY:
	DS 1
	
JumpCounter::
	DS 1
	

SECTION "Player data, attributes, and routines", ROM0

; Setup routines

InitPlayer:
	ld a, 100
	ld [PlayerY], a
	ld a, 8
	ld [PlayerX], a
	
	ld a, $FF
	ld [JumpCounter], a

; move Shego sprite tiles into position
StartSprite:
	ld a, 100 ; y position
	ld [ShadowOAM + 0], a
	ld a, 8  ; x position
	ld [ShadowOAM + 1], a
	ld a, 0   ; tile number
	ld [ShadowOAM + 2], a
	ld a, 0   ; sprite attributes
	ld [ShadowOAM + 3], a
	
	ld a, 100  ; y position
	ld [ShadowOAM + 8], a
	ld a, 16  ; x position
	ld [ShadowOAM + 9], a
	ld a, 2   ; tile number
	ld [ShadowOAM + 10], a
	ld a, 0   ; sprite attributes
	ld [ShadowOAM + 11], a
	
	ld a, 116  ; y position
	ld [ShadowOAM + 16], a
	ld a, 8  ; x position
	ld [ShadowOAM + 17], a
	ld a, 4   ; tile number
	ld [ShadowOAM + 18], a
	ld a, 0   ; sprite attributes
	ld [ShadowOAM + 19], a

	ld a, 116  ; y position
	ld [ShadowOAM + 24], a
	ld a, 16  ; x position
	ld [ShadowOAM + 25], a
	ld a, 6   ; tile number
	ld [ShadowOAM + 26], a
	ld a, 0   ; sprite attributes
	ld [ShadowOAM + 27], a
	

; Movement routines

MovePlayer:
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

.leftButton
	/* check if right directional button has been pressed.
	If yes, then move sprite forward by 8 pizels.
	If no, then end the routine.
	*/
	ld a, %00000010
	cp b
	jp z, .leftMove

.end
	ret

.rightMove
	ld a, 100 ; y position
	ld [ShadowOAM + 0], a
	
	ld hl, ShadowOAM + 1  ; x position
	ld a, [hl]
	ld b, 1
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
	ld b, 1
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
	ld b, 1
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
	ld b, 1
	add b
	ld [ShadowOAM + 25], a
	
	ld a, 6   ; tile number
	ld [ShadowOAM + 26], a
	ld a, 0   ; sprite attributes
	ld [ShadowOAM + 27], a
	
	ret

.leftMove
	ld a, 100 ; y position
	ld [ShadowOAM + 0], a
	
	ld hl, ShadowOAM + 1  ; x position
	ld a, [hl]
	ld b, 1
	sub b
	ld [ShadowOAM + 1], a
	
	ld a, 0   ; tile number
	ld [ShadowOAM + 2], a
	ld a, 0   ; sprite attributes
	ld [ShadowOAM + 3], a
	
	ld a, 100  ; y position
	ld [ShadowOAM + 8], a
	
	ld hl, ShadowOAM + 9  ; x position
	ld a, [hl]
	ld b, 1
	sub b
	ld [ShadowOAM + 9], a
	
	ld a, 2   ; tile number
	ld [ShadowOAM + 10], a
	ld a, 0   ; sprite attributes
	ld [ShadowOAM + 11], a
	
	ld a, 116  ; y position
	ld [ShadowOAM + 16], a
	
	ld hl, ShadowOAM + 17  ; x position
	ld a, [hl]
	ld b, 1
	sub b
	ld [ShadowOAM + 17], a
	
	ld a, 4   ; tile number
	ld [ShadowOAM + 18], a
	ld a, 0   ; sprite attributes
	ld [ShadowOAM + 19], a

	ld a, 116  ; y position
	ld [ShadowOAM + 24], a
	
	ld hl, ShadowOAM + 25  ; x position
	ld a, [hl]
	ld b, 1
	sub b
	ld [ShadowOAM + 25], a
	
	ld a, 6   ; tile number
	ld [ShadowOAM + 26], a
	ld a, 0   ; sprite attributes
	ld [ShadowOAM + 27], a
	
	ret
	
; Check for directional and jump inputs
MovePlayerTest:
.getButtons
	ld a, %00010000
	ldh [rP1], a
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	cpl
	and $0F
	swap a
	ld b, a
	
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
	or b
	ld b, a
	
.rightButton
	/* check if right directional button has been pressed.
	If yes, then move sprite forward by 8 pizels.
	If no, then end the routine.
	*/
	ld a, %00000001
	cp b
	jp z, .rightMove

.leftButton
	/* check if right directional button has been pressed.
	If yes, then move sprite backward by 8 pizels.
	If no, then end the routine.
	*/
	ld a, %00000010
	cp b
	jp z, .leftMove
	
.bButton
	ld a, %00100000
	cp b
	jp z, .jumpMove

.end
	ret

.rightMove

	ld hl, ShadowOAM + 1  ; x position
	ld a, [hl]
	ld b, 1
	add b
	ld [ShadowOAM + 1], a

	ld hl, ShadowOAM + 9  ; x position
	ld a, [hl]
	ld b, 1
	add b
	ld [ShadowOAM + 9], a
	
	ld hl, ShadowOAM + 17  ; x position
	ld a, [hl]
	ld b, 1
	add b
	ld [ShadowOAM + 17], a

	ld hl, ShadowOAM + 25  ; x position
	ld a, [hl]
	ld b, 1
	add b
	ld [ShadowOAM + 25], a
	
	ret

.leftMove
	ld hl, ShadowOAM + 1  ; x position
	ld a, [hl]
	ld b, 1
	sub b
	ld [ShadowOAM + 1], a

	ld hl, ShadowOAM + 9  ; x position
	ld a, [hl]
	ld b, 1
	sub b
	ld [ShadowOAM + 9], a

	ld hl, ShadowOAM + 17  ; x position
	ld a, [hl]
	ld b, 1
	sub b
	ld [ShadowOAM + 17], a
	
	ld hl, ShadowOAM + 25  ; x position
	ld a, [hl]
	ld b, 1
	sub b
	ld [ShadowOAM + 25], a
	
	ret
	
.jumpMove
	ld a, 4
	ld hl, ShadowOAM + 0
	ld a, [hl]
	ld b, 4
	add b
	
	ld [ShadowOAM + 0], a
	ld [ShadowOAM + 8], a
	ld [ShadowOAM + 16], a
	ld [ShadowOAM + 24], a
	
	ld a, [JumpCounter]
	ld b, a
	dec b
	ld a, b
	ld [JumpCounter], a
	xor a
	cp b
	jp nz, .jumpMove
	
	ld a, 100 ; y position
	ld [ShadowOAM + 0], a
	ld [ShadowOAM + 8], a
	ld a, 116  ; y position
	ld [ShadowOAM + 16], a
	ld [ShadowOAM + 24], a

	ret

;.jumpAndMove
	
	