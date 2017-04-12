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
    sb $t1 1($t4)  # Store character in obj_arr[i][j] in upper byte
    sb $t2 0($t4)  # Store turn_num in lower byte 
	
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
    lb $v0 1($t4)  # Load upper byte
    lbu $v1 0($t4)  # Load lower byte
    
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
	addi $sp $sp -12  # 9 bytes for line including newline
	bltz $v0 errorLoadBoard  # Negative means file error
	
	# Read file
	
	# First line
	move $a0 $s2  # File descriptor
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
	li $v0 16
	syscall
	move $v0 $s3  # num_rows
	move $v1 $s4  # num_cols
	j returnLoadBoard
	
	errorLoadBoard:
	li $v0 -1
	li $v1 -1
	
	returnLoadBoard:
	addi $sp $sp 12
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
	addi $sp $sp -28
	sw $ra 0($sp)
	sw $s0 4($sp)
	sw $s1 8($sp)
	sw $s2 12($sp)
	sw $s3 16($sp)
	sw $s4 20($sp)
	sw $s5 24($sp)
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
	sb $t0 2($sp)
	mfhi $t0
	addi $t0 $t0 48  # Int to ASCII
	sb $t0 3($sp)  # Remainder
	sb $t1 4($sp)  # New line
	
	move $a0 $s6  # File descriptor
	move $a1 $sp  # Address of output buffer
	li $a2 5  # Maximum characters to write
	li $v0 15  # Write file
	syscall
	addi $sp $sp 5
	bltz $v0 errorWriteBoard  # Error if return is negative

	
	li $s3 0  # Counter for number of pieces played
	li $s4 0  # Top row is row num_rows - 1
	writeBoardRowLoop:
		bge $s4 $s1 writeComplete  # If the current row is equal or greater than num_rows, the board is displayed
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
			addi $s3 $s3 1 # Else increment pieces counter and write to file
			addi $sp $sp -9
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
			sb $t0 2($sp)
			mfhi $t0
			addi $t0 $t0 48  # Int to ASCII
			sb $t0 3($sp)  # Remainder
			# Character
			sb $v0 4($sp)  # Char 
			# Turn_num
			li $t0 100
			div $v1 $t0  # Turn_num divided by 100
			mflo $t0  # Hundreds value of turn_num
			addi $t0 $t0 48  # Int to ASCII
			sb $t0 5($sp)
			mfhi $t0  # Tens value of turn_num
			div $t0 $t1  # Remainder of turn_num/100 divided by 10
			mflo $t0 
			addi $t0 $t0 48  # Int to ASCII
			sb $t0 6($sp)
			mfhi $t0  # Ones values of turn_num
			addi $t0 $t0 48  # Int to ASCII
			sb $t0 7($sp)
			sb $t1 8($sp)  # New line
			
			# Write to file
			move $a0 $s6  # File descriptor
			move $a1 $sp  # Address of output buffer
			li $a2 9  # Maximum characters to write
			li $v0 15  # Write file
			syscall
			addi $sp $sp 9
			bltz $v0 errorWriteBoard  # Error if return is negative
			
			writeBoardIncrCol:
			addi $s5 $s5 1  # Increment columns
			j writeBoardColLoop
		writeBoardNextRow:
		addi $s4 $s4 1  # Increment rows
		j writeBoardRowLoop
	
	
	writeComplete:
		li $v0 16
		syscall
		move $v0 $s3 
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
	addi $sp $sp 28
    jr $ra

