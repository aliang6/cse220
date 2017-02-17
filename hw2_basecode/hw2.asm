
##############################################################
# Homework #2
# name: Andy Liang
# sbuid: 111008856
##############################################################
.text

##############################
# PART 1 FUNCTIONS
##############################

char2digit:
	# If the provided character is greater than the ASCII 9 or less than the ASCII 0, branch to outOfBounds
	bgt $a0 57 outOfBoundsC2D
	blt $a0 48 outOfBoundsC2D
	
	# Tests passed
	addi $a0 $a0 -48  # Convert ASCII to decimal
	move $v0 $a0  # Load decimal to return register.
	j returnChar2Digit
	
	outOfBoundsC2D:
	li $v0 -1

	returnChar2Digit:
	jr $ra

memchar2digit:
	addi $sp $sp -4  # Create space in the stack
	sw $ra 0($sp)  # Store the return address in the stack
    lb $a0 0($a0)  # Overwrite the argument register that holds the address to the first byte of the address
   	jal char2digit  # Jump and link to the char2digit function
	lw $ra 0($sp)  # Reload return address from the stack
	addi $sp $sp 4  # Return stack to normal size
    jr $ra	

fromExcessk:
	# Error if either $a0 or $a1 are less than or equal to 0
	ble $a0 0 outOfBoundsEk
	ble $a1 0 outOfBoundsEk
	sub $t0 $a0 $a1 	# Convert excess k to decimal
	li $v0 0
	move $v1 $t0
	j returnFromExcessk
	
	outOfBoundsEk:
		li $v0 -1
		move $v1 $a0
	
	returnFromExcessk:
    jr $ra

printNbitBinary:  # $a0 = value; $a1 = m
	li $v0 -1
    bgt $a1 32 returnNBit  # Error test
    blt $a1 1 returnNBit  # Error test
	li $t0 32
	sub $t0 $t0 $a1  # 32 - m
    sllv $t0 $a0 $t0  # Shift value left 32 - m bits and put it in $t1 register
    li $v0 1
    whileNBit:
    	ble $a1 0 printSuccessful  # If m is less than or equal to 0, escape loop
    	li $a0 1
    	blt $t0 0 printBit  # If value is less than 0, print 1, else print 0
    	li $a0 0
    	printBit:
    	syscall
    	sll $t0 $t0 1  # Shift value left once
    	addi $a1 $a1 -1  # m = m - 1
    	j whileNBit
    
    printSuccessful:
    li $v0 0
    	
    returnNBit:
    jr $ra

##############################
# PART 2 FUNCTIONS
##############################

btof:
    #Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	li $v0, -200
	li $v1, -200
	############################################
    jr $ra

print_parts:
    #Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	li $v0, -200
	############################################
    jr $ra

print_binary_product:
    #Define your code here
	############################################
	# DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
	li $v0, -200
	############################################
    jr $ra



#################################################################
# Student defined data section
#################################################################
.data
.align 2  # Align next items to word boundary

#place all data declarations here


