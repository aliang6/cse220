
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
	# Error if $a0 is less than 0 or if $a1 is less than or equal to 0
	blt $a0 0 outOfBoundsEk
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

btof: #a0 = address of input
    # ASCII: 43 = +; 45 = -; 46 = .; 73 = I; n = 110; f = 102; N = 78; a = 97; Upper bound: 110; Lower Bound: 43
    addi $sp $sp -4
    sw $ra 0($sp)  # Save return address
    move $s0 $a0  # Copy input address to $t0
   	
	# Special Cases Check
	lb $t1 0($s0)  # Load first byte of string to $t1
	blt $t1 43 invalidInputbtof	 # Check if less than lower bound
	bgt $t1 110 invalidInputbtof  # Check if above upper bound
	beq $t1 78 nan  # Branch to NaN check
	lb $t1 5($s0) # Load sixth byte of string to $t1
	beq $t1 0 infZero  # Branch to Inf or Zero check if sixth byte is null
	
	# Input Check
	li $t0 1  # Counter starts at 1 since first character was already checked in the special cases check
	li $s1 -1  # Set the position of the decimal to -1 for error checks in conversionbtof	
	inputCheck:
		add $t1 $t0 $s0  # Add counter to address
		lb $t2 0($t1)
		beq $t2 10 conversionbtof  # Branch to conversion if inputs are verified i.e. if new line ASCII is reached
		beq $t2 47 invalidInputbtof  # Invalid input if byte is '/'
		blt $t2 46 invalidInputbtof	 # Check if less than ASCII '.'
		bgt $t2 49 invalidInputbtof  # Check if above ASCII '1'
		bne $t2 46 notDecimal
		move $s1 $t0  # Copy position of decimal point
		notDecimal:
		addi $t0 $t0 1  # Increment counter
		j inputCheck
	
	conversionbtof:
		# Sign Conversion
		beq $s1 -1 invalidInputbtof  # If there exists no decimal in the input, it's invalid
		li $t0 0  # Create counter for conversions
		lb $t1 0($s0)  # Load the first character
		beq $t1 43 posbtof
		beq $t1 45 negbtof
		addi $t0 $t0 -1 # If the first character is not '+' or '-' the counter needs to be decremented to account for the offset
		posbtof:
			li $s7 0
			j intConversion
		negbtof:
			li $s7 1
		
		# Sign has been converted to IEE754
		# Integer Conversion
		intConversion:
		
		# $s0 holds the position of the first digit
		# Step 1: Finding the rightmost 1
		li $s2 -1  # $s2 will hold the position of the rightmost 1
		li $t3 0  # Counter for address
		findRightOne:
			add $t1 $t3 $s0  # Add counter to address
			lb $a0 0($t1)  # Load byte
			beq $a0 10 rightOneNotFound  # No zeroes if byte is equal to new line i.e. ASCII 10
			jal char2digit
			move $t2 $v0
			beq $t2 1 rightOneFound
			addi $t3 $t3 1
			j findRightOne
		
		rightOneNotFound:
		beq $s2 -1 zeroCase  # No zeros were found, so branch to zero case
		
		rightOneFound:
		move $s2 $t3  # Copy position of rightmost one into $s2
		# Subtract decimal position from rightmost one position then substract one to calculate exponent in decimal form
		sub $t0 $s1 $s2   
		addi $t0 $t0 -1  # Exponent in decimal form
		addi $t0 $t0 127  # Exponent in excess-127 form
		sll $s7 $s7 8  # Make make space for exponent
		add $s7 $s7 $t0  # Append exponent
		
		# At this point, the floating point stored in $s6 should have the sign bit and the exponent in excess-127
		li $t0 0  # Counter for mantissa limit
		move $t1 $s2  # Position counter
		addi $t1 $t1 1  # Position is now one after rightmost one
		mantissa:
			beq $t1 $s1 decimalSkip  # If the current position is equal to decimal position, skip one loop
			bge $t0 23 inputMantissaAdded  # If the mantissa limit has been reached
			add $t2 $t1 $s0  # Add position counter to address
			lb $a0 0($t2)  # Load byte
			beq $a0 10 inputMantissaAdded  # If the byte is a new line
			jal char2digit  # Convert byte to digit
			move $t2 $v0  # Copy return value
			sll $s7 $s7 1  # Create space in the float
			add $s7 $s7 $t2  # Add return value to the float
			addi $t0 $t0 1  # Increment mantissa limit counter
			decimalSkip:
			addi $t1 $t1 1  # Increment position counter
			j mantissa
	
		inputMantissaAdded:
		beq $t0 23 floatCreated  # If the mantissa limit has been reached, the float has been created
		li $t3 23
		sub $t0 $t3 $t0  # Figure out how many more spaces are left
		sllv $s7 $s7 $t0  # Shift by the amount of spaces left
		
		floatCreated:
		j setReturnbtof
		
	nan:
		lb $t1 4($t0)
		bnez $t1 invalidInputbtof  # Invalid input if fifth character is not null, fourth being new line
		lb $t1 1($t0)
		bne $t1 97 invalidInputbtof  # Invalid input if second character is not 'a'
		lb $t1 2($t0)
		bne $t1 78 invalidInputbtof  # Invalid input if third character is not 'N'
		li $v0 0
		li $v1 01111111111111111111111111111111
		j returnbtof
		
	infZero:
		lb $t1 2($s0)  # Load the third byte of the string
		beq $t1 46 zeroCase  # Branch to zero case if third byte is '.'
		beq $t1 110 inf  # Branch to inf if third byte is 'n'
		j inputCheck
	
	inf:
		lb $t1 1($s0)
		bne $t1 73 invalidInputbtof  # Invalid input if third character is not 'I'
		lb $t1 3($s0)
		bne $t1 102 invalidInputbtof  # Invalid input if fourth character is not 'f'
		lb $t1 0($s0) 
		beq $t1 43 posInf  # If first character is '+', branch to posInf
		beq $t1 45 negInf  # If first character is '-', branch to negInf
		j invalidInputbtof # Invalid input if the first character isn't '+' or '-'
		
		posInf:
			li $v0 0
			li $v1 01111111100000000000000000000000
			j returnbtof
		negInf:
			li $v0 0
			li $v1 11111111100000000000000000000000
			j returnbtof
			
	zeroCase:
		lb $t1 1($s0)  # Load second character into $t1
		move $a0 $t1  # Load argument
		jal char2digit  # Call char2digit function
		move $t1 $v0  # Copy return value to $t1
		bnez $t1 inputCheck  # Branch to input check if not zero because input cannot be confirmed as invalid yet
		lb $t1 3($s0)  # Load third character into $t1
		move $a0 $t1  # Load argument
		jal char2digit  # Call char2digit function
		move $t1 $v0  # Copy return value to $t1
		bnez $t1 inputCheck  # Branch to input check if not zero because input cannot be confirmed as invalid yet
		lb $t1 0($s0)
		beq $t1 43 posZero  # If first character is '+', branch to posZero
		beq $t1 45 negZero  # If first character is '-', branch to negZero
		j invalidInputbtof
		
		posZero:
			li $v0 0
			li $v1 0
			sll $v1 $v1 31
			j returnbtof
		negZero:
			li $v0 0
			li $v1 1
			sll $v1 $v1 31
			j returnbtof
		

	invalidInputbtof:
	li $v0 -1
	li $v1 -1
	j returnbtof
	
	setReturnbtof:
	li $v0 0
	move $v1 $s7
	
	returnbtof:
	lw $ra 0($sp)
	addi $sp $sp 4
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

