# CSE 220 Programming Project #3
# David Yu
# DJYU

.text
initialize:
	li $t0, -1
	ble $a1, $t0, error
	ble $a2, $t0, error
	j else
error:
	li $v0, -1
	li $v1, -1
	jr $ra
else: #if correct row and column
	mult $a1,$a2
	mflo $t0
	sb $a1, 0($a0)
	addi $a0,$a0,1
	sb $a2, 0($a0)
	addi $a0,$a0,1
for.init:
	beqz $t0, init.end
	
	sb $a3, 0($a0)
	addi $a0,$a0,1
	addi $t0,$t0,-1
	j for.init
init.end:
	move $v0, $a1
	move $v1, $a2

	jr $ra

load_game:
	
	addi $sp,$sp -8
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	move $s0,$a0
	move $s1, $a1
	
	move $a0,$a1 #filename to a0
	li $a1, 0
	li $a2, 0
	li $v0, 13
	syscall
	li $t5 -1
	ble $v0,$t5, error
	move $s7, $v0 #contains file desprictoer
	addi $sp,$sp -1
	
	move $a1, $sp
	move $a0, $s7
	
firstTwo:
	li $t5, 2
	beq $t4,$t5, addRest

	li $v0, 14
	li $a2, 1 # one character at a time
	syscall
	li $t2, '\n'

	lb $t0, 0($sp)
	beq $t0,$t2, firstTwo
	addi $t0, $t0, -48
	
	li $v0, 14
	syscall
	
	lb $t1, 0($sp)
	beq $t1,$t2, single
	addi $t1, $t1, -48
	

	j addNumOne
single:
	sb $t0, 0($s0)
	addi $s0,$s0,1
	
	addi $t4,$t4,1 #counter for 2
	j firstTwo
addNumOne:
	li $t2, 10
	mult $t0,$t2
	
	mflo $t0
	add $t0, $t0,$t1
	sb $t0, 0($s0)
	
	addi $s0,$s0,1
	
	addi $t4,$t4,1 #counter for 2
	j firstTwo

addRest: #first two numbers works, now add rest
	lbu $t0, -2($s0)
	lbu $t1, -1($s0)
	mult $t0,$t1

	mflo $t9 #counter

	li $t8, 0 # 0 counter
	li $t7, 0 #invalid counter
	li $t5, 0
addRest.loop:
	beqz $t9, addRest.end

	li $v0, 14
	syscall
	
	lb $t0, 0($sp)
	
	li $t1, '\n'
	beq $t0,$t1,addRest.loop
	li $t1, 'O'
	beq $t0,$t1,addRest.addO
	li $t1, '.'
	bne $t0,$t1,addRest.addInvalid
	
	sb $t0, 0($s0)
	addi $s0,$s0,1
	addi $t9,$t9, -1
	j addRest.loop
	
addRest.addInvalid:
	li $t0, '.'
	sb $t0, 0($s0)
	addi $s0,$s0,1
	addi $t7,$t7,1
	addi $t9,$t9, -1
	j addRest.loop

addRest.addO:
	sb $t0, 0($s0)
	addi $s0,$s0,1
	addi $t8,$t8,1
	addi $t9,$t9, -1
	j addRest.loop
	

addRest.end:
	li $t0, '\0'
	sb $t0, 0($s0)
	move $v0, $t8
	move $v1, $t7
	
	
	addi $sp,$sp 1
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
		
	addi $sp,$sp 8
   	jr $ra

get_slot:
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	

	#check if -1 or less
	li $t0, -1
	ble $a1, $t0, error.get
	ble $a2, $t0, error.get
	#check if greater then row/col
	lbu $t0, 0($s0)
	bge $a1, $t0, error.get
	lbu $t1, 1($s0)
	bge $a2, $t1, error.get
	# if not in range of row or column throw error
	
	#get index of [i][j] -- [row][col]
	
	mult $s1, $t1 #i times columns
	mflo $t1
	add $t1,$s2,$t1 # j + that
	li $t5, 1
	mult $t1, $t5
	mflo $t1

	add $a0, $t1, $s0
	addi $a0, $a0, 2
	lbu $v0, 0($a0)

	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	
	addi $sp, $sp, 12
    	jr $ra
error.get:
	li $v0,-1
	li $v1,-1
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	
	addi $sp, $sp, 12
    	jr $ra

set_slot:

	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
