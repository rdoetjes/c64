  #import "src/game_states.asm"
  #import "general_game_vars.asm"
  #import "lib/memorymap.asm"

// raster interrupt 1 that counts the frames
gameIrq:
  pushall()
  inc frame_counter

  jsr gameCycle
  popall()
  asl $d019               // ack interrupt

  ldx #00
  lda #<noScroll
  sta $fffe
  lda #>noScroll
  sta $ffff
  jsr setupRasterInt
  rti

// draw the new state
gameCycle:
  jsr readInput           // process the input from the user
  jsr gameLogic           // collision detection 
  jsr draw                // draw bg and user and enemy
  !:
  rts

// all the none visible logic of the game goes here
gameLogic:
  lda playerState
  cmp #STATE.GAMEOVER
  beq !gameOver+
  cmp #STATE.START
  beq !gameStart+

  // game loop
  jsr incScore
  jsr increaseSpeed
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
    // we need to show the final score as we don't draw the score each frame
    jsr drawScore
    jsr gameOver
    rts

//Do not scroll the region of the score, this is a ratser interrupt
noScroll:
  pushall()
  lda #$07
  sta VIC.SCREEN_CR_2
  popall()
  asl $d019

  // setup gameIrq which is basically the game loop trigger raster interrupt on line ff
  ldx #130
  lda #<gameIrq
  sta $fffe
  lda #>gameIrq
  sta $ffff
  jsr setupRasterInt
  rti

// increase the speed to 4 pixel scroll on score 2000
increaseSpeed:
  lda scroll_speed_layer
  cmp #$04
  beq !+

  lda score + 1
  cmp #$20
  beq !match+
  rts

  !match:
  lda score + 2
  cmp #$00
  beq !increaseSpeed+
  rts

  !increaseSpeed:
  clc
  lda scroll_speed_layer
  adc #$02
  sta scroll_speed_layer
  lda #$07
  sta scroll_position_layer
  !:
  rts

// draws background and sprite animation of player (dino)
draw:
  jsr scrollBackground
  jsr dinoAnim            // change the dino sprites depending on the joystick input
  lda frame_counter
  and #$07
  beq !drawScore+
  rts
  !drawScore:
  jsr drawScore
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

// print the press the button to start text
pressButtonStart:
  ldx #$00
  !:
    lda presStartString, x
    beq !+
    sta VIC.SCREEN + (14*40) + 10, x
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

// set the score back to 000000
resetScore:
  lda #$00
  ldx #$02
  !:
    sta score, x
    dex
    bpl !-
  rts

// reset the scroll position and the game speed before starting
resetSpeed:
  lda #$02
  sta scroll_speed_layer
  lda #$07
  sta scroll_position_layer
  rts 

//scoring is done 1 point per frame
incScore:
  sed

  clc
  lda score + 2
  adc #$01
  sta score + 2

  lda score + 1
  adc #$00
  sta score + 1

  lda score + 0
  adc #$00
  sta score + 0

  cld
  rts

// translate the score from BCD and write on the screen
drawScore:
  ldx #$00
  ldy #$00
  
  !:
  //top digit bcd
  lda score, x
  and #$f0
  lsr
  lsr
  lsr
  lsr
  ora #$30
  sta VIC.SCREEN + (5 * 40 ) + 15, y

  lda score, x
  and #$0f
  ora #$30
  sta VIC.SCREEN + (5 * 40 ) + 16, y

  // y offset for screen print
  iny
  iny

  // check if we printed all 3 digits
  inx
  cpx #$03
  bne !-
  rts


//sets up the logic for the whole game, but not the game state! That is done after calling this routine
//that way we can start in game over state, and after a button press we can move to game state
gameSetup:
  jsr setupCharset

  lda #$00
  jsr screenColor

  jsr cls

  lda #$07
  jsr fillColor

  jsr setupSid4Noise
  
  jsr dinoSprite
  
  jsr obstacleSprites

  jsr createLandscape
  
  jsr resetScore
  
  jsr resetSpeed

  jsr drawCloud

  rts

// sets up the system for the game
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
