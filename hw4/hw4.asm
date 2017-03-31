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
	#addi $t0 $s1 -1  # num_rows - 1
	#addi $t1 $s2 -1  # num_cols - 1 
	#mul $s3 $t0 $t1  # Total number of slots
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

load_board:
    # Define your code here
    ###########################################
    # DELETE THIS CODE.
    li $v0, -200
    li $v1, -200
    ##########################################
    jr $ra

save_board:
    # Define your code here
    ###########################################
    # DELETE THIS CODE.
    li $v0, -200
    ##########################################
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

display_board:
    # Define your code here
    ###########################################
    # DELETE THIS CODE.
    li $v0, -200
    ##########################################
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
