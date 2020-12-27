.data
state:
.byte 6
.byte 10
.asciiz "....................OOO.......OOOO.....OOOOOO....OOOOOOO..OO"  # not null-terminated during grading!
row: .word 4 # this is test case #3 in the PDF
col: .word 0
piece:
.byte 2
.byte 3
.asciiz "OOOO.." # not null-terminated during testing!

.text
main:
la $a0, state
lw $a1, row
lw $a2, col
la $a3, piece
jal count_overlaps

# report return value
move $a0, $v0
li $v0, 1
syscall

li $v0, 11
li $a0, '\n'
syscall

li $v0, 10
syscall

.include "proj3.asm"
