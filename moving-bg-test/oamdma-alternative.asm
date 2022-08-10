INCLUDE "hardware.inc"


SECTION "OAMData", WRAM0, ALIGN[8]
ShadowOAM: ; OAM Memory is for 40 sprites with 4 bytes per sprite
  ds 40 * 4


SECTION "OAM", ROM0

OAMDMACode:
LOAD "OAMDMA code", HRAM
DMARoutine:
    ld a, HIGH(ShadowOAM)
    ldh [$FF46], a  ; start DMA transfer (starts right after instruction)
    ld a, 40        ; delay for a total of 4×40 = 160 cycles
.wait
    dec a           ; 1 cycle
    jr nz, .wait    ; 3 cycles
    ret
DMARoutineEnd:
ENDL

CopyDMARoutine:
	ld hl, OAMDMACode
	ld de, DMARoutine
	ld bc, DMARoutineEnd - DMARoutine
.copy:
	ld a, [hl]
	ld [de], a
	inc hl
	inc e
	dec b
	jr nz, .copy
	ret