#check if -1 or less
	li $t0, -1
	ble $a1, $t0, error.get
	ble $a2, $t0, error.get
	#check if greater then row/col
	lbu $t0, 0($s0)
	bge $a1, $t0, error.get
	lbu $t1, 1($s0)
	bge $a2, $t1, error.get
	
	mult $s1, $t1 #i times columns
	mflo $t1
	add $t1,$s2,$t1 # j + that
	li $t5, 1
	mult $t1, $t5
	mflo $t1
	
	add $a0, $t1, $s0
	addi $a0, $a0, 2
	sb $a3, 0($a0)
	move $v0, $a3
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	
	addi $sp, $sp, 12
	
    jr $ra

rotate:



	li $t0, -1
	ble $a1 $t0, error
	li $t0, 2
	div $a1, $t0
	addi $sp,$sp -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $ra, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	beqz $a1, rotate.end.setRotated
for.O.special:
	lbu $t0, 2($a0)
	sb $t0, 2($a2)
	li $t1, 'O'
	beq $t0,$t1 next.O.One
	j not.O
next.O.One:
	lbu $t0, 3($a0)
	sb $t0, 3($a2)
	beq $t0,$t1 next.O.Two
next.O.Two:
	lbu $t0, 4($a0)
	sb $t0, 4($a2)
	beq $t0,$t1 next.O.Three
next.O.Three:
	lbu $t0, 5($a0)
	sb $t0, 5($a2)		
	beq $t0,$t1 next.O.dot
	j not.O
next.O.dot:
	lbu $t0, 6($a0)
	li $t1, '.'
	sb $t0, 6($a2)	
	beq $t0,$t1 next.O.dotTwo
	j not.O
next.O.dotTwo:
	lbu $t0, 7($a0)
	sb $t0, 7($a2)
	
	beq $t0,$t1 is.O.Piece
	j not.O
is.O.Piece:
	mfhi $t3
	lb $t0, 0($a0)
	lb $t1, 1($a0)
	sb $t0, 0($a2)
	sb $t1, 1($a2)
	beqz $t3, rotate.end
	sb $t0, 1($a2)
	sb $t1, 0($a2)
	j rotate.end

not.O:
	
	move $a0, $a2
	lb $a1, 0($s0)
	lb $a2, 1($s0)
	li $a3, '.'
	li $t0, 2
	div $s1, $t0
	mfhi $t0
	
	j even_rotation
	
	lb $a2, 0($s0)
	lb $a1, 1($s0)
	jal initialize
	j now.rotate
even_rotation:
	jal initialize
now.rotate:
	li $s6, 0
	addi $sp, $sp, -32
	lb $t0,0($s0)
	sw $t0, 0($sp)
	lb $t0,1($s0)
	sw $t0, 4($sp)
	lb $t0,2($s0)
	sw $t0, 8($sp)
	lb $t0,3($s0)
	sw $t0, 12($sp)
	lb $t0,4($s0)
	sw $t0, 16($sp)
	lb $t0,5($s0)
	sw $t0, 20($sp)
	lb $t0,6($s0)
	sw $t0, 24($sp)
	lb $t0,7($s0)
	sw $t0, 28($sp)
now.rotate.loop:
  	j bigyaba
 smalyaba:
	lb $t0,0($s2)
	sb $t0,0($s0)
	lb $t0,1($s2)
	sb $t0,1($s0)
	lb $t0,2($s2)
	sb $t0,2($s0)
	lb $t0,3($s2)
	sb $t0,3($s0)
	lb $t0,4($s2)
	sb $t0,4($s0)
	lb $t0,5($s2)
	sb $t0,5($s0)
	lb $t0,6($s2)
	sb $t0,6($s0)
	lb $t0,7($s2)
	sb $t0,7($s0)
bigyaba:
	li $s4, 0 #row counter
	li $s5, 0 #column counter
	beq $s6,$s1, rotate.endd
	lb $t0,0($s2)
	lb $t1, 1($s2)
	sb $t0, 1($s2)
	sb $t1, 0($s2)
	addi $s6,$s6,1
	
	j for.columns
for.rows:
	
	lb $t0, 0($s0)	
	addi $t0,$t0,-1
	beq $t0, $s4, smalyaba
	addi $s4,$s4, 1 #increment row
	li $s5, 0 #column counter
	
