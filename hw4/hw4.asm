##############################################################
# Homework #4
# name: Andy Liang
# sbuid: 111008856
##############################################################

.text

##############################
# Part I FUNCTIONS
##############################

# a0 = board array; a1 = num_rows =; a2 = num_cols; a3 = row; a4 = col; a5 = char being stored; a6 = turn_num
# return 0 for success and -1 for error
set_slot:
	# Load a4 - a6 into t registers
	lw $t0 0($sp)  # col
	lw $t1 4($sp)  # c 
	lw $t2 8($sp)  # turn_num
	
	# Error checks
	li $v0 -1
	
	# num_rows is less than 0
	bltz $a1 setSlotReturn
	
	# num_cols is less than 0
	bltz $a2 setSlotReturn
	
	# row is outside the range [0, num_rows - 1]
	bltz $a3 setSlotReturn
	bge $a3 $a1 setSlotReturn
	
	# col is outside the range [0, num_cols - 1]
	bltz $t0 setSlotReturn
	bge $t0 $a2 setSlotReturn
	
	# c is not character 'R', 'Y', or '.'
	beq $t1 82 cIsValid  # If equal to 'R'
	beq $t1 89 cIsValid  # If equal to 'Y'
	beq $t1 46 cIsValid  # If equal to '.'
	j setSlotReturn  # Error if not equal to 'R', 'Y', or '.'
	
	cIsValid:
	# turn_num is outside the range [0, 255]
	bltz $t2 setSlotReturn
	bgt $t2 255 setSlotReturn
	
	# No errors detected 

    # obj_arr[i][j] = base_address + (row_size * i) + (size_of(obj) * j)
    # row_size = num_cols * size_of(obj)
    li $t3 2  # Size of Object
	mul $t4 $a2 $t3 # row_size = num_cols * object_size
    mul $t4 $t4 $a3  # row_size * i
    mul $t5 $t0 $t3  # object_size * j
    add $t4 $t4 $t5  # (row_size * i) + (size_of(obj) * j)
    add $t4 $a0 $t4  # obj_arr[i][j]
    sb $t1 0($t4)  # Store character in obj_arr[i][j] in upper byte
    sb $t2 1($t4)  # Store turn_num in lower byte 
	
	# Set Slot Successful
    li $v0 0
    
    setSlotReturn:
    jr $ra


# a0 = board array; a1 = num_rows =; a2 = num_cols; a3 = row; a4 = col
# Return slot char in $v0 and turn number in $v1, else (-1, -1) for error
get_slot:
	# Load $a4 
	lw $t0 0($sp)  # col
	
	# Error checks
	li $v0 -1
	li $v1 -1
	
	# num_rows is less than 0
	bltz $a1 getSlotReturn
	
	# num_cols is less than 0
	bltz $a2 getSlotReturn
	
	# row is outside the range [0, num_rows - 1]
	bltz $a3 getSlotReturn
	addi $t3 $a1 -1  # num_rows - 1
	bgt $a3 $t3 getSlotReturn
	
	# col is outside the range [0, num_cols - 1]
	bltz $t0 getSlotReturn
	addi $t3 $a2 -1  # num_rows - 1
	bgt $t0 $t3 getSlotReturn
	
	# No errors detected
	
    # obj_arr[i][j] = base_address + (row_size * i) + (size_of(obj) * j)
    # row_size = num_cols * size_of(obj)
    li $t3 2  # Size of Object
	mul $t4 $a2 $t3 # row_size = num_cols * object_size
    mul $t4 $t4 $a3  # row_size * i
    mul $t5 $t0 $t3  # object_size * j
    add $t4 $t4 $t5  # (row_size * i) + (size_of(obj) * j)
    add $t4 $a0 $t4  # obj_arr[i][j]
    lb $v0 0($t4)  # Load upper byte
    lbu $v1 1($t4)  # Load lower byte
    
    getSlotReturn:
    jr $ra

