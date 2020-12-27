.data
struct: .space 50  # not null-terminated during grading!
num_rows: .word 8
num_cols: .word 6
character: .byte 'x'

.text
main:
la $a0, struct
lb $a1, num_rows
lb $a2, num_cols
lbu $a3, character
jal initialize

# report return values
move $a0, $v0
li $v0, 1
syscall

li $v0, 11
li $a0, ' '
syscall

move $a0, $v1
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