# $a0 = board array; $a1 = num_rows; $a2 = num_cols
# return: byte vector
validate_board:
    # Save return address and s registers
	addi $sp $sp -28
	sw $ra 0($sp)
	sw $s0 4($sp)
	sw $s1 8($sp)
	sw $s2 12($sp)
	sw $s3 16($sp)
	sw $s4 20($sp)
	sw $s5 24($sp)
	# Preserve board array through function calls
	move $s0 $a0
	li $s1 0  # Will contain the byte vector
	move $s2 $a1  # Copy num_rows
	move $s3 $a2  # Copy num_cols
	
	li $t0 4
	# Bit 0: num_rows < 4
	bge $a1 $t0 bitZeroDone
	addi $s1 $s1 1  # else bit zero is 1
	bitZeroDone:
	# Bit 1: num_cols < 4
	bge $a2 $t0 bitOneDone
	addi $s1 $s1 2  # else bit one is 1
	bitOneDone:
	# Bit 2: num_rows * num_cols > 255
	mul $t0 $a1 $a2
	li $t1 255
	ble $t0 $t1 bitTwoDone
	addi $s1 $s1 4  # else bit two is 1
	bitTwoDone:
	
	li $s6 0  # Difference of pieces on board
	li $s4 0  # Column and row of most recent piece in the form col*100 + row
	addi $sp $sp -4  # Increment stack pointer
	li $t0 0
	sw $t0 0($sp)  # Highest turn number
	# $s6 is num_rows
	
	addi $s5 $s3 -1  # Rightmost col is col num_col - 1
	valBoardColLoop:
		
		bltz $s5 boardTravOne  # If the current col is less than zero, the board has been traversed
		addi $s7 $s2 -1 # Top row is row num_row - 1
		valBoardRowLoop:
			bltz $s7 valBoardNextCol  # If current row is less than one, move to next column
			# Load arguments for get_slot
			move $a0 $s0  # Load board array
			move $a1 $s2  # Load num_rows
			move $a2 $s3  # Load num_cols
			move $a3 $s7  # Load current row
			addi $sp $sp -4
			sw $s5 0($sp)  # Load current col
			jal get_slot  
			addi $sp $sp 4  
			
			beq $v0 46 notGamePiece  # If char is "."
			bne $v0 82 notRed
			addi $s6 $s6 1  # Increment piece counter
			j pieceCounterIncremented
			notRed:
			addi $s6 $s6 -1  # Decrement piece counter
			
			pieceCounterIncremented:
			lw $t0 0($sp)  # Load highest turn number
			ble $v1 $t0 notHighestTurn  # If turn_num is less than or equal to the current highest turn_num, it's not the highest
			sw $v1 0($sp)  # else it is
			li $t1 100
			move $s4 $s5  # Reset column row value
			mul $s4 $s4 $t1  # Multiply column of most recent piece by 100
			add $s4 $s4 $s7  # Column * 100 + row
			notHighestTurn:
			notGamePiece:
			
			addi $s7 $s7 -1  # Decrement rows
			j valBoardRowLoop
		valBoardNextCol:
		addi $s5 $s5 -1  # Decrement cols
		j valBoardColLoop
		
	boardTravOne:
	# Bit 3 check
	li $t1 -1
	blt $s6 $t1 bitThreeAdd  # If difference is less than -1
	li $t1 1
	bgt $s6 $t1 bitThreeAdd  # If difference is greater than 1
	j bitThreeDone
	
	bitThreeAdd:
	addi $s1 $s1 8  # bit three is 1
	
	bitThreeDone:
	lw $s5 0($sp)  # Contains highest turn_num
	addi $sp $sp 4
	blez $s5 boardValidated  # If the highest turn_num is less than or equal to zero, then there are no pieces 
							 # on the board and the byte vector can be returned
	
	# Get the char value of the piece with the highest turn num
	# Will use it to figure out whether that piece's turn_num % 2 is equal to 1 or 0
	move $a0 $s0  # Load board array
	move $a1 $s2  # Load num_rows
	move $a2 $s3  # Load num_cols
	li $t0 100
	div $s4 $t0  # Quotient = column; Remainder = row
	mfhi $a3
	addi $sp $sp -4
	mflo $t0  
	sw $t0 0($sp)  # Load current col
	jal get_slot  
	addi $sp $sp 4  
	
	# $s0 = board array; $s1 = byte vector; $s2 = num_rows; $s3 = num_cols; $s5 = highest turn_num
	# $s4 will contain the value of an Y piece's turn_num modded by 2
	li $t0 2
	bne $v0 82 notRPiece # If the character is not "R", then it must be "Y"
	div $v1 $t0
	mfhi $s4 
	j modTwoCheck
	notRPiece:
	addi $v1 $v1 1 
	div $v1 $t0 
	mfhi $s4
	modTwoCheck:
	
	addi $sp $sp -256  # Space to create a turn counter for every turn
	addi $sp $sp -16  # Space for counters and boolean checks
	li $t0 256
	sw $t0 256($sp)  # Lowest turn_num in a column
	sw $0 260($sp)  # Boolean check for lower turn piece above higher turn
	sw $0 264($sp)  # Boolean check for empty slot below piece
	sw $0 268($sp)  # Boolean check for red and yellow alternating turns
	
	addi $s6 $s3 -1  # Rightmost col is col num_col - 1
	valBoardTwoColLoop:
		
		bltz $s6 boardTravTwo  # If the current col is less than zero, the board has been traversed
		addi $s7 $s2 -1 # Top row is row num_row - 1
		li $t0 256
		sw $t0 256($sp)
		valBoardTwoRowLoop:
			bltz $s7 valBoardTwoNextCol  # If current row is less than one, move to next column
			# Load arguments for get_slot
			move $a0 $s0  # Load board array
			move $a1 $s2  # Load num_rows
			move $a2 $s3  # Load num_cols
			move $a3 $s7  # Load current row
			addi $sp $sp -4
			sw $s6 0($sp)  # Load current col
			jal get_slot  
			addi $sp $sp 4  
			
			
			beq $v0 46 notGamePieceTwo  # If char is "."
			
			# Illegal Piece Check
			lw $t0 256($sp)
			blt $v1 $t0 legalPiece
			li $t0 1
			sw $t0 260($sp)  # Else test failed
			legalPiece:
			sw $v1 256($sp)  # Update lowest turn_num in column
			
			# Increment turn counter
			#addi $t0 $v1 1
			add $t0 $v1 $sp  # Turn_num address
			lb $t1 0($t0)  # Load value at that address
			addi $t1 $t1 1  # Increment value
			sb $t1 0($t0)  # Store new value
			
			# Alternating pieces check
			li $t0 2
			div $v1 $t0
			mfhi $t0 # Contains piece turn_num modded by two
			bne $v0 82 notRedTwo  # If not red piece, then yellow piece
			beq $t0 $s4 modTwoChecked  # If yellow piece equals, then it passes the test
			li $t0 1  
			sw $t0 268($sp)  # Else it fails
			j modTwoChecked
			notRedTwo:
			bne $t0 $s4 modTwoChecked  # If red piece doesn't equal, then it passes the test
			li $t0 1
			sw $t0 268($sp)  # Else it fails
			modTwoChecked:
			j legalSlot
			
			notGamePieceTwo:
			
			# Illegal slot check
			lw $t0 256($sp)
			beq $t0 256 legalSlot
			li $t0 1
			sw $t0 264($sp)  # Else test failed
			legalSlot:
			
			addi $s7 $s7 -1  # Decrement rows
			j valBoardTwoRowLoop
		valBoardTwoNextCol:
		addi $s6 $s6 -1  # Decrement cols
		j valBoardTwoColLoop
	boardTravTwo:
	
	# Bit 4 check
	lb $t0 268($sp)
	beq $t0 0 bitFourLoop
	addi $s1 $s1 16  # Else bit four is 1
	move $t1 $s5  # Copy max turn_num found
	j bitFourDone
	bitFourLoop:
		ble $t1 4 bitFourDone
		add $t0 $sp $t1
		lb $t0 0($t0)
		bne $t0 0 turnNumExists  # If there's only one piece with the specified turn then it passes the test
		addi $s1 $s1 16  # Else it fails and bit seven is 1
		j bitFourDone
		turnNumExists:
		addi $t1 $t1 -1  # Decrement counter
		j bitFourLoop
	bitFourDone:
	
	# Bit 5 check
	lw $t0 264($sp)
	beq $t0 0 bitFiveDone
	addi $s1 $s1 32  # Else bit five is 1
	bitFiveDone:
	
	# Bit 6 check
	lw $t0 260($sp)
	beq $t0 0 bitSixDone
	addi $s1 $s1 64  # Else bit six is 1
	bitSixDone:
	
	# Bit 7 check
	# $s5 is the counter
	lb $t0 1($sp)  # Load counter for number of pieces with turn 1
	bnez $t0 bitSevenLoop  # If the counter isn't equal to zero, proceed to loop
	addi $s1 $s1 128  # Else bit seven is 1
	j bitSevenDone
	bitSevenLoop:
		blez $s5 bitSevenDone
		add $t0 $sp $s5
		lb $t0 0($t0)
		blt $t0 2 turnNumPassed  # If there's only one piece with the specified turn then it passes the test
		addi $s1 $s1 128  # Else it fails and bit seven is 1
		j bitSevenDone
		turnNumPassed:
		addi $s5 $s5 -1  # Decrement counter
		j bitSevenLoop
	
	bitSevenDone:
	
	addi $sp $sp 16
	addi $sp $sp 256
	
	boardValidated:
	move $v0 $s1

	lw $ra 0($sp)
	lw $s0 4($sp)
	lw $s1 8($sp)
	lw $s2 12($sp)
	lw $s3 16($sp)
	lw $s4 20($sp)
	lw $s5 24($sp)
	addi $sp $sp -28
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
			# Load arguments for get_slot
			move $a0 $s0  # Load board array
			move $a1 $s1  # Load num_rows
			move $a2 $s2  # Load num_cols
			move $a3 $s4  # Load current row
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