# a0 = board array; $a1 = num_rows; $a2 = num_cols
# Return 0 for success, -1 otherwise
clear_board:
	# Save return address and s registers
	addi $sp $sp -28
	sw $ra 0($sp)
	sw $s0 4($sp)
	sw $s1 8($sp)
	sw $s2 12($sp)
	sw $s3 16($sp)
	sw $s4 20($sp)
	sw $s5 24($sp)
	# Move arguments into s registers
	move $s0 $a0
	move $s1 $a1  
	move $s2 $a2  
	
	# Error checks
	li $v0 -1
	
	# num_rows is less than 0
	bltz $s1 returnClearBoard
	
	# num_cols is less than 0
	bltz $s2 returnClearBoard
	
	# No errors detected
	li $s4 0  # Current row
	clearBoardRowLoop:
		bge $s4 $s1 boardCleared  # If the current row is equal or greater than the num_rows, the board is cleared
		li $s5 0  # Current column
		clearBoardColLoop:
			bge $s5 $s2 clearBoardNextRow  # If current column is equal or greater than the num_cols, move to next row
			# Load arguments for set_slot
			move $a0 $s0  # Load board array
			move $a1 $s1  # Load num_rows
			move $a2 $s2  # Load num_cols
			move $a3 $s4  # Load current rows
			addi $sp $sp -12
			sw $s5 0($sp)  # Load current col
			li $t0 46
			sw $t0 4($sp)  # Load "."
			li $t0 0  # Load 0 turn_num
			sw $t0 8($sp)  # Load 0 turn_num
			jal set_slot
			addi $sp $sp 12
			addi $s5 $s5 1  # Increment columns
			j clearBoardColLoop
		clearBoardNextRow:
		addi $s4 $s4 1  # Increment rows
		j clearBoardRowLoop
	
	boardCleared:
	li $v0 0

	returnClearBoard:
    # Return s registers to their original values
    lw $ra 0($sp)
	lw $s0 4($sp)
	lw $s1 8($sp)
	lw $s2 12($sp)
	lw $s3 16($sp)
	lw $s4 20($sp)
	lw $s5 24($sp)
	addi $sp $sp 28
    jr $ra


##############################
# Part II FUNCTIONS
##############################

# $a0 = board array; $a1 = filename
# Returns $v0 = num of rows; $v1 = num of cols; otherwise, (-1, -1) on error
load_board:
	# Save return address and s registers
	addi $sp $sp -24
	sw $ra 0($sp)
	sw $s0 4($sp)
	sw $s1 8($sp)
	sw $s2 12($sp)
	sw $s3 16($sp)
	sw $s4 20($sp)
	# Move arguments into s registers
	move $s0 $a0
	move $s1 $a1
	
	# Error Checks
	
	# File check
	move $a0 $a1  # Load filename
	li $a1 0  # Flag = 0 (read-only)
	li $a2 0  # Mode (ignored)
	li $v0 13  # Syscall 13: open file
	syscall 
	move $s2 $v0  # Copy file descriptor
	bltz $v0 errorLoadBoard  # Negative means file error
	
	# Read file
	
	# First line
	move $a0 $s2  # File descriptor
	addi $sp $sp -12  # 9 bytes for line including newline
	move $a1 $sp  # Address of input buffer
	li $a2 5  # Read first five characters
	li $v0 14  # Syscall 14: read file
	syscall
	bltz $v0 errorLoadBoard  # Negative means error
	# num_rows
	lbu $s3 0($sp) 
	li $t0 10
	mul $s3 $s3 $t0
	lbu $t0 1($sp)
	add $s3 $s3 $t0
	addi $s3 $s3 -528  # ASCII to int
	beqz $s3 errorLoadBoard  # Num_rows = 0 results in error
	# num_cols
	lbu $s4 2($sp) 
	li $t0 10
	mul $s4 $s4 $t0
	lbu $t0 3($sp)
	add $s4 $s4 $t0
	addi $s4 $s4 -528  # ASCII to int
	beqz $s4 errorLoadBoard  # Num_cols = 0 results in error
	
	# Subsequent Lines
	loadNextLine:
		move $a0 $s2  # File descriptor
		move $a1 $sp  # Address of input buffer
		li $a2 9  # Read next 9 characters
		li $v0 14  # Syscall 14: read file
		syscall
		blez $v0 boardLoaded  # 0 = end of file
		move $a0 $s0  # Copy board array
		move $a1 $s3  # num_rows
		move $a2 $s4  # num_cols	
		
		# Row
		lbu $a3 0($sp) 
		li $t0 10
		mul $a3 $a3 $t0
		lbu $t0 1($sp)
		add $a3 $a3 $t0
		addi $a3 $a3 -528  # ASCII to int
		bltz $a3 errorLoadBoard  # row < 0 results in error
		bgt $a3 $s3 errorLoadBoard  # row > num_rows results in error
		
		# column
		lbu $t9 2($sp)
		li $t0 10
		mul $t9 $t9 $t0
		lbu $t0 3($sp)
		add $t9 $t9 $t0
		addi $t9 $t9 -528  # ASCII to int
		bltz $t9 errorLoadBoard  # col < 0 results in error
		bgt $t9 $s4 errorLoadBoard  # col > num_cols results in error
		
		# Char symbol
		lbu $t8 4($sp)
		
		# Turn number
		lbu $t7 5($sp)
		li $t0 10
		mul $t7 $t7 $t0
		lbu $t6 6($sp)
		add $t7 $t7 $t6
		mul $t7 $t7 $t0
		lbu $t6 7($sp)
		add $t7 $t7 $t6
		addi $t7 $t7 -5328  # ASCII to int
		bltz $t7 errorLoadBoard  # turn_num < 0 results in error
		bgt $t7 255 errorLoadBoard  # turn_num > 255 results in error
		
		# Push $a4-$a6 arguments to stack
		addi $sp $sp -12
		sw $t9 0($sp)
		sw $t8 4($sp)
		sw $t7 8($sp)	
		jal set_slot
		addi $sp $sp 12
		
		j loadNextLine
	
	boardLoaded:
	addi $sp $sp 12
	move $v0 $s3  # num_rows
	move $v1 $s4  # num_cols
	j returnLoadBoard
	
	errorLoadBoard:
	li $v0 -1
	li $v1 -1
	
	returnLoadBoard:
    # Return s registers to their original values
    lw $ra 0($sp)
	lw $s0 4($sp)
	lw $s1 8($sp)
	lw $s2 12($sp)
	lw $s3 16($sp)
	lw $s4 20($sp)
	addi $sp $sp 24
    jr $ra


