.data
struct:
.byte 6
.byte 10
.asciiz "....................OOO.......OOOO.....OOOOOO....OOOOOOO..OO" # not null-terminated during grading!
row: .word 3
col: .word 4
character: .byte 'X'

.text
main:
la $a0, struct
lw $a1, row
lw $a2, col
lbu $a3, character
jal set_slot

# report return value
move $a0, $v0
li $v0, 1
syscall

li $v0, 11
li $a0, '\n'
syscall

# report the contents of the struct
la $t0, struct
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

li $v0, 10
syscall

.include "proj3.asm"