# $a0 = board; $a1 = num_rows; $a2 = num_cols; $a3 = col; $a4 = char; $a5 = turn_num
# Return 0 for success, -1 otherwise
drop_piece:
	lw $t0 0($sp)  # char
	lw $t1 4($sp)  # turn_num
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
	move $s0 $a0  # board array
	move $s1 $a1  # num_rows
	move $s2 $a2  # num_cols
	move $s3 $a3  # col
	move $s4 $t0  # char
	move $s5 $t1  # turn_num
	li $s6 0  # Current row in col $a3
	
	# Error checks
	blez $s1 errorDropPiece  # num_rows < 0
	blez $s2 errorDropPiece  # num_cols < 0
	blez $s3 errorDropPiece  # cols < 0
	bge $s3 $s2 errorDropPiece # cols >= num_cols
	bgt $s5 255 errorDropPiece  # turn_num > 255
	beq $s4 82 columnCheck  # char is "R"
	beq $s4 89 columnCheck  # char is "Y"
	j errorDropPiece
	
	columnCheck:
		bge $s6 $s1 errorDropPiece  # If col = num_cols, there is no available space
		move $a0 $s0  # Load board array
		move $a1 $s1  # Load num_rows
		move $a2 $s2  # Load num_cols
		move $a3 $s6  # Load current row
		addi $sp $sp -4
		sw $s3 0($sp)  # Load current col
		jal get_slot
		addi $sp $sp 4
		bne $v0 46 spaceOccupied  # If char is "."
		move $a0 $s0  # Load board array
		move $a1 $s1  # Load num_rows
		move $a2 $s2  # Load num_cols
		move $a3 $s6  # Load current row
		addi $sp $sp -12
		sw $s3 0($sp)  # Load current col
		sw $s4 4($sp)  # Load char
		sw $s5 8($sp)  # Load turn_num
		jal set_slot
		addi $sp $sp 12
		j successDropPiece
		spaceOccupied:
		addi $s6 $s6 1  # Increment current row
		j columnCheck
	
	successDropPiece:
	li $v0 0
	j returnDropPiece
	
	errorDropPiece:
	li $v0 -1
	
	returnDropPiece:
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

