##############################################################
# Homework #4
# name: Andy Liang
# sbuid: 111008856
##############################################################

##############################################################
# DO NOT DECLARE A .DATA SECTION IN YOUR HW. IT IS NOT NEEDED
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
	addi $t3 $a1 -1  # num_rows - 1
	bgt $a3 $t3 setSlotReturn
	
	# col is outside the range [0, num_cols - 1]
	bltz $t0 setSlotReturn
	addi $t3 $a2 -1  # num_rows - 1
	bgt $t0 $t3 setSlotReturn
	
	# c is not character 'R', 'Y', or '.'
	beq $t1 82 cIsValid  # If equal to 'R'
	beq $t1 89 cIsValid  # If equal to 'Y'
	beq $t1 46 cIsValid  # If equal to '.'
	j setSlotReturn  # Error if not equal to 'R', 'Y', or '.'
	
	cIsValid:
	# turn_num is outside the range [0, 255]
	bltz $t2 setSlotReturn
	bgt $t2 255 setSlotReturn
	
	# No errors

    # obj_arr[i][j] = base_address + (row_size * i) + (size_of(obj) * j)
    # row_size = num_cols * size_of(obj)
    li $t3 2  # Size of Object
	mul $t4 $a2 $t3 # row_size = num_cols * object_size
    mul $t4 $t4 $a3  # row_size * i
    mul $t5 $t0 $t3  # object_size * j
    add $t4 $t4 $t5  # (row_size * i) + (size_of(obj) * j)
    add $t4 $t0 $t4  # obj_arr[i][j]
    sb $t1 0($t4)  # Store character in obj_arr[i][j] in upper byte
    sb $t2 1($t4)  # Store turn_num in lower byte 
	
	# Set Slot Successful
    li $v0 0
    
    setSlotReturn:
    jr $ra


get_slot:
    # Define your code here
    ###########################################
    # DELETE THIS CODE.
    li $v0, -200
    li $v1, -200
    ##########################################
    jr $ra

clear_board:
	# Save s registers
	addi $sp $sp -24
	sw $s0 0($sp)
	sw $s1 4($sp)
	sw $s2 8($sp)
	sw $s3 12($sp)
	sw $s4 16($sp)
	sw $s5 20($sp)

    # Return s registers to their original values
	lw $s0 0($sp)
	lw $s1 4($sp)
	lw $s2 8($sp)
	lw $s3 12($sp)
	lw $s4 16($sp)
	lw $s5 20($sp)
	addi $sp $sp 24
    # Define your code here
    ###########################################
    # DELETE THIS CODE.
    li $v0, -200
    ##########################################
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
