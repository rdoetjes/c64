
// raster interrupt 1 that counts the frames
gameIrq:
  pushall()
  inc frame_counter
  lda frame_counter
  sta $0402
  jsr gameCycle
  popall()
  // bit $dc0d   	          // reading the interrupt control registers 
  // bit $dd0d	              // clears them
  asl $d019               // ack interrupt
  rti

gameLoop:
  // game is driven by IRQ 1 defined in init.
  jmp gameLoop

// draw the new state
gameCycle:
  jsr readInput           // process the input from the user
  jsr gameLogic           // collision detection 
  jsr draw                // draw bg and user and enemy
!:
  rts

gameLogic:
  jsr movePlayerCharacter   //move character based on joystick input
  jsr scrollBgLogic
  rts

draw:
  jsr Background
  jsr dinoAnim            // change the dino sprites depending on the joystick input
  rts

// the game logic goes here
gameInput:
    jsr readInput           // read the joystick input
  rts

// read the joy stick and store it's value in zero page ff (saves 2 cycles for each position evaluation) 
readInput:
  lda $dc00
  sta $ff
  
  lda playerState
  cmp #2
  beq !+  // when the player is jumping, then no input will be registered until the player is back down
  
  lda playerState
  cmp #3
  beq !+  // when the player is jumping (falling down from jump), then no input will be registered until the player is back down

  joystick2State($80, $00) // joystick neutral position go to walk state
  joystick2State($01, $02) // up  go to state jump
  joystick2State($10, $02) // button go to state jump
  joystick2State($02, $01) // down  go to dug
  joystick2State($04, $04) // left go to state left
  joystick2State($08, $05) // right go to state right

  !:
  rts

// initialize the game, entry point from main
game:
  lda #$ff
  jmp *
  rts

  #import "vars.asm"