for.columns:
	lb $t0, 1($s0)
	move $a0, $s5
	beq $t0, $s5, for.rows
	
	
	
	move $a0, $s0
	move $a1, $s4
	move $a2, $s5
	jal get_slot

	move $a0, $s2
	lb $t0, 0($s0) #rows-1-r
	sub $a2, $t0, $s4
	addi $a2,$a2,-1
	
	move $a0, $s2

	move $a1, $s5
	move $a3, $v0

	jal set_slot #rotated[c] [rows-1-r] = original [r][c] 
	
	addi $s5,$s5,1 #increment c
	j for.columns


rotate.endd:
	lw $t0, 0($sp)
	sb $t0,0($s0)
	lw $t0, 4($sp)
	sb $t0,1($s0)
	lw $t0, 8($sp)
	sb $t0,2($s0)
	lw $t0, 12($sp)
	sb $t0,3($s0)
	lw $t0, 16($sp)
	sb $t0,4($s0)
	lw $t0, 20($sp)
	sb $t0,5($s0)
	lw $t0, 24($sp)
	sb $t0,6($s0)
	lw $t0, 28($sp)
	sb $t0,7($s0)
	addi $sp, $sp, 32
rotate.end:

	move $v0, $s1
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	addi $sp,$sp, 24
    jr $ra
rotate.end.setRotated:

	lb $t0, 0($s0)
	sb $t0, 0($s2)
	lb $t0, 1($s0)
	sb $t0, 1($s2)
	lb $t0, 2($s0)
	sb $t0, 2($s2)
	lb $t0, 3($s0)
	sb $t0, 3($s2)
	lb $t0, 4($s0)
	sb $t0, 4($s2)
	lb $t0, 5($s0)
	sb $t0, 5($s2)
	lb $t0, 6($s0)
	sb $t0, 6($s2)
	lb $t0, 7($s0)
	sb $t0, 7($s2)

	move $v0, $s1
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	addi $sp,$sp, 24
    jr $ra




count_overlaps:
	addi $sp,$sp -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s5, 20($sp)
	sw $ra, 16($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
	j count.test #---------------------------------------------
	#check valid row
	lb $t0, 0($a0)
	
	move $t1, $t0
	lb $t2, 0($a3)
	
	add $t1,$a1,$t2 # add rows together
	addi $t1,$t1,-1
	bge $t1,$t0, error.count #if added row numbers -1 is greater, return -1, error
	
	#valid columsn
	
	lb $t0, 1($a0)
	move $t1, $t0
	lb $t2, 1($a3)
	add $t1,$a2,$t2 # add rows together
	addi $t1,$t1,-1

	bge $t1,$t0, error.count #if added row numbers -1 is greater, return -1, error

	#now check if slot is taken get slot, loop through num of column ++ of piece
	
	#get index by multiplying za stoof
	#lb $t0, 1($a0) #num column
	#mult $t0, $a1 # 8 i
	#mflo $t0
	#add $t0,$t0,$a2 # +j
	
	#add $a0, $a0, $t0 #plus to the address
	
	#move $s0, $a0 #store
	lb $s5,1($s3) #num of columns
	addi $s3,$s3, 2 #tart at characters
	#for columns in piece, then add num of columns of game state to #s0
	move $s7, $s2

	li $t9, 0 
	li $t8, 0
	li $t7, 0
	j count.column.loop
count.row.loop:
	move $s2, $s7 #move it back columns
	addi $s1,$s1,1
	li $t7, 0
	move $s4, $s5
count.column.loop:
	#get slot #a1 row, $a2 col
	beq $s5,$t7, count.row.loop
	li $t0, 6
	beq $t8,$t0, count.done
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	
	jal get_slot
	
	lb $t0, 0($s3)
	addi $s2,$s2,1
	addi $s3,$s3,1
	addi $t8,$t8,1
	bne $t0, $v0, skip
	li $t0, 'O'
	bne $t0, $v0, skip
	addi $t9,$t9, 1 #count of overlap
skip:
	addi $s4,$s4,-1 #counter of columns
	addi $t7,$t7, 1
	
j count.column.loop

count.test:
	lb $t0, 0($s3)
	lb $s5, 1($s3) # column
	addi $s3,$s3, 2
	li $t9, 0 
	li $t8, 0 #column counter
	li $s4, 0 #counter for gang gang conter
piece.loop: #s1 col s2 row
	li $t2, 6
	beq $t9,$t2, count.done
	lb $t2, 0($s3) #--------------------- s3 getting corrupted
	
	bne $t8, $s5, skip.col
	#s5 countains columns of piece
	li $t8,0
	addi $s1,$s1, 1
skip.col:

	addi $s3,$s3,1
	addi $t9,$t9, 1
	li $t3, 'O'
	beq $t2,$t3, check.slot
	
	addi $t8,$t8,1
	
	j piece.loop
	
check.slot:
	move $a0, $s0
	move $a1,$s1
	move $a2, $s2
	add $a2,$a2,$t8
	
	jal get_slot
	li $t3, -1
	beq $v0,$t3,error.count
	li $t3,'O'
	bne $t3, $v0, skip.inc
	addi $s4,$s4,1
skip.inc:
	
	addi $t8,$t8,1
	j piece.loop
	

count.done:
	
	move $v0,$s4	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)
	lw $s5, 20($sp)
	addi $sp,$sp 24
	jr $ra