save_board:
    # Save return address and s registers
	addi $sp $sp -32
	sw $ra 0($sp)
	sw $s0 4($sp)
	sw $s1 8($sp)
	sw $s2 12($sp)
	sw $s3 16($sp)
	sw $s4 20($sp)
	sw $s5 24($sp)
	sw $s6 28($sp)
	# Move arguments into s registers
	move $s0 $a0  # Board Array
	move $s1 $a1  # num_rows
	move $s2 $a2  # num_cols
	
	# Error Checks
	# num_rows is less than 0
	bltz $s1 errorWriteBoard
	
	# num_cols is less than 0
	bltz $s2 errorWriteBoard
	
	# File check
	move $a0 $a3  # Load filename
	li $a1 1  # Flag = 1 (write-only with create)
	li $a2 0  # Mode (ignored)
	li $v0 13  # Syscall 13: open file
	syscall 
	move $s6 $v0  # Copy file descriptor
	bltz $v0 errorWriteBoard  # Negative means file error
	
	# Write first line
	addi $sp $sp -5
	
	# num_rows
	li $t1 10
	div $s1 $t1  # num_rows divided by 10
	mflo $t0  # Quotient
	addi $t0 $t0 48  # Int to ASCII
	sb $t0 0($sp)
	mfhi $t0
	addi $t0 $t0 48  # Int to ASCII
	sb $t0 1($sp)  # Remainder
	# num_cols
	div $s2 $t1  # num_cols divided by 10
	mflo $t0  # Quotient
	addi $t0 $t0 48  # Int to ASCII
	sb $t0 3($sp)
	mfhi $t0
	addi $t0 $t0 48  # Int to ASCII
	sb $t0 4($sp)  # Remainder
	sb $t1 5($sp)  # New line
	
	move $a0 $s6  # File descriptor
	move $a1 $sp  # Address of output buffer
	li $a2 5  # Maximum characters to write
	li $v0 15  # Write file
	syscall
	bltz $v0 errorWriteBoard  # Error if return is negative
	addi $sp $sp 5
	
	
	li $s3 0  # Counter for number of pieces played
	li $s4 0  # Top row is row num_rows - 1
	writeBoardRowLoop:
		bge $s4 $s2 writeComplete  # If the current row is less than zero, the board is displayed
		li $s5 0  # Current column
		writeBoardColLoop:
			bge $s5 $s2 writeBoardNextRow  # If current column is equal or greater than the num_cols, move to next row
			# Load arguments for set_slot
			move $a0 $s0  # Load board array
			move $a1 $s1  # Load num_rows
			move $a2 $s2  # Load num_cols
			move $a3 $s4  # Load current rows
			addi $sp $sp -4
			sw $s5 0($sp)  # Load current col
			jal get_slot
			addi $sp $sp 4
			beq $v0 46 writeBoardIncrCol  # Do nothing if char is '.' 
			
			addi $sp $sp 9
			# Current row
			li $t1 10
			div $s4 $t1  # num_rows divided by 10
			mflo $t0  # Quotient
			addi $t0 $t0 48  # Int to ASCII
			sb $t0 0($sp)
			mfhi $t0
			addi $t0 $t0 48  # Int to ASCII
			sb $t0 1($sp)  # Remainder
			# Current column
			div $s5 $t1  # num_cols divided by 10
			mflo $t0  # Quotient
			addi $t0 $t0 48  # Int to ASCII
			sb $t0 3($sp)
			mfhi $t0
			addi $t0 $t0 48  # Int to ASCII
			sb $t0 4($sp)  # Remainder
			# Character
			sb $v0 5($sp)  # Char 
			# Turn_num
			li $t0 100
			div $v1 $t0  # Turn_num divided by 100
			mflo $t0  # Hundreds value of turn_num
			addi $t0 $t0 48  # Int to ASCII
			sb $t0 6($sp)
			mfhi $t0  # Tens value of turn_num
			div $t0 $t1  # Remainder of turn_num/100 divided by 10
			mflo $t0 
			addi $t0 $t0 48  # Int to ASCII
			sb $t0 7($sp)
			mfhi $t0  # Ones values of turn_num
			addi $t0 $t0 48  # Int to ASCII
			sb $t0 8($sp)
			sb $t1 9($sp)  # New line
			
			# Write to file
			move $a0 $s0  # Address of board array
			move $a1 $sp  # Address of output buffer
			li $a2 9  # Maximum characters to write
			li $v0 15  # Write file
			syscall
			bltz $v0 errorWriteBoard  # Error if return is negative
			addi $sp $sp 9
			
			writeBoardIncrCol:
			addi $s5 $s5 1  # Increment columns
			j writeBoardColLoop
		writeBoardNextRow:
		addi $s4 $s4 -1  # Decrement rows
		j writeBoardRowLoop
	
	
	writeComplete:
		j returnWriteBoard
	
	errorWriteBoard:
	li $v0 -1
	
	returnWriteBoard:
    # Return s registers to their original values
    lw $ra 0($sp)
	lw $s0 4($sp)
	lw $s1 8($sp)
	lw $s2 12($sp)
	lw $s3 16($sp)
	lw $s4 20($sp)
	lw $s5 24($sp)
	lw $s6 28($sp)
	addi $sp $sp 32
    jr $ra