undo_piece:
    addi $sp $sp -36
	sw $ra 0($sp)
	sw $s0 4($sp)
	sw $s1 8($sp)
	sw $s2 12($sp)
	sw $s3 16($sp)
	sw $s4 20($sp)
	sw $s5 24($sp)
	sw $s6 28($sp)
	sw $s7 32($sp)
    move $s0 $a0  # board array
    move $s1 $a1  # num_rows
    move $s2 $a2  # num_cols
    li $s3 0  # Row of most recent piece
    li $s4 0  # Column of most recent piece
    li $s5 0  # Turn_num of most recent piece
    addi $sp $sp -4
    
    # Error checks
    bltz $s1 errorUndoPiece  # num_rows < 0
    bltz $s2 errorUndoPiece  # num_cols < 0
    
    li $s6 0  # Current column
	undoPieceRowLoop:
		bge $s6 $s2 undoPieceFound  # If the current col >= num_col, the most recent piece has been found
		addi $s7 $s1 -1  # Current row
		undoPieceColLoop:
			bltz $s7 undoPieceNextRow  # If current row is less than or equal to zero, move to next row
			# Load arguments for get_slot
			move $a0 $s0  # Load board array
			move $a1 $s1  # Load num_rows
			move $a2 $s2  # Load num_cols
			move $a3 $s7  # Load current row
			addi $sp $sp -4
			sw $s6 0($sp)  # Load current col
			jal get_slot
			addi $sp $sp 4
			beq $v0 46 pieceNotFound  # If char is "."
			ble $v1 $s5 notMostRecent  # If piece's turn is less than the highest turn_num found before this point
			move $s3 $s7  # Update most recent piece row
			move $s4 $s6  # Update most recent piece column
			move $s5 $v1  # Update most recent piece turn_num
			sw $v0 0($sp)  # Update most recent piece char
			notMostRecent:
			j undoPieceNextRow  # Increment row; topmost column piece found, 
			pieceNotFound:
			addi $s7 $s7 -1  # Decrement current row
			j undoPieceColLoop
		undoPieceNextRow:
		addi $s6 $s6 1 # Increment current column
		j undoPieceRowLoop
    
    undoPieceFound:
    # Save char
    lw $s6 0($sp)  # Char of most recent piece
    addi $sp $sp 4
    beqz $s5 errorUndoPiece  # If turn_num of most recent piece is zero

    # Undo most recent piece
    move $a0 $s0  # Board array
    move $a1 $s1  # num_rows
    move $a2 $s2  # num_cols
    move $a3 $s3  # Row of most recent piece
    addi $sp $sp -12
    sw $s4 0($sp)  # Column of most recent piece
    li $t0 46  
    sw $t0 4($sp)  # Char "."
    sw $0 8($sp)  # turn_num
    jal set_slot
    addi $sp $sp 12
    
    beq $v0 -1 errorUndoPiece
    move $v0 $s6  # Char of most recent piece
    move $v1 $s5  # Turn_num of most recent piece
    j returnUndoPiece
    
    errorUndoPiece:
    li $v0 46
    li $v1 -1 
    
    returnUndoPiece:
	lw $ra 0($sp)
	lw $s0 4($sp)
	lw $s1 8($sp)
	lw $s2 12($sp)
	lw $s3 16($sp)
	lw $s4 20($sp)
	lw $s5 24($sp)
	lw $s6 28($sp)
	lw $s7 32($sp)
	addi $sp $sp 36
    jr $ra

