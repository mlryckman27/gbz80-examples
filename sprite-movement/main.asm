INCLUDE "hardware.inc"
;INCLUDE "memory.asm"
INCLUDE "oamdma-alternative.asm"
INCLUDE "tiledata.asm"
;INCLUDE "player.asm"
INCLUDE "screenmovement.asm"


SECTION "Header", ROM0[$100]
	
	jp EntryPoint
	ds $150 - @, 0
	
EntryPoint:
	ld a, 0		
	ld [rNR52],a		; Turn off speaker
	
Setup:	
	ld hl, Globals.frameCount
	xor a
	ld [hl], a
	call WaitVBlank
	call TurnOffLCD
	
	call MemSet8000		; Clear sprite VRAM
	call MemSet8800		; Clear background/window VRAM
	
	ld de, $C000	
	ld bc, $CFFF - $C000
	call MemSet			; Clear memory for ShadowOAM
	
	call CopyOAMDMARoutine	; DMA routine for sprites copied to HRAM
		
	ld hl, ShegoTiles
	ld bc, ShegoTilesEnd - ShegoTiles
	ld de, $8000
	call MemCopy		; Copy sprite tiles to VRAM

	ld hl, Background0Tiles
	ld bc, Background0TilesEnd - Background0Tiles
	ld de, $9000
	call MemCopy			; laod background tiles into VRAM
	
	ld hl, Background0Map
	ld bc, Background0MapEnd - Background0Map
	ld de, $9800
	call MemCopy			; set tilemap for background in VRAM
	
	xor a
	ld [rSCX], a			; set scroll registers
	ld [rSCY], a
	
	call Player.init
	call TurnOnLCD

; game loop
Loop:
	call WaitVBlank
	call CheckButtons

.btn_b::
	bit 1, b
	jr z, .right
	call Player.jump
	
.right::
	bit 4, b
	jr z, .left
	call Player.moveRight
	
.left::
	bit 5, b
	jr z, .continue
	call Player.moveLeft

.continue
	call Player.update
	call OAMDMAStart

	jp Loop