error.count:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s5, 20($sp)
	lw $ra, 16($sp)
	addi $sp,$sp 24

	jr $ra

drop_piece:

	lw $s5, 0($sp) #loads rotated piece into $s5
	addi $sp,$sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s5, 20($sp)
	sw $ra, 16($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
	
	li $t0, -1
	ble $s3, $t0, return.negTwo #rotation
	ble $s1, $t0, return.negTwo #column
	
	#now rotate the piece
	move $a0, $s2
	move $a1, $s3 #move rotations to a1
	move $a2, $s5
	jal rotate

	#now rotated, check if columns are overlapping 
	lb $t0, 1($s5) #load column from rotated piece
	add $t0, $t0, $s1 #potentially need to -1 --------------------
	addi $t0,$t0, -1
	lb $t1, 1($s0)
	bge $t0,$t1, return.negThree
	li $s3, 0 #use #$s3 as row counter
	#valid, now check if overlapping starting with col, row = 0
drop.loop:
	move $a0, $s0
	move $a1, $s3
	move $a2, $s1 #columns to here
	move $a3, $s5 #rotated piece to here
	
	jal count_overlaps
	
	beqz $s3, first.instance
	j skip.firstI
first.instance:
	li $t0, -1
	ble $v0,$t0, return.negOne
skip.firstI:
	li $t0, 1
	bge $v0,$t0, drop.da.piece
	li $t0, -1
	ble $v0,$t0, drop.da.piece
	addi $s3,$s3,1
	j drop.loop
drop.da.piece:
	addi $s3,$s3,-1 #move row up one cuz one more down and its colliding
	lb $t0, 0($s5)
	
	#sub $s3,$s3,$t0

	move $t6,$s3
	#now set piece to board
	lb $s2, 1($s5) #num of columsn in $s0
	addi $s5,$s5, 2
	li $t9,0 #counter col
	li $t8, 0 
	j da.loop.p
inc.the.row:
	addi $s3,$s3,1
	li $t9,0 
	sub $s1,$s1,$s2
da.loop.p: #s3 contains what row to start at
	li $t2, 6
	beq $t8,$t2, drop.done
	beq $t9,$s2, inc.the.row
	lb $a3, 0($s5)
	li $t0, 'O'

	bne $a3,$t0, skip.char
	move $a0,$s0
	move $a1, $s3 #row
	move $a2, $s1 #column
	jal set_slot
	
skip.char:
	addi $s1,$s1, 1
	addi $s5,$s5,1 #increment the string
	addi $t9,$t9,1
	addi $t8,$t8,1
	j da.loop.p
	
	
drop.done:
	move $v0, $t6
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s5, 20($sp)
	lw $ra, 16($sp)
	addi $sp,$sp, 24
	jr $ra
return.negOne:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s5, 20($sp)
	lw $ra, 16($sp)
	addi $sp,$sp, 24
	li $v0, -1
	jr $ra
return.negTwo:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s5, 20($sp)
	lw $ra, 16($sp)
	addi $sp,$sp, 24
	li $v0, -2
	jr $ra

return.negThree:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s5, 20($sp)
	lw $ra, 16($sp)
	addi $sp,$sp, 24
	li $v0, -3
	jr $ra

	jr $ra

check_row_clear:
	li $t0,-1
	ble $a1,$t0, return.one
	lb $t1, 0($a0)
	bge $a1,$t1, return.one
	
	addi $sp,$sp,-16
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $ra, 12($sp)
	move $s0,$a0
	move $s1,$a1
	li $s2,0
check.if.O.loop:
	lbu $t0, 1($s0)
	beq $s2,$t0, clear.it #if column = column, they are all o

	move $a0, $s0 #strucutre
	move $a1,$s1 #r0w
	move $a2,$s2 #column
	jal get_slot
	li $t0, 'O'
	bne $t0,$v0, return.zero
	addi $s2,$s2,1 #increment column

	j check.if.O.loop
	
clear.it:
	li $s2,0
	j clear.it.loop
clear.it.now:
	li $s2,0
	addi $s1,$s1,-1
clear.it.loop:
	lbu $t0, 1($s0)
	beq $s2,$t0, clear.it.now #if column = column, they are all o
	#get row above, then set
	li $t0, 0
	beq $t0,$s1,set.topRow#if row is one, go set row 0 to 0's
	move $a0, $s0 #strucutre 
	move $a1,$s1 #r0w
	addi $a1,$a1,-1
	move $a2,$s2 #column
	jal get_slot
	
	move $a0, $s0 #strucutre 
	move $a1,$s1 #r0w
	move $a2,$s2 #column
	move $a3,$v0
	jal set_slot
	
	addi $s2,$s2,1
	
	j clear.it.loop
set.topRow:
	li $s2,0
topRow.loop:

	lbu $t0, 1($s0)
	beq $s2,$t0, clear.the.end #if column = column, they are all o
	#get row above, then set
	
	move $a0, $s0 #strucutre 
	move $a1,$s1 #r0w
	move $a2,$s2 #column
	li $a3,'.'
	jal set_slot
	
	addi $s2,$s2,1
	
	j topRow.loop
clear.the.end:

	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)
	addi $sp,$sp,16
	li $v0, 1
	jr $ra