check_winner:
	# Preserve return address and s registers
	addi $sp $sp -36
	sw $ra 0($sp)
	sw $s0 4($sp)
	sw $s1 8($sp)
	sw $s2 12($sp)
	sw $s3 16($sp)
	sw $s4 20($sp)
	sw $s5 24($sp)
	sw $s6 28($sp)
	sw $s7 32($sp)
	# Preserve arguments
	move $s0 $a0  # Board array
	move $s1 $a1  # num_rows
	move $s2 $a2  # num_cols
	
	# Checking for horizontal winner
	li $s3 0  # Current row
	li $s4 0  # Current column
	addi $s5 $s4 3  # Current column + 3; represents other end of horizontal winner
	li $s6 0  # Char 
	
	hWinnerRowLoop:
		bge $s3 $s1 hSearchCompleted  # If current row >= num_rows search complete
		li $s4 0  # Current column
		addi $s5 $s4 3  # Current column + 3
		hWinnerColLoop:
			bge $s5 $s2 hWinnerNextRow  # If the other end of horizontal winner is equal to num_cols, move to next row
			# Get_slot of current column
			move $a0 $s0  # Load board array
			move $a1 $s1  # Load num_rows
			move $a2 $s2  # Load num_cols
			move $a3 $s3  # Load current row
			addi $sp $sp -4
			sw $s4 0($sp)  # Load current col
			jal get_slot
			addi $sp $sp 4
			beq $v0 46 hWinnerNextCol  # If the character is ".", next column
			move $s6 $v0  # Move char to $s6
			
			# Get_slot of current column + 3
			move $a0 $s0  # Load board array
			move $a1 $s1  # Load num_rows
			move $a2 $s2  # Load num_cols
			move $a3 $s3  # Load current row
			addi $sp $sp -4
			sw $s5 0($sp)  # Load current col + 3
			jal get_slot
			addi $sp $sp 4
			bne $s6 $v0 hWinnerNextCol  # If the char doesn't match, next column
			
			# Get_slot of current column + 1
			move $a0 $s0  # Load board array
			move $a1 $s1  # Load num_rows
			move $a2 $s2  # Load num_cols
			move $a3 $s3  # Load current row
			addi $sp $sp -4
			addi $t0 $s4 1
			sw $t0 0($sp)  # Load current col + 1
			jal get_slot
			addi $sp $sp 4
			bne $s6 $v0 hWinnerNextCol  # If the char doesn't match, next column
			
			# Get_slot of current column + 2
			move $a0 $s0  # Load board array
			move $a1 $s1  # Load num_rows
			move $a2 $s2  # Load num_cols
			move $a3 $s3  # Load current row
			addi $sp $sp -4
			addi $t0 $s4 2
			sw $t0 0($sp)  # Load current col + 2
			jal get_slot
			addi $sp $sp 4
			bne $s6 $v0 hWinnerNextCol  # If the char doesn't match, next column
			
			# Else, winner found
			# $v0 already contains the character
			j returnCheckWinner
			
			hWinnerNextCol:
			addi $s4 $s4 1  # Increment current column
			addi $s5 $s5 1  # Increment current column + 3
			j hWinnerColLoop
		hWinnerNextRow:
		addi $s3 $s3 1  # Increment rows
		j hWinnerRowLoop
	
	hSearchCompleted:
	
	# Checking for vertical winner
	li $s3 0  # Current row
	li $s4 0  # Current column
	addi $s5 $s3 3  # Current row + 3; represents other end of vertical winner
	li $s6 0  # Char 
	
	vWinnerColLoop:
		bge $s4 $s2 noWinner  # If current col >= num_cols, there are currently no winner
		li $s3 0  # Current row
		addi $s5 $s3 3  # Current row + 3
		vWinnerRowLoop:
			bge $s5 $s1 vWinnerNextCol  # If the other end of vertical winner >= num_rows, move to next column
			# Get_slot of current row
			move $a0 $s0  # Load board array
			move $a1 $s1  # Load num_rows
			move $a2 $s2  # Load num_cols
			move $a3 $s3  # Load current row
			addi $sp $sp -4
			sw $s4 0($sp)  # Load current col
			jal get_slot
			addi $sp $sp 4
			beq $v0 46 vWinnerNextRow  # If the character is ".", next row
			move $s6 $v0  # Move char to $s6
			
			# Get_slot of current row + 3
			move $a0 $s0  # Load board array
			move $a1 $s1  # Load num_rows
			move $a2 $s2  # Load num_cols
			move $a3 $s5  # Load current row + 3
			addi $sp $sp -4
			sw $s4 0($sp)  # Load current column
			jal get_slot
			addi $sp $sp 4
			bne $s6 $v0 vWinnerNextRow  # If the char doesn't match, next row
			
			# Get_slot of current row + 1
			move $a0 $s0  # Load board array
			move $a1 $s1  # Load num_rows
			move $a2 $s2  # Load num_cols
			addi $a3 $s3 1  # Load current row + 1
			addi $sp $sp -4
			sw $s4 0($sp)  # Load current col
			jal get_slot
			addi $sp $sp 4
			bne $s6 $v0 vWinnerNextRow  # If the char doesn't match, next row
			
			# Get_slot of current row + 2
			move $a0 $s0  # Load board array
			move $a1 $s1  # Load num_rows
			move $a2 $s2  # Load num_cols
			addi $a3 $s3 2  # Load current row + 2
			addi $sp $sp -4
			sw $s4 0($sp)  # Load current col
			jal get_slot
			addi $sp $sp 4
			bne $s6 $v0 vWinnerNextRow  # If the char doesn't match, next row
			
			# Else, winner found
			# $v0 already contains the character
			j returnCheckWinner
			
			vWinnerNextRow:
			addi $s3 $s3 1  # Increment current row
			addi $s5 $s5 1  # Increment current row + 3
			j vWinnerRowLoop
		vWinnerNextCol:
		addi $s4 $s4 1  # Increment current column
		j vWinnerColLoop
	
	noWinner:
	li $v0 46  # Load char "."

    returnCheckWinner:
	lw $ra 0($sp)
	lw $s0 4($sp)
	lw $s1 8($sp)
	lw $s2 12($sp)
	lw $s3 16($sp)
	lw $s4 20($sp)
	lw $s5 24($sp)
	lw $s6 28($sp)
	lw $s7 32($sp)
	addi $sp $sp 36
    jr $ra

