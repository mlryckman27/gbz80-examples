INCLUDE "hardware.inc"


Section "Screen movement", ROM0

FrameControl:
	ld bc, $8888
.wait
	nop
	dec bc
	ld a, b
	or a, c
	jr nz, .wait
	ret
	
BackgroundScroll:
	ld a, 1
	ld hl, rSCX
	ld b, [hl]
	add a, b
	ld [hl], a
	ret
	