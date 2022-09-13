  #import "src/game_states.asm"
  #import "general_game_vars.asm"

// raster interrupt 1 that counts the frames
gameIrq:
  pushall()
  inc frame_counter
  lda frame_counter
  sta $0402
  jsr gameCycle
  popall()
  asl $d019               // ack interrupt
  rti

// draw the new state
gameCycle:
  jsr readInput           // process the input from the user
  jsr gameLogic           // collision detection 
  jsr draw                // draw bg and user and enemy
!:
  rts

gameLogic:
  jsr movePlayerCharacter   //move character based on joystick input
  jsr moveObstacle1
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
  
  //player states are managed and handled in the player.asm code
  lda playerState
  cmp #STATE.JUMP_UP
  beq !+  // when the player is jumping, then no input will be registered until the player is back down
  
  lda playerState
  cmp #STATE.JUMP_DOWN
  beq !+  // when the player is jumping (falling down from jump), then no input will be registered until the player is back down

  //player states are managed and handled in the player.asm code
  joystick2State($80, STATE.WALK) // joystick neutral position go to walk state
  joystick2State($01, STATE.JUMP_UP) // up  go to state jump
  joystick2State($10, STATE.JUMP_UP) // button go to state jump
  joystick2State($02, STATE.DUG) // down  go to dug
  joystick2State($04, STATE.MOVE_LEFT) // left go to state left
  joystick2State($08, STATE.MOVE_RIGHT) // right go to state right

  !:
  rts

// the game runs from a raster interrupt, hence we just loop here.
//Perhaps we will create an exit state so we can return... NAAH probably not.
game:
  jmp *
  rts