return.zero:
	li $v0, 0

	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)
	addi $sp,$sp,16
	jr $ra
return.one:
	li $v0, -1
	jr $ra

simulate_game:
	lw $s4, 0($sp) #number of pieces to drop

	lw $s5, 4($sp) #pieces array
	
	addi $sp,$sp,-24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $ra, 12($sp)
	sw $s1, 16($sp)
	sw $s2, 20($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
#load game
	move $a0, $s0
	move $a1,$s1
	jal load_game
	
	

	li $t0, -1
	beq $v0,$t0, return.zero.zero
	beq $v1,$t0, return.zero.zero
	#game state is now loaded, $s1 can now be used
	li $s1, 0 #number of successful drops
	addi $sp,$sp, -24 #------------------------------------------------
	li $t0,0
	sw $t0, 0($sp) #move number
	#get length of moves
	li $t0,0
	move $a2, $s2
len.moves.loop:
	lb $t1, 0($a2) 
	beqz $t1, got.length
	addi $t0,$t0,1
	addi $a2,$a2,1
	j len.moves.loop
got.length:
	li $t1,4
	div $t0,$t1
	mflo $t0 #get number of moves

	sw $t0, 4($sp)	#moves length
	li $t0, -1 # -1 for false
	sw $t0, 8($sp) #game over 
	li $t0,0
	sw $t0, 12($sp) #score
	sw $s4, 16($sp) #number of pieces to drop
	sw $s5, 20($sp) #pieces array
	#lw $t9, 0($sp) #number of pieces to drop
	#lw $t8, 4($sp) #pieces array
	#addi $sp,$sp, 24 #------------------------------------------------
	li $s1, 0
while.loop: #s1 number of successful drops
	li $t1, -1
	lw $t0, 8($sp) #game over 
	bne $t1,$t0, game.over #game over is true
	lw $t8, 16($sp) #number of pieces to drop
	bgt $s1, $t8, game.over
	
	lw $t0, 0($sp) #move number
	lw $t1, 4($sp)	#moves length
	bgt $t0,$t1, game.over
	
	#s2 contains moves
	
	lb $t0, 0($s2) #piece type as character
	lb $t1, 1($s2) #rotation
	lb $t2, 2($s2) #column first digit
	lb $t3, 3($s2) #column second digit
	addi $s2,$s2,4
	
	addi $t2,$t2, -48
	addi $t3,$t3, -48
	li $t5, 10
	mult $t2, $t5
	mflo $t2 #digit
	
	add $t2,$t3,$t2 #corret column
	
	li $t3, -1 #valid = false
	lw $t9, 20($sp) #pieces array
	li $t5 'T'
	bne $t0, $t5, check.J

	move $a2, $t9 #a2 is piece for drop piece
	j got.char
check.J:
	li $t5 'J'
	bne $t0, $t5, check.Z
	addi $t9,$t9,8
	move $a2, $t9 #a2 is piece for drop piece
	j got.char
check.Z:
	li $t5 'Z'
	bne $t0, $t5, check.O
	addi $t9,$t9,16
	move $a2, $t9 #a2 is piece for drop piece
	j got.char
check.O:
	li $t5 'O'
	bne $t0, $t5, check.S
	addi $t9,$t9,24
	move $a2, $t9 #a2 is piece for drop piece
	j got.char
check.S:
	li $t5 'S'
	bne $t0, $t5, check.L
	lw $t9, 20($sp) #pieces array
	addi $t9,$t9,32
	move $a2, $t9 #a2 is piece for drop piece
	j got.char
check.L:
	li $t5 'L'
	bne $t0, $t5, check.I
	lw $t9, 20($sp) #pieces array
	addi $t9,$t9,40
	move $a2, $t9 #a2 is piece for drop piece
	j got.char
check.I:
	lw $t9, 20($sp) #pieces array
	addi $t9,$t9,48
	move $a2, $t9 #a2 is piece for drop piece
got.char:


	move $a0, $s0 #state is CORRECT
	move $a1, $t2 #columns in $a1 now columns is CORREt
	#got piece in a2, MAYBE ERROR BECAUSE ITS NOT NULL TEMINATED
	addi $t1,$t1,-48
	move $a3, $t1
	
	
	addi $sp, $sp, -4
	sw $s3, 0($sp)
	jal drop_piece
	addi $sp, $sp, 4
	
	move $t0,$v0
	
	
	
	li $t0, -1
	beq $v0,$t0,set.over
	li $t0, -2
	beq $v0,$t0,invalid.true
	li $t0, -3
	beq $v0,$t0,invalid.true
	j check.line.clear
set.over:
	li $t0, 69
	sw $t0, 8($sp) #game over 

invalid.true:
	lw $t0, 0($sp) #move number
	addi $t0,$t0,1
	sw $t0, 0($sp) #move number
	j while.loop #continue

check.line.clear:
	 li $s7, 0 #count
	 #s6 for r
	 lb $s6, 0($s0)
	 addi $s6,$s6,-1 # for  r = state.num.rows -1
	 
while.r.Zero:
	bltz $s6, count.score
	move $a0,$s0
	move $a1,$s6
	jal check_row_clear
	li $t0, 1
		
	
	beq $t0,$v0, count.plus #if v0 = 1
	addi $s6,$s6,-1 #deincrement s6
	j while.r.Zero
	
count.plus:
	addi $s7,$s7,1
	j while.r.Zero
	
count.score:
 	li $t0,1
 	bne $s7,$t0, its.Two
 	
 	lw $t0, 12($sp) #score
 	addi $t0,$t0,40
 	sw $t0, 12($sp) #score
 	j increment.moves
 	
its.Two:
	li $t0,2
 	bne $s7,$t0, its.Three
 	
 	lw $t0, 12($sp) #score
 	addi $t0,$t0,100
 	sw $t0, 12($sp) #score
 	j increment.moves
its.Three:
	li $t0,3
 	bne $s7,$t0, its.Four
 	
 	lw $t0, 12($sp) #score
 	addi $t0,$t0,300
 	sw $t0, 12($sp) #score
 	j increment.moves
its.Four:
	li $t0,4
 	bne $s7,$t0, increment.moves
 	lw $t0, 12($sp) #score
 	addi $t0,$t0,1200
 	sw $t0, 12($sp) #score
increment.moves: #movenumber ++ num succes drop ++
	lw $t0, 0($sp) #move number
	addi $t0,$t0,1
	sw $t0, 0($sp) #move number
	addi $s1,$s1,1
	j while.loop
 
	#dropping incorrectly
game.over:
	move $v0,$s1
	lw $v1, 12($sp) #score
	addi $sp,$sp, 24 #------------------------------------------------
	lw $ra, 12($sp)
	addi $sp,$sp, 24 #------------------------------------------------

	jr $ra

return.zero.zero:
	li $v0, 0
	li $v1, 0
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	addi $sp,$sp,24

	jr $ra

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
