################# CSC258 Assembly Final Project ###################
# This file contains my implementation of Columns.
#
# Student 1: Victoria Cai
#
# I assert that the code submitted here is entirely my own 
# creation, and will indicate otherwise when it is not.
#
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       8
# - Unit height in pixels:      8
# - Display width in pixels:    256
# - Display height in pixels:   256
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################
    .data
displayAddress: .word   0x10008000
topLeftCorner:  .word   0x10008084
bottomRightCorner:      .word 0x10008818
other_grid:     .space  4096            # copy of grid for dropping pixels
displayNextGemsLocation:    .word   0x100080A4

#COLOURS:

redColour: .word 0xFF0000   # red
blueColour: .word 0x82CAFF   # blue
yellowColour: .word 0xFFFF00   # yellow
purpleColour: .word 0xB5338A   # purple
greenColour: .word 0x74C365   # green
orangeColour: .word 0xFFA500   # orange

blackColour: .word 0x000000 # black
whiteColour: .word 0xFFFFFF # white

##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000
    
# COLUMNS THEME SONG NOTES

# Columns “Clotho” Melody (First 10 seconds Lead Only)
# Format: .word <pitch>, <durationFrames>
# Pitch = MIDI note number (0-127)
# Durations are frames at 60 FPS
# The music track "Clotho" from the video game Columns was composed by Tokuhiko Uwabo. 
# These notes were obtained through reading the musescore sheet music. Credits for this melody belong to the Tokuhiko Uwabo.
# ---------------------------------------------

columns_melody:
    # Sequence from Columns - Clotho theme song:
    #  A4  E4  C5  E4  B4  E4  A4  E4
    .word 69, 7      # A4  (eighth note)
    .word 64, 7      # E4
    .word 72, 7      # C5
    .word 64, 7      # E4
    .word 71, 7      # B4
    .word 64, 7      # E4
    .word 69, 7      # A4
    .word 64, 7      # E4

    #  G#4 E4 B4 E4 A4 E4 G4 E4 G4 D4 B4
    .word 68, 7      # G#4
    .word 64, 7      # E4
    .word 71, 7      # B4
    .word 64, 7      # E4
    .word 69, 7      # A4
    .word 64, 7      # E4
    .word 67, 7      # G4
    .word 64, 7      # E4
    .word 67, 7      # G4
    .word 62, 7      # D4
    .word 71, 7     # B4 

    #  D4 A4 D4 G4 D4 F#4 D4 G4
    .word 62, 7      # D4
    .word 69, 7      # A4
    .word 62, 7      # D4
    .word 67, 7      # G4
    .word 62, 7      # D4
    .word 66, 7      # F#4
    .word 62, 7      # D4
    .word 67, 7     # G4 

    #  D4 A4 D4 G4 D4  
    .word 62, 7
    .word 69, 7
    .word 62, 7
    .word 67, 7
    .word 62, 7 
    
    #  A4  E4  C5  E4  B4  E4  A4  E4
    .word 69, 7      # A4  
    .word 64, 7      # E4
    .word 72, 7      # C5
    .word 64, 7      # E4
    .word 71, 7      # B4
    .word 64, 7      # E4
    .word 69, 7      # A4
    .word 64, 7      # E4
    
    #  D5  E4  B4  E4  G#4  E4  B4 E4
    .word 74, 7      # D4  
    .word 64, 7      # E4
    .word 71, 7      # B4
    .word 64, 7      # E4
    .word 68, 7      # G#4
    .word 64, 7      # E4
    .word 71, 7      # B4
    .word 64, 7      # E4

columns_melody_length:
    .word 48       # number of note entries (each entry = 2 words -> pitch, duration)

# music state:
columns_index: .word 0
columns_timer: .word 0
    
# -------------------------------------------------------
# GAME OVER pixel coordinates (ASCII → 1 pixel)
# -------------------------------------------------------
gameOverPixels:
    # Row 0: " GGG  AAAAA MMMM MMMM EEEEE"
    .word 1,0  2,0  3,0
    .word 6,0  7,0  8,0  9,0  10,0
    .word 12,0 13,0 14,0 15,0
    .word 17,0 18,0 19,0 20,0
    .word 22,0 23,0 24,0 25,0 26,0

    # Row 1: "G     A   A M  M M  M E"
    .word 0,1
    .word 6,1  10,1
    .word 12,1 15,1
    .word 17,1 20,1
    .word 22,1

    # Row 2: "G  GG AAAAA M  M M  M EEEE"
    .word 0,2  3,2  4,2
    .word 6,2  7,2  8,2  9,2  10,2
    .word 12,2 15,2
    .word 17,2 20,2
    .word 22,2 23,2 24,2 25,2

    # Row 3: "G   G A   A M    M    M E"
    .word 0,3  4,3
    .word 6,3  10,3
    .word 12,3 16,3
    .word 20,3
    .word 22,3

    # Row 4: " GGG  A   A M       M EEEEE"
    .word 1,4 2,4 3,4
    .word 6,4 10,4
    .word 12,4 
    .word 20,4
    .word 22,4 23,4 24,4 25,4 26,4

    # Row 5: (blank)

    # Row 6: " OOO  V   V EEEEE RRRR"
    .word 1,6 2,6 3,6
    .word 6,6
    .word 10,6
    .word 12,6 13,6 14,6 15,6 16,6
    .word 18,6 19,6 20,6 21,6

    # Row 7: "O   O V   V E     R   R"
    .word 0,7 4,7
    .word 6,7
    .word 10,7
    .word 12,7
    .word 18,7 22,7

    # Row 8: "O   O V   V EEEE  RRRR"
    .word 0,8 4,8
    .word 6,8
    .word 10,8
    .word 12,8 13,8 14,8 15,8
    .word 18,8 19,8 20,8 21,8

    # Row 9: "O   O  V V  E     R  R"
    .word 0,9 4,9
    .word 7,9 9,9
    .word 12,9
    .word 18,9 21,9

    # Row 10: " OOO    V   EEEEE R   R"
    .word 1,10 2,10 3,10
    .word 8,10
    .word 12,10 13,10 14,10 15,10 16,10
    .word 18,10 22,10

gameOverPixelsEnd:

.data
pausedPixels:
    # Row 0
    .word 0,0 1,0 2,0 3,0         # P
    .word 5,0 6,0 7,0 8,0         # A
    .word 10,0 13,0                # U
    .word 15,0 16,0 17,0 18,0     # S
    .word 20,0 21,0 22,0 23,0     # E
    .word 25,0 26,0 27,0 28,0     # D

    # Row 1
    .word 0,1 3,1                   # P
    .word 5,1 8,1                   # A
    .word 10,1 13,1                 # U
    .word 15,1                       # S
    .word 20,1                       # E
    .word 25,1 28,1                  # D

    # Row 2
    .word 0,2 1,2 2,2 3,2           # P
    .word 5,2 6,2 7,2 8,2           # A
    .word 10,2 13,2                  # U
    .word 15,2 16,2 17,2 18,2       # S
    .word 20,2 21,2 22,2 23,2       # E
    .word 25,2 28,2                  # D

    # Row 3
    .word 0,3                         # P
    .word 5,3 8,3                     # A
    .word 10,3 13,3                   # U
    .word 18,3                         # S
    .word 20,3                         # E
    .word 25,3 28,3                    # D

    # Row 4
    .word 0,4                         # P
    .word 5,4 8,4                     # A
    .word 11,4 12,4               # U
    .word 15,4 16,4 17,4 18,4         # S
    .word 20,4 21,4 22,4 23,4         # E
    .word 25,4 26,4 27,4 28,4         # D
pausedPixelsEnd:

##############################################################################
# Mutable Data
##############################################################################

locationTopGem:     .word 0
topGemColour:   .word 0
middleGemColour:    .word 0
bottomGemColour:    .word 0

# variables for the next column that will be spawned
nextTopGemColour:   .word 0
nextMiddleGemColour:    .word 0
nextBottomGemColour:    .word 0

gravityCounter: .word 0     # counts frames up to gravityCounterThreshold
gravityCounterThreshold:   .word 60         # originally set to 1 pixel down per second

##############################################################################
# Code
##############################################################################

	.text

	.globl main

main:
jal drawBorder
jal drawFirstGemColumn

drawNewColumn:
jal drawGemColumnStart             #testing milestone 1
j gameLoop

gameLoop:
    
# 1a. Check if key has been pressed
    # 1b. Check which key has been pressed 
# 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep

    # 5. Go back to Step 1    
jal drawBackground
jal drawGemColumn
jal playColumnsMelody       # plays the next note or current note in the melody (depends on timer)

Sleep:
li $v0, 32 			                        # Sleep
li $a0, 16                                  # Sleep for 16 ms = 1/60 s
syscall    

# --------------------------------
# GRAVITY SYSTEM
# --------------------------------
# increment gravity counter by 1
lw $t0, gravityCounter
addi $t0, $t0, 1
sw $t0, gravityCounter

lw $t1, gravityCounterThreshold              
bne $t0, $t1, skipGravity

# If counter reached 60 → apply gravity
li $t0, 0
sw $t0, gravityCounter   # reset counter

jal applyGravity
# applyGravity moves column down 1 pixel if possible

skipGravity:

CheckKeyboardInput:
    lw $t3, ADDR_KBRD        # keyboard base
    lw $t1, 0($t3)           # $t1 = 1 if key pressed
    beq $t1, $zero, gameLoop # no key pressed

    lw $t2, 4($t3)           # $t2 = ASCII of key pressed

    beq $t2, 0x77, RespondToW   # 'w'
    beq $t2, 0x61, RespondToA   # 'a'
    beq $t2, 0x73, RespondToS   # 's'
    beq $t2, 0x64, RespondToD   # 'd'
    beq $t2, 0x71, gameOver     # 'q'
    beq $t2, 0x70, pauseGame    # 'p'

    j gameLoop                   # not a recognized key

RespondToW:                                 # swap order of gems
jal makeSoundShuffle
jal shuffleColumn                           # shuffle the column
j gameLoop

RespondToA:                                 # move column left
jal makeSoundLeftRightDown
jal checkLeftCollision
#lw $t0, x                                   # load x value into $t0
lw $t0, locationTopGem
addi $t0, $t0, -4                           # change position of top gem to 1 pixel left (4 bytes)
sw $t0, locationTopGem
# sw $t0, x                                   # store new x ($t0) value in x variable 
j gameLoop

RespondToS:
jal makeSoundLeftRightDown
jal checkBotAndTopCollision
lw $t0, locationTopGem
addi $t0, $t0, 0x80                           # change position of top gem to 1 pixel down (0x80 bytes)
sw $t0, locationTopGem
j gameLoop

RespondToD:
jal makeSoundLeftRightDown
jal checkRightCollision
sw $t0, locationTopGem
addi $t0, $t0, 4                           # change position of top gem to 1 pixel right (4 bytes)
sw $t0, locationTopGem
j gameLoop

j gameLoop 					            # not one of wasd, go back

    
loopEnd:
    
##############################################################################
# Functions
##############################################################################

# |-----------------------------------------------------------------------------------------------|

# |-----------------------------| Function: drawBackground |--------------------------------------|

# Arguments: 		none
# Return values: 	none

drawBackground:
li $t1, 0x80
li $t9, 32
mult $t9, $t1
mflo $t2
# draw the saved grid of previous screen gems
drawSavedGrid:
    la $t8, other_grid
    lw $t9, displayAddress

    li $t0, 0               # index = 0
    li $t1, 4096            # bottom right corner of display (32×32×4)

copyLoop:
    beq $t0, $t1, endCopy

    # load pixel from other_grid
    addu $t3, $t8, $t0
    lw $t4, 0($t3)              # loads the colour at pixel in other grid into t4

    # # only draw NON-BLACK pixels
    # lw $t5, blackColour
    # beq $t4, $t5, skipPixel         # if pixel is black skip

    # store to screen
    addu $t6, $t9, $t0              # 
    sw $t4, 0($t6)                  # at pixel in our grid, draw colour of other grid pixel

skipPixel:
    addi $t0, $t0, 4
    j copyLoop

endCopy:

drawBorder:
li $t1, 0x00808080  # grey 
lw $t9, displayAddress                      # $t9 = base address for display
addi $t2, $t9, 32                           # $t2 = end address = $t0 + 32 (8 pixels × 4 bytes)
drawTopBorder:
    beq $t9, $t2, drawTopBorderEnd       #stop when reach end
    sw $t1, 0($t9)                          #draw grey pixel
    addi $t9, $t9, 4                        # move $t0 to the next pixel in the row.
    
    j drawTopBorder                       #repeat
drawTopBorderEnd:

lw $t9, displayAddress                      # top-left unit
li $t3, 17                                  # number of rows to draw
li $t4, 0x80                                # bytes per row = 32 units * 4 bytes

drawLeftBorder:
    beq $t3, $zero, drawLeftBorderEnd   # stop after 17 rows
    sw $t1, 0($t9)                         # draw pixel
    add $t9, $t9, $t4                      # move down one row
    addi $t3, $t3, -1                      # decrement row counter
    j drawLeftBorder

drawLeftBorderEnd:

lw $t9, displayAddress
addi $t9, $t9, 28                           # right end of top border unit
li $t3, 17                                  # number of rows to draw
li $t4, 0x80                                # bytes per row = 32 units * 4 bytes

drawRightBorder:
    beq $t3, $zero, drawRightBorderEnd   # stop after 17 rows
    sw $t1, 0($t9)                          # draw pixel
    add $t9, $t9, $t4                       # move down one row
    addi $t3, $t3, -1                       # decrement row counter
    j drawRightBorder

drawRightBorderEnd:


lw $t9, displayAddress
addi $t9, $t9, 0x880                        # $t0 = base address for bottom border (17th row down x 32 pixels per row x 4 bytes per pixel)
addi $t2, $t9, 32                           # $t2 = end address = $t0 + 32 (8 pixels × 4 bytes)
drawBottomBorder:
    beq $t9, $t2, drawBottomBorderEnd    #stop when reach end
    sw $t1, 0($t9)                          #draw grey pixel
    addi $t9, $t9, 4                        # move $t0 to the next pixel in the row.
    
    j drawBottomBorder   #repeat
drawBottomBorderEnd:

jr $ra

# |-----------------------------------------------------------------------------------------------|

# |-----------------------------| Function: storeOldColumn |--------------------------------------|

# Arguments: 	 topGemLocation as location of top gem
# Return values: 	other_grid updated with old gem column

storeOldColumn:
    jal makeSoundStoreColumn
    la $t8, other_grid          # base of saved grid

    # Compute offset = (t0 - displayAddress)
    lw $t9, displayAddress
    subu $t3, $t0, $t9          # t3 = byte offset from top-left

    # store top gem
    addu $t4, $t8, $t3
    lw $t5, topGemColour
    sw $t5, 0($t4)

    # middle gem
    addi $t3, $t3, 0x80         # one row down
    addu $t4, $t8, $t3
    lw $t6, middleGemColour
    sw $t6, 0($t4)

    # bottom gem
    addi $t3, $t3, 0x80
    addu $t4, $t8, $t3
    lw $t7, bottomGemColour
    sw $t7, 0($t4)

    # check colour matches for rows, cols, and diagonals, by marking pixels in other_grid white based on display address display

checkMatches:
    lw $t9, blueColour
    jal checkMatchingGems
    lw $t9, redColour
    jal checkMatchingGems
    lw $t9, orangeColour
    jal checkMatchingGems
    lw $t9, yellowColour
    jal checkMatchingGems
    lw $t9, greenColour
    jal checkMatchingGems
    lw $t9, purpleColour
    jal checkMatchingGems
    
    # call removeMatchingPixels function, will remove white pixels and drop the pixels on top. 

jal removeMatchingGems
    # check if $t6 is 1. if its 1, jump back to checkMatches. if not, will continue to draw new column
    li $t7, 1
    beq $t6, $t7, updateGrid
    j drawNewColumn     # otherwise j drawNewColumn
    
    # this branch is reached when a match is made
    updateGrid:
        jal makeSoundMatch
        jal drawBackground      # updates the display grid
        j checkMatches          # check matches again 
    
# |-----------------------------------------------------------------------------------------------|

# |-----------------------------| Function: drawFirstGemColumn |--------------------------------------|

# Arguments: 		none
# Return values: 	$t0 as location of top gem

drawFirstGemColumn:
jal increaseGravity
lw $t0, topLeftCorner

# draw top gem
addi $t0, $t0, 12
sw $t0, locationTopGem
jal randomColour
sw $t1, 0($t0)                                  # draw random coloured pixel
sw $t1, topGemColour                            # copy colour to topGemColour

# draw middle gem
addi $t2, $t0, 0x80
jal randomColour
sw $t1, 0($t2)                          # draw random coloured pixel
sw $t1, middleGemColour                           # copy colour to topGemColour

# draw bottom gem
addi $t2, $t2, 0x80
jal randomColour
sw $t1, 0($t2)                          # draw random coloured pixel
sw $t1, bottomGemColour                           # copy colour to topGemColour

# draw NEXT top gem
lw $t0, displayNextGemsLocation
lw $t5, displayAddress
subu $t0, $t0, $t5                          # offset from displayaddress
la $t5, other_grid
addu $t0, $t5, $t0                          # get address in othergrid
jal randomColour
sw $t1, 0($t0)                                  # draw random coloured pixel
sw $t1, nextTopGemColour                            # copy colour to topGemColour

# draw NEXT middle gem
addi $t2, $t0, 0x80
jal randomColour
sw $t1, 0($t2)                          # draw random coloured pixel
sw $t1, nextMiddleGemColour                           # copy colour to topGemColour

# draw NEXT bottom gem
addi $t2, $t2, 0x80
jal randomColour
sw $t1, 0($t2)                          # draw random coloured pixel
sw $t1, nextBottomGemColour                           # copy colour to topGemColour

j gameLoop


# |-----------------------------------------------------------------------------------------------|

# |-----------------------------| Function: drawGemColumnStart |--------------------------------------|

# Arguments: 		none
# Return values: 	$t0 as location of top gem

drawGemColumnStart:
jal increaseGravity
lw $t0, topLeftCorner

# draw top gem
addi $t0, $t0, 12
sw $t0, locationTopGem
lw $t1, nextTopGemColour                # load in the previously decided NEXT gem colour
sw $t1, 0($t0)                                  # draw random coloured pixel
sw $t1, topGemColour                            # update colour to topGemColour

# draw middle gem
addi $t2, $t0, 0x80
lw $t1, nextMiddleGemColour                     # load in the previously decided NEXT gem colour
sw $t1, 0($t2)                          # draw random coloured pixel
sw $t1, middleGemColour                           # update colour to topGemColour

# draw bottom gem
addi $t2, $t2, 0x80
lw $t1, nextBottomGemColour                 # load in the previously decided NEXT gem colour
sw $t1, 0($t2)                          # draw random coloured pixel
sw $t1, bottomGemColour                           # update colour to topGemColour

# draw NEXT top gem
lw $t0, displayNextGemsLocation
lw $t5, displayAddress
subu $t0, $t0, $t5                          # offset from displayaddress
la $t5, other_grid
addu $t0, $t5, $t0                          # get address in othergrid
jal randomColour
sw $t1, 0($t0)                                  # draw random coloured pixel
sw $t1, nextTopGemColour                            # copy colour to topGemColour

# draw NEXT middle gem
addi $t2, $t0, 0x80
jal randomColour
sw $t1, 0($t2)                          # draw random coloured pixel
sw $t1, nextMiddleGemColour                           # copy colour to topGemColour

# draw NEXT bottom gem
addi $t2, $t2, 0x80
jal randomColour
sw $t1, 0($t2)                          # draw random coloured pixel
sw $t1, nextBottomGemColour                           # copy colour to topGemColour

j gameLoop



# |-----------------------------------------------------------------------------------------------|

# |-----------------------------| Function: randomColour |--------------------------------------|

# Arguments: 		none
# Return values: 	$t1 as the random colour

randomColour:
li $v0, 42                              # generates the random number from 0,1,2,3,4,5
li $a0, 0                               # generator ID = 0
li $a1, 6                               # upper bounnd 6
syscall                                 # store random number in a0
move $t1, $a0                           # store random number in t1

# use random number to pick color
li $t3, 0
beq $t1, $t3, useRed

li $t3, 1
beq $t1, $t3, useBlue

li $t3, 2
beq $t1, $t3, useYellow

li $t3, 3
beq $t1, $t3, usePurple

li $t3, 4
beq $t1, $t3, useGreen

li $t3, 5
beq $t1, $t3, useOrange

jr $ra                              # shouldn't be reached

useRed:
lw $t1, redColour  
jr $ra

useBlue:
lw $t1, blueColour
jr $ra

useYellow:
lw $t1, yellowColour
jr $ra

usePurple:
lw $t1, purpleColour
jr $ra

useGreen:
lw $t1, greenColour
jr $ra

useOrange:
lw $t1, orangeColour
jr $ra

# |-----------------------------------------------------------------------------------------------|

# |-----------------------------| Function: drawGemColumn |--------------------------------------|

# Arguments: 		$t0 as location of top gem
# Return values: 	none

drawGemColumn:
lw $t2, locationTopGem

# draw top gem
lw $t5, topGemColour
sw $t5, 0($t2)                          #draw top coloured pixel

# draw middle gem
lw $t6, middleGemColour
addi $t2, $t2, 0x80
sw $t6, 0($t2)                          #draw middle coloured pixel

# draw bottom gem
lw $t7, bottomGemColour
addi $t2, $t2, 0x80
sw $t7, 0($t2)                          #draw bottom coloured pixel
jr $ra

# |-----------------------------------------------------------------------------------------------|

# |-----------------------------| Function: shuffleColumn |--------------------------------------|

# Arguments: 		locationTopGem as location of top gem, topGemColour as top colour, middleGemColour as middle colour, bottomGemColour as bottom colour
# Return values: 	topGemColour as new top colour, middleGemColour as new middle colour, bottomGemColour as new bottom colour

shuffleColumn:
lw $t2, locationTopGem

# draw top gem
lw $t7, bottomGemColour
sw $t7, 0($t2)                          # draw old bottom coloured pixel at top

# draw middle gem
lw $t8, topGemColour                           # load old top colour
addi $t2, $t2, 0x80
sw $t8, 0($t2)                          # draw old top coloured pixel at middle

# draw bottom gem
addi $t2, $t2, 0x80
lw $t6, middleGemColour
sw $t6, 0($t2)                          # draw old middle coloured pixel at bottom

# update colours
sw $t7, topGemColour                           # new top colour
sw $t6, bottomGemColour                           # new bottom colour
sw $t8, middleGemColour                           # new middle colour

jr $ra

# |-----------------------------------------------------------------------------------------------|

# |-------------------------------| Function: checkCollisions |------------------------------------|
 
# Arguments: locationTopGem 
# Return value:  None

checkCollisions:

checkRightCollision:
lw $t4, blackColour
lw $t0, locationTopGem      # load location of top gem into t0
addi $t3, $t0, 4        # get pixel on right of gem column
lw $t1, 0($t3)          # check colour of pixel, load into $t1
bne $t1, $t4, gameLoop    # there is collision, so just go back to game loop 
jr $ra              # no collision, return 

checkLeftCollision:
lw $t4, blackColour
lw $t0, locationTopGem      # load location of top gem into t0
addi $t3, $t0, -4        # get pixel on left of gem column
lw $t1, 0($t3)          # check colour of pixel, load into $t1
bne $t1, $t4, gameLoop    # there is collision, so just go back to game loop 
jr $ra              # no collision, return  

checkBotAndTopCollision:
lw $t4, blackColour
lw $t0, locationTopGem      # load location of top gem into t0
addi $t3, $t0, 0x180        # get pixel below gem column
lw $t1, 0($t3)          # check colour of pixel, load into $t1
bne $t1, $t4, checkTopCollision    # check if pixel is NOT black: there is bottom collision, so check top collision!
jr $ra        # otherwise, no collision, return

checkTopCollision:
lw $t0, locationTopGem      # load location of top gem into t0
subu $t3, $t0, 0x80     # get pixel above gem column

lw $t1, displayAddress          
addi $t1, $t1, 16           # get location of block above starting top location, load into t1
beq $t1, $t3, gameOver      # if above is the block above starting posiition, means no more blocks should be spawned. game over.
j storeOldColumn        #otherwise, there is just a bottom collision, so new column!


# |-----------------------------------------------------------------------------------------------|

# |-------------------------------| Function: checkMatchingGems |------------------------------------|

# Arguments: 		$t9 with colour to check
# Return value: 	white squares in other grid where there is matches
# while loop with inner loop
# call a row to see the start and end of longest consecutive pixels
# do same for columns and diagonals
# for gem mathcing, pull out pixel colour value

checkMatchingGems:
    lw $t2, displayAddress       # $t2 = base of display (main grid)
    la $t6, other_grid           # $t6 = base of other grid
    lw $t7, whiteColour          # t7 = whiteColour

    move $s0, $zero              # startRun = 0
    move $s1, $zero              # endRun = 0

    li $t8, 0                   # counter for rows
    lw $t0, topLeftCorner                # start of row

rowLoop:
    beq $t8, 16, colMatching            # done all rows
    addi $t1, $t0, 28                     # border at right end of row

    startRowLoop:
        beq $t1, $t0, nextRow     # end of row

        lw $a0, 0($t0)           # read pixel colour from displayAddress

        beq $a0, $t9, extendRun  # if colour matches target ($t9)

        j finishRun               # otherwise finish run if there was one

    extendRun:
        beq $s0, $zero, startNewRun
        move $s1, $t0            # extend endRun
        j nextPixel

    startNewRun:
        move $s0, $t0
        move $s1, $t0
        j nextPixel

    finishRun:
        beq $s0, $zero, resetRun      # run wasn't even 2 pixels
        subu $t4, $s1, $s0       # length of run in bytes
        addi $t4, $t4, 4         # because subtraction excludes one pixel
        blt $t4, 12, resetRun    # run < 3 -> skip
        
        # mark run in other_grid
        subu $t5, $s0, $t2   # offset from display
        addu $t5, $t5, $t6               # corresponding address in other_grid
        
        subu $t4, $s1, $t2   # end offset from display
        addu $t4, $t4, $t6               # corresponding address in other_grid

    markWhiteLoop:          # marks the matches white in other_grid
        sw $t7, 0($t5)
        beq $t5, $t4, resetRun
        addi $t5, $t5, 4
        j markWhiteLoop

    resetRun:
        move $s0, $zero
        move $s1, $zero

    nextPixel:
        addi $t0, $t0, 4
        j startRowLoop

nextRow:
    move $s0, $zero
    move $s1, $zero
    subu $t0, $t0, 28           # move back to left side
    addi $t0, $t0, 0x80           # move to next row 128 bytes (32 pixels × 4 bytes)
    addi $t8, $t8, 1
    j rowLoop
    
# Column matching!
colMatching:
    move $s0, $zero              # startRun = 0
    move $s1, $zero              # endRun = 0

    li $t8, 0                   # counter for cols
    lw $t0, topLeftCorner                # start of col
colLoop:
    beq $t8, 7, rightDiagMatching            # done all cols
    addi $t1, $t0, 2176                     # border at bottom (17 pixels down x 32 pixels per row x 4 bytes)

    startColLoop:
        beq $t1, $t0, nextCol     # end of col

        lw $a0, 0($t0)           # read pixel colour from displayAddress

        beq $a0, $t9, extendColRun  # if colour matches target ($t9)

        j finishColRun               # otherwise finish run if there was one

    extendColRun:
        beq $s0, $zero, startNewColRun
        move $s1, $t0            # extend endRun
        j nextColPixel

    startNewColRun:
        move $s0, $t0
        move $s1, $t0
        j nextColPixel

    finishColRun:
        beq $s0, $zero, resetColRun      # run wasn't even 2 pixels
        subu $t4, $s1, $s0       # length of run in bytes
        blt $t4, 256, resetColRun    # run < 3 height (2 row difference between start and end x 32 pixels per row x 4 bytes) -> skip
        
        # mark run in other_grid
        subu $t5, $s0, $t2   # offset from display
        addu $t5, $t5, $t6               # corresponding s0 address in other_grid
        
        subu $t4, $s1, $t2   # end offset from display
        addu $t4, $t4, $t6               # corresponding s1 address in other_grid

    markWhiteColLoop:          # marks the matches white in other_grid
        sw $t7, 0($t5)              # draw white
        beq $t5, $t4, resetColRun       
        addi $t5, $t5, 0x80     # move to next pixel down
        j markWhiteColLoop

    resetColRun:
        move $s0, $zero
        move $s1, $zero

    nextColPixel:
        addi $t0, $t0, 0x80     # one pixel DOWN
        j startColLoop

nextCol:
    move $s0, $zero
    move $s1, $zero
    subu $t0, $t0, 2176           # move back to top side (32 pixels per row x 17 rows (16 in game + border) x 4 bytes)
    addi $t0, $t0, 4           # move to next col 
    addi $t8, $t8, 1
    j colLoop
    
# Diagonal matching!

rightDiagMatching:
    move $s0, $zero              # startRun = 0
    move $s1, $zero              # endRun = 0

    li $t8, 0                   # counter for rows
    lw $t3, topLeftCorner                # start of row
    move $t0, $t3                       # t3 has top left corner too now

# Outerloop, goes through rows of game grid.
rightDiagLoop:
    beq $t8, 15, leftDiagMatching            # done all rows (impossible to have diagonals at least length 3 past row 14)
    addi $t1, $t3, 24                     # border at right end of row

    # loop through the pixels in the current row
    startRightDiagLoop:
        beq $t1, $t3, nextRightDiagRow     # end of row

        lw $a0, 0($t0)           # read pixel colour from displayAddress
        beq $a0, $t9, extendRightDiagRun  # if colour matches target ($t9)
        # beq $a0, 0x00808080, checkWhichBorderHit    # reached right or bottom border (grey), check which border hit

        j finishRightDiagRun               # otherwise finish run if there was one

    extendRightDiagRun:
        beq $s0, $zero, startNewRightDiagRun
        move $s1, $t0            # extend endRun
        j nextRightDiagPixel

    startNewRightDiagRun:
        move $s0, $t0
        move $s1, $t0
        j nextRightDiagPixel

    finishRightDiagRun:     # finishes at the pixel after the run
        subu $t4, $s1, $s0       # length of run in bytes
        blt $t4, 264, resetRightDiagRun    # run < 3 -> skip (distance between end to start is 2 x 33 pixels x 4 bytes)
        
    # mark run in other_grid
        subu $t5, $s0, $t2   # offset from display
        addu $t5, $t5, $t6               # corresponding address in other_grid
        
        subu $t4, $s1, $t2   # end offset from display
        addu $t4, $t4, $t6               # corresponding address in other_grid

    markWhiteRightDiagLoop:          # marks the matches white in other_grid
        sw $t7, 0($t5)
        beq $t5, $t4, resetRightDiagRun
        addi $t5, $t5, 132      # 33 pixels (one row is 32) x 4 bytes goes to the next diagonal pixel
        j markWhiteRightDiagLoop

    resetRightDiagRun:
        move $s0, $zero
        move $s1, $zero

    nextRightDiagPixel:
        addi $t0, $t0, 0x84          # go to the next pixel diagonal down right
        beq $a0, 0x00808080, nextRightDiagColumn    # reached right or bottom border (grey), move on to next column
        j startRightDiagLoop
        
    nextRightDiagColumn:
        addi $t3, $t3, 4            # go to next pixel in the current row
        move $t0, $t3               # reset pointer to this pixel
        move $s0, $zero             # reset run
        move $s1, $zero
        j startRightDiagLoop

nextRightDiagRow:
    move $s0, $zero
    move $s1, $zero
    subu $t3, $t3, 24           # move back to left side
    addi $t3, $t3, 0x80           # move to next row 128 bytes (32 pixels × 4 bytes)
    move $t0, $t3                   # new starting position for $t0
    addi $t8, $t8, 1
    j rightDiagLoop
    
    
# left diagonal matching!    
leftDiagMatching:
    move $s0, $zero              # startRun = 0
    move $s1, $zero              # endRun = 0

    li $t8, 0                   # counter for rows
    lw $t3, topLeftCorner                # start of row
    move $t0, $t3                       # t3 has top left corner too now

# Outerloop, goes through rows of game grid.
leftDiagLoop:
    beq $t8, 15, done            # done all rows (impossible to have diagonals at least length 3 past row 14)
    addi $t1, $t3, 24                     # border at right end of row

    # loop through the pixels in the current row
    startLeftDiagLoop:
        beq $t1, $t3, nextLeftDiagRow     # end of row
        lw $a0, 0($t0)           # read pixel colour from displayAddress
        beq $a0, $t9, extendLeftDiagRun  # if colour matches target ($t9)
        # beq $a0, 0x00808080, checkWhichBorderHit    # reached right or bottom border (grey), check which border hit

        j finishLeftDiagRun               # otherwise finish run if there was one

    extendLeftDiagRun:
        beq $s0, $zero, startNewLeftDiagRun
        move $s1, $t0            # extend endRun
        j nextLeftDiagPixel

    startNewLeftDiagRun:
        move $s0, $t0
        move $s1, $t0
        j nextLeftDiagPixel

    finishLeftDiagRun:     # finishes at the pixel after the run
        subu $t4, $s1, $s0       # length of run in bytes
        blt $t4, 248, resetLeftDiagRun    # run < 3 -> skip (distance between end to start is 2 x 31 pixels x 4 bytes)
        
    # mark run in other_grid
        subu $t5, $s0, $t2   # offset from display
        addu $t5, $t5, $t6               # corresponding address in other_grid
        
        subu $t4, $s1, $t2   # end offset from display
        addu $t4, $t4, $t6               # corresponding address in other_grid

    markWhiteLeftDiagLoop:          # marks the matches white in other_grid
        sw $t7, 0($t5)
        beq $t5, $t4, resetLeftDiagRun
        addi $t5, $t5, 124      # 31 pixels (one row is 32) x 4 bytes goes to the next left diagonal pixel
        j markWhiteLeftDiagLoop

    resetLeftDiagRun:
        move $s0, $zero
        move $s1, $zero

    nextLeftDiagPixel:
        addi $t0, $t0, 0x7c          # go to the next pixel diagonal down left
        beq $a0, 0x00808080, nextLeftDiagColumn    # reached left or bottom border (grey), move on to next column
        j startLeftDiagLoop
        
    nextLeftDiagColumn:
        addi $t3, $t3, 4            # go to next pixel in the current row
        move $t0, $t3               # reset pointer to this pixel
        move $s0, $zero             # reset run
        move $s1, $zero
        j startLeftDiagLoop

nextLeftDiagRow:
    move $s0, $zero
    move $s1, $zero
    subu $t3, $t3, 24           # move back to left side
    addi $t3, $t3, 0x80           # move to next row 128 bytes (32 pixels × 4 bytes)
    move $t0, $t3                   # new starting position for $t0
    addi $t8, $t8, 1
    j leftDiagLoop
    
done:
    jr $ra


# |-----------------------------------------------------------------------------------------------|

# |-------------------------------| Function: removeMatchingGems   |------------------------------------|

# Arguments: None
# Return Value: $t6 as a boolean for whether any pixels were dropped. 0 = no pixels dropped, 1 = at least 1 pixel was dropped

# |-------------------------------| Function: removeMatchingGems (bottom-right scan) |------------------------------------|
# Arguments: None
# Return Value: $t6 = 1 if at least one pixel was dropped, 0 otherwise

removeMatchingGems:

    lw $t2, whiteColour    # white
    lw $t3, blackColour    # black
    li $t6, 0              # no pixels dropped yet

    # Start from bottom-right corner in other_grid
    lw $t0, bottomRightCorner
    lw $t5, displayAddress
    subu $t0, $t0, $t5       # offset from display
    la $t5, other_grid
    addu $t0, $t5, $t0       # bottom-right in other_grid

    lw $t9, topLeftCorner
    lw $t5, displayAddress
    subu $t9, $t9, $t5       # top-left offset
    la $t5, other_grid
    addu $t9, $t5, $t9       # top-left in other_grid
    subu $t9, $t9, 4

    # li $t7, 0                # row counter

removeGemRowLoop_BR:
    # Calculate start of current row (leftmost pixel)
    subu $t1, $t0, 24        # left border = 6 pixels left 
    
removeGemLoop_BR:
    blt $t0, $t9, doneRemove  # if we passed top-left, stop
    beq $t1, $t0, nextRow_BR  # done row

    lw $t4, 0($t0)            # read pixel
    beq $t4, $t2, checkAbove_BR  # if white, try drop
    j nextRemovePixel_BR

checkAbove_BR:
    subu $t8, $t0, 0x80      # pixel above (1 row up)
    lw $t4, 0($t8)
    beq $t4, $t3, paintBlack_BR # if above is black, just paint current black
    # else, swap
    li $t6, 1                 # pixel dropped
    sw $t4, 0($t0)            # move above pixel down
    sw $t2, 0($t8)            # make pixel above white
    j nextRemovePixel_BR

paintBlack_BR:
    sw $t3, 0($t0)
    j nextRemovePixel_BR

nextRemovePixel_BR:
    addi $t0, $t0, -4         # move left
    j removeGemLoop_BR

nextRow_BR:
    addi $t0, $t0, 24           # go back to right side
    subu $t0, $t0, 0x80       # move one row up
    j removeGemRowLoop_BR

doneRemove:
    jr $ra



# |-----------------------------------------------------------------------------------------------|

# |-----------------------------------| Function: gameOver |--------------------------------------|

# Arguments: 		none
# Return values: 	none

gameOver:
    jal fillBlack
    
gameOverDrawing:
    lw $t0, displayAddress
    lw $t1, blueColour
    la $t2, gameOverPixels
    la $t3, gameOverPixelsEnd

drawGameOverLoop:
    beq $t2, $t3, retryLoop

    lw $t4, 0($t2)      # x
    lw $t5, 4($t2)      # y

    # offset = y*32 + x
    li $t6, 32
    mul $t7, $t5, $t6
    add $t7, $t7, $t4
    sll $t7, $t7, 2      # each pixel = 4 bytes same as multiplying by 4
    add $t7, $t0, $t7       # get location on display

    sw $t1, 0($t7)

    addi $t2, $t2, 8
    j drawGameOverLoop

retryLoop:
    lw $t0, ADDR_KBRD       # keyboard base
    lw $t1, 0($t0)          # is a key pressed? 1 = yes
    beq $t1, $zero, retryLoop  # no key pressed, keep looping

    lw $t2, 4($t0)          # get ASCII of pressed key
    beq $t2, 0x71, quitGame     # 'q' is pressed so quit game
    bne $t2, 0x72, retryLoop   # if not 'r' or 'q', retryLoop
    # If 'r' pressed, retry
    j restartGame
    
quitGame:
    li $v0, 10               # syscall 10 = exit program
    syscall

# |-----------------------------------------------------------------------------------------------|

# |-----------------------------| Function: applyGravity |--------------------------------------|

# Arguments: 		locationTopGem as location of the top gem
# Return values: 	locationTopGem as one pixel down

applyGravity:
    # Check bottom collision (same as pressing S)
    jal checkBotAndTopCollision

    # If no collision, just return (can't fall)
    # jr $ra

    # Otherwise, move the column down
    lw $t0, locationTopGem
    addi $t0, $t0, 0x80      # drop 1 pixel
    sw $t0, locationTopGem

    # go back to game loop to redraw new column and continue game
    j gameLoop

# |-----------------------------------------------------------------------------------------------|

# |-----------------------------| Function: pauseGame |--------------------------------------|

# Arguments: 		$t9 with the previously pressed key
# Return values: 	none
pauseGame:
    # Freeze game until P is pressed again
# draw paused screen
jal fillBlack
    
pausedDrawing:
    lw $t0, displayAddress
    lw $t1, whiteColour

    la $t2, pausedPixels
    la $t3, pausedPixelsEnd

drawPausedLoop:
    beq $t2, $t3, waitForUnpause    # done drawing

    lw $t4, 0($t2)      # x
    lw $t5, 4($t2)      # y

    # offset = y*32 + x
    li $t6, 32
    mul $t7, $t5, $t6
    add $t7, $t7, $t4
    sll $t7, $t7, 2      # each pixel = 4 bytes same as multiplying by 4
    add $t7, $t0, $t7       # get location on display

    sw $t1, 0($t7)

    addi $t2, $t2, 8
    j drawPausedLoop

waitForUnpause:
    lw $t0, ADDR_KBRD       # keyboard base
    lw $t1, 0($t0)          # is a key pressed? 1 = yes
    beq $t1, $zero, waitForUnpause  # no key pressed, keep looping

    lw $t2, 4($t0)          # get ASCII of pressed key
    li $t3, 0x70            # ASCII for 'p'
    bne $t2, $t3, waitForUnpause   # if not 'p', keep looping

    # If 'p' pressed, exit pause
    j gameLoop
    
# |-----------------------------------------------------------------------------------------------|

# |-----------------------------| Function: fillBlack  |--------------------------------------|
fillBlack:
lw $t0, displayAddress
li $t2, 1024               # number of pixels
li $t3, 0                   # counter
lw $t1, blackColour         # black colour

    drawBlackScreen:
    beq $t3, $t2, doneFillBlack    # done filling black
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    addi $t3, $t3, 1
    j drawBlackScreen

doneFillBlack:
    jr $ra
    
# |------------------------------------------------------| SOUND EFFECTS|----------------------------------------------------|

#syscall 31 can play a note at a pitch $a0, $a1 duration, $a2 instrument $a3 volume. 
makeSoundStoreColumn:
    li $v0, 31       # syscall 31 = play note

    li $a0, 60       # pitch (60 is middle C)
    li $a1, 30      # duration in ms     
    li $a2, 80        # instrument (0 = piano)
    li $a3, 100      # volume (0–127)

    syscall
    jr $ra
    
makeSoundShuffle:
    li $v0, 31       # syscall 31 = play note

    li $a0, 40       # pitch (60 is middle C)
    li $a1, 30      # duration in ms     
    li $a2, 108        # instrument (0 = piano)
    li $a3, 100      # volume (0–127)

    syscall
    jr $ra
    
makeSoundLeftRightDown:
    li $v0, 31       # syscall 31 = play note

    li $a0, 30       # pitch (60 is middle C)
    li $a1, 30      # duration in ms     
    li $a2, 108        # instrument (0 = piano)
    li $a3, 100      # volume (0–127)

    syscall
    jr $ra
    
makeSoundMatch:
    li $v0, 31       # syscall 31 = play note

    li $a0, 100       # pitch (60 is middle C)
    li $a1, 30      # duration in ms     
    li $a2, 98        # instrument (0 = piano)
    li $a3, 120      # volume (0–127)

    syscall
    jr $ra
 
# |-----------------------------------------------------------------------------------------------|

# |-----------------------------| Function: restartGame |--------------------------------------|

# Arguments: 		none
# Return values: 	reset other_grid, reset gravityCounter

restartGame:
    # Clear the other_grid
    la $t0, other_grid
    li $t1, 0
    li $t2, 4096            # size of grid in bytes

clearLoop:
    beq $t1, $t2, doneClear
    sw $zero, 0($t0)        # set each address in other grid to 0 
    addi $t0, $t0, 4
    addi $t1, $t1, 4
    j clearLoop
    
doneClear:

    # Reset gravity counter
    sw $zero, gravityCounter

    j main

# |-----------------------------------------------------------------------------------------------|

# |-----------------------------| Function: increaseGravity |--------------------------------------|

# Arguments: 		none
# Return values: 	gravityCounterThreshold decreased

increaseGravity:
    # decrease gravity threshold by 1 frame. (in other words, make gravity faster)
    lw $t0, gravityCounterThreshold
    subu $t0, $t0, 1
    sw $t0, gravityCounterThreshold
    
jr $ra

# |-----------------------------------------------------------------------------------------------|

# |-----------------------------| Function: playColumnsMelody |--------------------------------------|
# this function plays the next note in the columns theme song (Clotho)
# Arguments: 		none
# Return values: 	none

# Uses syscall 31 to trigger notes 
# advances one note when timer reaches 0
playColumnsMelody:
    # load timer
    la $t0, columns_timer
    lw $t0, 0($t0)
    bgtz $t0, pcm_tick_down
    
    # timer == 0 -> load next note
    la $t1, columns_index
    lw $t1, 0($t1)          # t1 = index

    la $t2, columns_melody
    lw $t3, columns_melody_length
    # if index >= length -> loop
    bge $t1, $t3, pcm_reset_index

pcm_load_note:
    # address of note = columns_melody + index * 8 (two words = 8 bytes)
    sll $t4, $t1, 3        # index * 8
    addu $t5, $t2, $t4     # t5 -> note pair base

    lw $a0, 0($t5)         # pitch -> a0 (MIDI note)
    lw $a1, 4($t5)         # duration frames
    # store timer
    la $t7, columns_timer
    sw $a1, 0($t7)

    # Play the note (syscall 31)
    li $v0, 31
    # Send a short ms so syscall plays a short tone.
    li $a2, 80            # instrument (lead / square-ish)
    li $a3, 120           # volume
    syscall

    # advance index
    addi $t1, $t1, 1
    la $t8, columns_index
    sw $t1, 0($t8)

    jr $ra

pcm_reset_index:
    # reset index to 0 and load note
    li $t1, 0
    la $t8, columns_index
    sw $t1, 0($t8)
    j pcm_load_note

pcm_tick_down:
    # decrease timer by 1
    addi $t0, $t0, -1
    la $t7, columns_timer
    sw $t0, 0($t7)
    jr $ra
