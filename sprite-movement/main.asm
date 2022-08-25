INCLUDE "inc/hardware.inc"
INCLUDE "img/tiledata.asm"


SECTION "Header", ROM0[$100]
	
	jp EntryPoint
	ds $150 - @, 0
	
EntryPoint:
	ld a, 0		
	ld [rNR52], a

Setup:
	; Wait for VBlank period, then execute all setup routines
	call WaitVBlank
	
	; Turn off LCD, so VRAM can be written to
	call TurnOffLCD
	
	; Clear the VRAM
	call MemSet8000
	call MemSet8800
	call MemSet9800
	call MemSet9C00

	
	; Clear the ShadowOAM to store sprite data before being copied to OAM
	ld de, $C000
	ld bc, $CFFF - $C000
	call MemSet
	
	; Copy the OAM DMA routine to HRAM
	call CopyOAMDMARoutine
	
	; Copy Sprites and tiles to VRAM
	ld hl, ShegoTiles
	ld de, $8000
	ld bc, ShegoTilesEnd - ShegoTiles
	call MemCopy
	
	ld hl, Background0Tiles
	ld bc, Background0TilesEnd - Background0Tiles
	ld de, $9000
	call MemCopy	
	
	ld hl, Background0Map
	ld bc, Background0MapEnd - Background0Map
	ld de, $9800
	call MemCopy
	
	; Reset the LCD scroll registers to position (0, 0)
	xor a
	ld [rSCY], a
	ld [rSCX], a
	
	; Load in the player's sprites and initialize attributes
	call Player.init
	
	; Turn on LCD
	call TurnOnLCD
	
GameLoop:
	call WaitVBlank
	call Player.checkButtons
	
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
	
	jp GameLoop
	