.data
state:
.byte 6
.byte 10
.asciiz "....................OOO.......OOOO.....OOOOOOOOOOOOOOOOO..OO" #not null-terminated during grading!
row: .word 4

.text
main:
la $a0, state
lw $a1, row
jal check_row_clear

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
