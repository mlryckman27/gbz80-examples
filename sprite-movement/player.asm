INCLUDE "inc/hardware.inc"


SECTION "Player coordinates", WRAM0

PlayerX::
	DS 1

PlayerY::
	DS 1
	
Previous::
	DS 1
	
Current::
	DS 1
	
PlayerXVelocity::
	DS 1

PlayerYVelocity::
	DS 1
	

SECTION "Player data, attributes, and routines", ROM0

; Setup routines

Player::

.init::
	ld a, 100
	ld [PlayerY], a				; Set initial player y-position
	ld a, 8
	ld [PlayerX], a				; Set intial player x- position
	
	ld a, $01
	ld [PlayerYVelocity], a		; Initialize vertical player velocity
	ld a, $01
	ld [PlayerXVelocity], a		; Initialize horizontal player velocity
	
	xor a
	ld [Previous], a
	ld [Current], a

; move Shego sprite tiles into position

	ld a, [PlayerY] ; y position
	ld [ShadowOAM + 0], a
	ld a, [PlayerX]  ; x position
	ld [ShadowOAM + 1], a
	ld a, 0   ; tile number
	ld [ShadowOAM + 2], a
	ld a, 0   ; sprite attributes
	ld [ShadowOAM + 3], a
	
	ld a, [PlayerY]	; y position
	ld [ShadowOAM + 8], a
	ld a, [PlayerX]  ; x position
	add 8
	ld [ShadowOAM + 9], a
	ld a, 2   ; tile number
	ld [ShadowOAM + 10], a
	ld a, 0   ; sprite attributes
	ld [ShadowOAM + 11], a
	
	ld a, [PlayerY]  ; y position
	add 16
	ld [ShadowOAM + 16], a
	ld a, [PlayerX]  ; x position
	ld [ShadowOAM + 17], a
	ld a, 4   ; tile number
	ld [ShadowOAM + 18], a
	ld a, 0   ; sprite attributes
	ld [ShadowOAM + 19], a

	ld a, [PlayerY]  ; y position
	add 16
	ld [ShadowOAM + 24], a
	ld a, [PlayerX]  ; x position
	add 8
	ld [ShadowOAM + 25], a
	ld a, 6   ; tile number
	ld [ShadowOAM + 26], a
	ld a, 0   ; sprite attributes
	ld [ShadowOAM + 27], a
	
.update::
	ld a, [PlayerY] ; y position
	ld [ShadowOAM + 0], a
	ld a, [PlayerX]  ; x position
	ld [ShadowOAM + 1], a
	ld a, 0   ; tile number
	ld [ShadowOAM + 2], a
	ld a, 0   ; sprite attributes
	ld [ShadowOAM + 3], a
	
	ld a, [PlayerY]	; y position
	ld [ShadowOAM + 8], a
	ld a, [PlayerX]  ; x position
	add 8
	ld [ShadowOAM + 9], a
	ld a, 2   ; tile number
	ld [ShadowOAM + 10], a
	ld a, 0   ; sprite attributes
	ld [ShadowOAM + 11], a
	
	ld a, [PlayerY]  ; y position
	add 16
	ld [ShadowOAM + 16], a
	ld a, [PlayerX]  ; x position
	ld [ShadowOAM + 17], a
	ld a, 4   ; tile number
	ld [ShadowOAM + 18], a
	ld a, 0   ; sprite attributes
	ld [ShadowOAM + 19], a

	ld a, [PlayerY]  ; y position
	add 16
	ld [ShadowOAM + 24], a
	ld a, [PlayerX]  ; x position
	add 8
	ld [ShadowOAM + 25], a
	ld a, 6   ; tile number
	ld [ShadowOAM + 26], a
	ld a, 0   ; sprite attributes
	ld [ShadowOAM + 27], a
	ret
	
.moveRight::
	ld a, [Previous]
	ld b, a
	ld a, [Current]
	cp b
	jp z, .incVelocityX
	ld hl, PlayerXVelocity
	ld a, 1
	ld [hl], a
.right
	ld hl, PlayerX
	ld a, [PlayerXVelocity]
	add 1
	add [hl]
	ld [hl], a
	ret
.incVelocityX
	ld a, [PlayerXVelocity]
	ld b, a
	ld a, 4
	cp b
	jp z, .right
	ld hl, PlayerXVelocity
	inc [hl]
	jp .right
	
.moveLeft::
	ld hl, PlayerX
	dec [hl]
	ret

.jump::
	ld hl, PlayerY
	dec [hl]
	ret


.checkButtons::
	ld a, %00100000
	ldh [rP1], a
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	ldh a, [rP1]
	cpl
	and $0F
	swap a
	ld b, a
	
	ld a, %00010000
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
	
	ld a, [Previous]
	xor b
	and b
	ld [Current], a
	ld c, a
	ld a, b
	ld [Previous], a
	
	ld a, $30
	ld [rP1], a
	ret


	