##############################
# EXTRA CREDIT FUNCTION
##############################


check_diagonal_winner:
    # Preserve return address and s registers
	addi $sp $sp -36
	sw $ra 0($sp)
	sw $s0 4($sp)
	sw $s1 8($sp)
	sw $s2 12($sp)
	sw $s3 16($sp)
	sw $s4 20($sp)
	sw $s5 24($sp)
	sw $s6 28($sp)
	sw $s7 32($sp)
	# Preserve arguments
	move $s0 $a0  # Board array
	move $s1 $a1  # num_rows
	move $s2 $a2  # num_cols
	
	# Checking for right diagonal winner e.g. bottom left to top right
	li $s3 0  # Current row
	li $s4 0  # Current column
	addi $s5 $s4 3  # Current column + 3; represents the column of the other end of the diagonal
	addi $s7 $s3 3  # Current row + 3; represents the row of the other end of the diagonal
	li $s6 0  # Char 
	
	rdWinnerRowLoop:
		bge $s7 $s1 rdSearchCompleted  # If current row >= num_rows search complete
		li $s4 0  # Current column
		addi $s5 $s4 3  # Current column + 3
		rdWinnerColLoop:
			bge $s5 $s2 rdWinnerNextRow  # If the column of the other end is equal to num_cols, move to next row
			# Get_slot of current column and current row
			move $a0 $s0  # Load board array
			move $a1 $s1  # Load num_rows
			move $a2 $s2  # Load num_cols
			move $a3 $s3  # Load current row
			addi $sp $sp -4
			sw $s4 0($sp)  # Load current col
			jal get_slot
			addi $sp $sp 4
			beq $v0 46 rdWinnerNextCol  # If the character is ".", next column
			move $s6 $v0  # Move char to $s6
			
			# Get_slot of current column + 3 and current row + 3 
			move $a0 $s0  # Load board array
			move $a1 $s1  # Load num_rows
			move $a2 $s2  # Load num_cols
			move $a3 $s7  # Load current row + 3
			addi $sp $sp -4
			sw $s5 0($sp)  # Load current col + 3
			jal get_slot
			addi $sp $sp 4
			bne $s6 $v0 rdWinnerNextCol  # If the char doesn't match, next column
			
			# Get_slot of current column + 1 and current row + 1 
			move $a0 $s0  # Load board array
			move $a1 $s1  # Load num_rows
			move $a2 $s2  # Load num_cols
			addi $a3 $s3 1  # Load current row + 1
			addi $sp $sp -4
			addi $t0 $s4 1
			sw $t0 0($sp)  # Load current col + 1
			jal get_slot
			addi $sp $sp 4
			bne $s6 $v0 rdWinnerNextCol  # If the char doesn't match, next column
			
			# Get_slot of current column + 2 and current row + 2
			move $a0 $s0  # Load board array
			move $a1 $s1  # Load num_rows
			move $a2 $s2  # Load num_cols
			addi $a3 $s3 2  # Load current row + 2
			addi $sp $sp -4
			addi $t0 $s4 2
			sw $t0 0($sp)  # Load current col + 2
			jal get_slot
			addi $sp $sp 4
			bne $s6 $v0 rdWinnerNextCol  # If the char doesn't match, next column
			
			# Else, winner found
			# $v0 already contains the character
			j returnCheckDiagWinner
			
			rdWinnerNextCol:
			addi $s4 $s4 1  # Increment current column
			addi $s5 $s5 1  # Increment current column + 3
			j rdWinnerColLoop
		rdWinnerNextRow:
		addi $s3 $s3 1  # Increment current row
		addi $s7 $s7 1  # Increment current row + 3
		j rdWinnerRowLoop
	
	rdSearchCompleted:
	
	# Checking for left diagonal i.e. top left to bottom right
	addi $s3 $s1 -1  # Current row
	li $s4 0  # Current column
	addi $s5 $s3 -3  # Current row - 3; represents row of other end of diagonal
	addi $s7 $s4 3  # Current column + 3; represents column of other end of diagonal
	li $s6 0  # Char 
	
	ldWinnerColLoop:
		bge $s7 $s2 noDiagWinner  # If current col + 3 >= num_cols, there are currently no winner
		addi $s3 $s1 -1  # Current row
		addi $s5 $s3 -3  # Current row - 3
		ldWinnerRowLoop:
			blez $s5 ldWinnerNextCol  # If the row of the other end of the diagonal <= 0, move to next column
			# Get_slot of current row and current column
			move $a0 $s0  # Load board array
			move $a1 $s1  # Load num_rows
			move $a2 $s2  # Load num_cols
			move $a3 $s3  # Load current row
			addi $sp $sp -4
			sw $s4 0($sp)  # Load current col
			jal get_slot
			addi $sp $sp 4
			beq $v0 46 ldWinnerNextRow  # If the character is ".", next row
			move $s6 $v0  # Move char to $s6
			
			# Get_slot of current row - 3 and current column + 3 
			move $a0 $s0  # Load board array
			move $a1 $s1  # Load num_rows
			move $a2 $s2  # Load num_cols
			move $a3 $s5  # Load current row - 3
			addi $sp $sp -4
			sw $s7 0($sp)  # Load current column + 3
			jal get_slot
			addi $sp $sp 4
			bne $s6 $v0 ldWinnerNextRow  # If the char doesn't match, next row
			
			# Get_slot of current row - 1 and current column + 1
			move $a0 $s0  # Load board array
			move $a1 $s1  # Load num_rows
			move $a2 $s2  # Load num_cols
			addi $a3 $s3 -1  # Load current row - 1
			addi $sp $sp -4
			addi $t0 $s4 1
			sw $t0 0($sp)  # Load current col - 1
			jal get_slot
			addi $sp $sp 4
			bne $s6 $v0 ldWinnerNextRow  # If the char doesn't match, next row
			
			# Get_slot of current row - 2 and current column + 2
			move $a0 $s0  # Load board array
			move $a1 $s1  # Load num_rows
			move $a2 $s2  # Load num_cols
			addi $a3 $s3 -2  # Load current row - 2
			addi $sp $sp -4
			addi $t0 $s4 2 
			sw $t0 0($sp)  # Load current col + 2
			jal get_slot
			addi $sp $sp 4
			bne $s6 $v0 ldWinnerNextRow  # If the char doesn't match, next row
			
			# Else, winner found
			# $v0 already contains the character
			j returnCheckDiagWinner
			
			ldWinnerNextRow:
			addi $s3 $s3 -1  # Decrement current row
			addi $s5 $s5 -1  # Decrement current row + 3
			j ldWinnerRowLoop
		ldWinnerNextCol:
		addi $s4 $s4 1  # Increment current column
		addi $s7 $s7 1  # Increment current column + 3
		j ldWinnerColLoop
	
	noDiagWinner:
	li $v0 46  # Load char "."

    returnCheckDiagWinner:
	lw $ra 0($sp)
	lw $s0 4($sp)
	lw $s1 8($sp)
	lw $s2 12($sp)
	lw $s3 16($sp)
	lw $s4 20($sp)
	lw $s5 24($sp)
	lw $s6 28($sp)
	lw $s7 32($sp)
	addi $sp $sp 36
    jr $ra


