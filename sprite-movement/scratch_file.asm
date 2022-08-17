; File for copying and temporarily storing code that needs to be modified or removed.

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
	
	ld a, $30
	ld [rP1], a
	
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
	ld hl, ShadowOAM + 0
	ld a, [hl]
	ld b, 4
	sub b
	ld [ShadowOAM + 0], a
	ld [ShadowOAM + 8], a

	ld hl, ShadowOAM + 16
	ld a, [hl]
	ld b, 4
	sub b
	ld [ShadowOAM + 16], a
	ld [ShadowOAM + 24], a
	
	ld a, [JumpCounter]
	ld b, a
	dec b
	ld a, b
	ld [JumpCounter], a
	xor a
	cp b
	
	call WaitVBlank
	call OAMDMAStart
	jp nz, .jumpMove
	
	ld a, 100
	ld [ShadowOAM + 0], a
	ld [ShadowOAM + 8], a

	ld a, 116
	ld [ShadowOAM + 16], a
	ld [ShadowOAM + 24], a
	
	call WaitVBlank
	call OAMDMAStart
	
	; Reset JumpCounter variable in HRAM
	ld hl, JumpCounter
	ld a, $FF
	ld [hl], a

	ret
	