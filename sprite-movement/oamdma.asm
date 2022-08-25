INCLUDE "inc/hardware.inc"


SECTION "ShadowOAM Buffer", WRAM0
ShadowOAM::
	DS 4 * 40	; 40 Sprites * 4 bytes each


SECTION "OAM DMA Routine in ROM", ROM0

OAMDMARoutine::
	ld a, HIGH(ShadowOAM)
	ldh [rDMA], a
	ld a, 40
.wait
	dec a
	jr nz, .wait
	ret
.end

CopyOAMDMARoutine::
	ld hl, OAMDMARoutine
	ld de, OAMDMAStart
	ld bc, OAMDMARoutine.end - OAMDMARoutine
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
	
	
SECTION "OAMDMARoutine HRAM space", HRAM

; this is the routine we call to start copying sprites to OAM
; first, OAMDMARoutine must be copied here
OAMDMAStart::
	DS OAMDMARoutine.end - OAMDMARoutine
	
