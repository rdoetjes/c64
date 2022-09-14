  #import "src/game_states.asm"
  #import "general_game_vars.asm"
  #import "lib/memorymap.asm"

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
  lda playerState
  cmp #STATE.GAMEOVER
  beq !gameOver+
  cmp #STATE.START
  beq !gameStart+

  // game loop
  jsr movePlayerCharacter   //move character based on joystick input
  jsr moveObstacles
  jsr scrollBgLogic
  jsr checkCollision
  rts

  // game start
  !gameStart:
    jsr gameStart
    rts

  !gameOver:
    jsr gameOver
    rts

// draws background and sprite animation of player (dino)
draw:
  jsr scrollBackground
  jsr dinoAnim            // change the dino sprites depending on the joystick input
  rts

// just print game over and press button to start
gameOver:
  ldx #$00
  !:
    lda gameOverString, x
    beq !+
    sta VIC.SCREEN + (12*40) + 13, x
    inx
    jmp !-
  !:
  rts

pressButtonStart:
  ldx #$00
  !:
    lda presStartString, x
    beq !+
    sta VIC.SCREEN + (13*40) + 10, x
    inx
    jmp !-
  !:
  rts

// simple sprite collision, which works since both player and obstacles are sprites
checkCollision:
  lda VIC.SPRITE_COLLISION
  and #$01
  bne !+
  rts
!:
  lda #gameOverCountDown
  sta gameOverFrameCountDown

  lda #STATE.GAMEOVER
  sta playerState
  rts

// read the joy stick and store it's value in zero page ff (saves 2 cycles for each position evaluation) 
readInput:
  lda IO.JOYSTICK2
  sta $ff
  
  //player states are managed and handled in the player.asm code
  lda playerState
  cmp #STATE.START
  beq !+   
  cmp #STATE.JUMP_UP
  beq !+               // when the player is jumping, then no input will be registered until the player is back down
  cmp #STATE.JUMP_DOWN
  beq !+               // when the player is jumping (falling down from jump), then no input will be registered until the player is back down
  cmp #STATE.GAMEOVER
  beq !gameOver+       // when in game over state a button press will bring the game into start state

  //player states are managed and handled in the player.asm code
  joystick2State($80, STATE.WALK) // joystick neutral position go to walk state
  joystick2State($01, STATE.JUMP_UP) // up  go to state jump
  joystick2State($10, STATE.JUMP_UP) // button go to state jump
  joystick2State($02, STATE.DUG) // down  go to dug
  joystick2State($04, STATE.MOVE_LEFT) // left go to state left
  joystick2State($08, STATE.MOVE_RIGHT) // right go to state right
  rts

  !gameRestart:
    lda #gameOverCountDown
    sta gameOverFrameCountDown
    lda #STATE.START
    sta playerState
    rts
  // when in game over block joystick inpit for gameOvrerFraeCountDown frames
  !gameOver:
    lda gameOverFrameCountDown
    bne !gameOverCountDown+
    jsr pressButtonStart
    joystick2State($10, STATE.START) // button go to state jump
    rts
    !gameOverCountDown:
      dec gameOverFrameCountDown
      rts
  !:
  rts

//sets up the whole game, but not the game state! That is done after calling this routine
//that way we can start in game over state, and after a button press we can move to game state
gameSetup:
  jsr cls
  jsr setupSid4Noise
  jsr setupCharset
  jsr dinoSprite
  jsr obstacleSprites
  jsr createLandscape
  rts

gameStart:
  jsr gameSetup
  jsr jumpSound

  lda #STATE.WALK
  sta playerState
  rts

// the game runs from a raster interrupt, hence we just loop here.
//Perhaps we will create an exit state so we can return... NAAH probably not.
game:
  jmp *
  rts
