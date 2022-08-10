; "Minimal" example on how to work with sprites
; Sprites require a lot of working parts, so this is one of the larger examples out there.
; OAM is the memory that contains the sprite information.
;   But we do not want to write to this directly, so we setup a OAM buffer in WRAM
;   And then during VBlank we copy from the buffer to the actual OAM memory.
;   We use a special DMA routine for this, which needs to be in HRAM.

INCLUDE "hardware.inc"

SECTION "OAMData", WRAM0, ALIGN[8]
wOAMBuffer: ; OAM Memory is for 40 sprites with 4 bytes per sprite
  ds 40 * 4
.end:

SECTION "vblankInterrupt", ROM0[$040]
  jp vblankHandler

SECTION "entry", ROM0[$100]
  jp start
  ds $150-@, 0 ; Space for the header

SECTION "vblankHandler", ROM0
vblankHandler:
  ; VBlank interrupt. We only call the OAM DMA routine here.
  ; We need to be careful to preserve the registers that we use, see interrupt example.
  push af
  call hOAMCopyRoutine
  pop  af
  reti

SECTION "main", ROM0
start:
  call disableLCD
  call initOAM
  call loadTiles
  call loadPalette
  call enableLCD

  ; Configure 2 sprites in the OAM memory with different positions and palettes.
  ld   a, 20  ; y position
  ld   [wOAMBuffer + 0], a
  ld   a, 20  ; x position
  ld   [wOAMBuffer + 1], a
  ld   a, 0   ; tile number
  ld   [wOAMBuffer + 2], a
  ld   a, 0   ; sprite attributes
  ld   [wOAMBuffer + 3], a

  ld   a, 24  ; y position
  ld   [wOAMBuffer + 4], a
  ld   a, 24  ; x position
  ld   [wOAMBuffer + 5], a
  ld   a, 0   ; tile number
  ld   [wOAMBuffer + 6], a
  ld   a, OAMF_PAL1 | OAMF_YFLIP
  ld   [wOAMBuffer + 7], a

  ; Start the main loop, first enable the VBlank interrupt, and then just loop forever
  ld   a, IEF_VBLANK
  ld   [rIE], a
  ei
haltLoop:
  halt
  ; Enable the next 2 lines to move one of the sprites.
  ;ld   hl, wOAMBuffer + 1
  ;inc  [hl]
  jp   haltLoop
  
initOAM:
  ; Initialize the OAM shadow buffer, and setup the OAM copy routine in HRAM.
  ld   hl, wOAMBuffer
  ld   c, wOAMBuffer.end - wOAMBuffer
  xor  a
.clearOAMLoop:
  ld   [hl+], a
  dec  c
  jr   nz, .clearOAMLoop

  ld   hl, hOAMCopyRoutine
  ld   de, oamCopyRoutine
  ld   c, hOAMCopyRoutine.end - hOAMCopyRoutine
.copyOAMRoutineLoop:
  ld   a, [de]
  inc  de
  ld   [hl+], a
  dec  c
  jr   nz, .copyOAMRoutineLoop
  ; We directly copy to clear the initial OAM memory, which else contains garbage.
  call hOAMCopyRoutine
  ret

oamCopyRoutine:
LOAD "hram", HRAM
hOAMCopyRoutine:
  ld   a, HIGH(wOAMBuffer)
  ldh  [rDMA], a
  ld   a, $28
.wait:
  dec  a
  jr   nz, .wait
  ret
.end:
ENDL

disableLCD:
  ; Disable the LCD, needs to happen during VBlank, or else we damage hardware
.waitForVBlank:
  ld   a, [rLY]
  cp   144
  jr   c, .waitForVBlank

  xor  a
  ld   [rLCDC], a ; disable the LCD by writting zero to LCDC
  ret

loadPalette:
  ld   a, %11100100
  ld   [rBGP], a
  ld   a, %11100100
  ld   [rOBP0], a
  ld   a, %11011000
  ld   [rOBP1], a
  ret

; Load the graphics tiles into VRAM
loadTiles:
  ld   hl, graphicTiles
  ld   de, graphicTiles.end - graphicTiles  ; We set de to the amount of bytes to copy.
  ld   bc, _VRAM

.copyTilesLoop:
  ; Copy a byte from ROM to VRAM, and increase both hl, bc to the next location.
  ld   a, [hl+]
  ld   [bc], a
  inc  bc
  ; Decrease the amount of bytes we still need to copy and check if the amount left is zero.
  dec  de
  ld   a, d
  or   e
  jp   nz, .copyTilesLoop
  ret

enableLCD:
  ld   a, LCDCF_BGON | LCDCF_BG8800 | LCDCF_ON | LCDCF_OBJON
  ldh  [rLCDC], a
  ret



SECTION "graphics", ROM0
graphicTiles:
  ; Graphics data
  ; Prefered way would be to use INCBIN with rgbgfx, which is currently not possible in rgbds-live.
DB $00,$00,$03,$03,$0F,$0F,$1F,$1F
DB $3F,$3D,$7F,$78,$3F,$3A,$3F,$38
DB $3F,$3C,$7F,$7E,$3E,$3F,$3E,$3F
DB $1C,$1F,$3C,$3B,$18,$17,$1C,$13
DB $00,$00,$C0,$C0,$E0,$E0,$E0,$E0
DB $E0,$60,$F0,$70,$F0,$F0,$F0,$70
DB $F0,$70,$78,$F8,$38,$F8,$38,$F8
DB $38,$F8,$38,$D8,$30,$D0,$20,$C0
DB $08,$0F,$00,$07,$07,$01,$00,$07
DB $00,$07,$00,$06,$00,$06,$00,$06
DB $00,$06,$06,$06,$02,$02,$02,$02
DB $06,$06,$00,$00,$00,$00,$00,$00
DB $40,$80,$40,$80,$C0,$00,$00,$C0
DB $00,$C0,$00,$C0,$00,$C0,$00,$E0
DB $40,$70,$30,$30,$18,$18,$08,$08
DB $08,$08,$04,$04,$00,$00,$00,$00
.end:
