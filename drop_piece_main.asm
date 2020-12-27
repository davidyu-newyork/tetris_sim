.data
state:
.byte 8
.byte 10
.asciiz "...........O.........O.........O......O.OO.....OOOOOOO...OOOOOOOO.OOOOOOOOO.OOOO" # not null-terminated during grading!
col: .word 4
piece:
.byte 2
.byte 3
.asciiz "OOO.O." # not null-terminated during testing!
rotation: .word 3
rotated_piece: .asciiz "????????" # not null-terminated during testing!

.text
main:
la $a0, state
lw $a1, col
la $a2, piece
lw $a3, rotation
la $t0, rotated_piece
addi $sp, $sp, -4
sw $t0, 0($sp)
li $t0, 0x839313  # trashing $t0
jal drop_piece
addi $sp, $sp, 4

# report return value
move $a0, $v0
li $v0, 1
syscall

li $v0, 11
li $a0, ' '
syscall

li $v0, 11
li $a0, '\n'
syscall

# report the contents of the game state struct
la $t0, state
lb $a0, 0($t0)
li $v0, 1
syscall

li $v0, 11
li $a0, ' '
syscall

lb $a0, 1($t0)
li $v0, 1
syscall

li $v0, 11
li $a0, ' '
syscall

# replace this syscall 4 with some of your own code that prints the game field in 2D
move $a0, $t0
addi $a0, $a0, 2
li $v0, 4
syscall

li $v0, 11
li $a0, '\n'
syscall

# the contents of rotated_piece will not be checked during grading, so we don't print it here

li $v0, 10
syscall

.include "proj3.asm"