validate_board:
    # Define your code here
    ###########################################
    # DELETE THIS CODE.
    li $v0, -200
    ##########################################
    jr $ra

##############################
# Part III FUNCTIONS
##############################

# a0 = board array; $a1 = num_rows; $a2 = num_cols
# Return 0 for success, -1 otherwise
display_board:
    # Save return address and s registers
	addi $sp $sp -28
	sw $ra 0($sp)
	sw $s0 4($sp)
	sw $s1 8($sp)
	sw $s2 12($sp)
	sw $s3 16($sp)
	sw $s4 20($sp)
	sw $s5 24($sp)
	# Move arguments into s registers
	move $s0 $a0
	move $s1 $a1 
	move $s2 $a2  
	
	# Error checks
	li $v0 -1
	
	# num_rows is less than 0
	bltz $s1 returnDisplayBoard
	
	# num_cols is less than 0
	bltz $s2 returnDisplayBoard
	
	# No errors detected
	addi $s4 $s1 -1  # Top row is row num_rows - 1
	displayBoardRowLoop:
		bltz $s4 boardDisplayed  # If the current row is less than zero, the board is displayed
		li $s5 0  # Current column
		displayBoardColLoop:
			bge $s5 $s2 displayBoardNextRow  # If current column is equal or greater than the num_cols, move to next row
			# Load arguments for set_slot
			move $a0 $s0  # Load board array
			move $a1 $s1  # Load num_rows
			move $a2 $s2  # Load num_cols
			move $a3 $s4  # Load current rows
			addi $sp $sp -4
			sw $s5 0($sp)  # Load current col
			jal get_slot
			addi $sp $sp 4
			move $a0 $v0  # Move char to $a0
			li $v0 11  # Print character
			syscall
			addi $s5 $s5 1  # Increment columns
			j displayBoardColLoop
		displayBoardNextRow:
		addi $s4 $s4 -1  # Decrement rows
		li $a0 10  # New line character
		li $v0 11  # Print character
		syscall
		j displayBoardRowLoop
	
	boardDisplayed:
	li $v0 0
	
	returnDisplayBoard:
    # Return s registers to their original values
    lw $ra 0($sp)
	lw $s0 4($sp)
	lw $s1 8($sp)
	lw $s2 12($sp)
	lw $s3 16($sp)
	lw $s4 20($sp)
	lw $s5 24($sp)
	addi $sp $sp 28
    jr $ra

drop_piece:
    # Define your code here
    ###########################################
    # DELETE THIS CODE.
    li $v0, -200
    ##########################################
    jr $ra

undo_piece:
    # Define your code here
    ###########################################
    # DELETE THIS CODE.
    li $v0, -200
    li $v1, -200
    ##########################################
    jr $ra

check_winner:
    # Define your code here
    ###########################################
    # DELETE THIS CODE.
    li $v0, -200
    ##########################################
    jr $ra

##############################
# EXTRA CREDIT FUNCTION
##############################


check_diagonal_winner:
    # Define your code here
    ###########################################
    # DELETE THIS CODE.
    li $v0, -200
    ##########################################
    jr $ra



##############################################################
# DO NOT DECLARE A .DATA SECTION IN YOUR HW. IT IS NOT NEEDED
##############################################################
