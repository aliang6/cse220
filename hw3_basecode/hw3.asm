##############################################################
# Homework #3
# name: Andy Liang
# sbuid: 111008856
##############################################################
.text

##############################
# FUNCTIONS
##############################

indexOf:  # $a0 is the string, $a1 is the char to find, $a2 is the index to start at
	li $v0 -1  # Default immediate
	bltz $a2 returnIndexOf  # If index is less than zero
	# Find null terminator
	li $t9 0  # Counter
	findNullIndex:
	add $t3 $a0 $t9  # Add counter to address
    lb $t4 0($t3)
    beqz $t4 nullIndexFound
    addi $t9 $t9 1
	j findNullIndex

	nullIndexFound:
    bge $a2 $t9 returnIndexOf  # Check if index is greater than the string length
    
    lookForChar:
    add $t3 $a0 $a2  # Add counter to address
    lb $t4 0($t3)
   	beq $t4 0 returnIndexOf # If the null terminator is reached, return char not found.
    bne $t4 $a1 charNotFound  # If char not found,
    move $v0 $a2  # else, char found
    j returnIndexOf
    charNotFound:
    addi $a2 $a2 1  # Increment counter
    j lookForChar
    
    returnIndexOf:
    jr $ra

replaceAllChar:  # $a0 is the string to be modified, $a1 is the pattern, $a2 is the replacement
	move $v0 $a0  # Return value is the starting address of the string
	# Checking if pattern array and string are null
	lb $t0 0($a1)
	li $v1 -1
	beqz $t0 returnReplaceAllChar
	lb $t0 0($a0)
	beqz $t0 returnReplaceAllChar
	
	# Pattern array and string are not null
	li $t0 0  # Counter for string address
	li $v1 0  # Amount of replacements
	
	lookForReplaceableChar:
	add $t1 $a0 $t0  # Add counter to address
	lb $t2 0($t1)
	beqz $t2 returnReplaceAllChar  # If the null terminator is reached, return values
	
	li $t3 -1  # Counter for pattern address
	checkCharInPattern:
		addi $t3 $t3 1  # Increment Counter
		add $t4 $a1 $t3   # Add counter for pattern address to pattern array
		lb $t4 0($t4)
		beqz $t4 replaceableCharNotFound  # If the pattern reaches the null terminator, the character isn't found
		bne $t2 $t4 checkCharInPattern  # If the character isn't equal to current char,
		sb $a2, 0($t1)  # Replace character at the current address
		addi $v1 $v1 1  # Increment replacement counter
		
	replaceableCharNotFound:
	addi $t0 $t0 1  # Increment counter
	j lookForReplaceableChar
    
    returnReplaceAllChar:
    jr $ra

countOccurrences:  # $a0 is the string, $a1 is the character array
    li $t0 0  # Counter for string address
	li $v0 0  # Amount of occurances
	
	lookForCharOccurance:
	add $t1 $a0 $t0  # Add counter to address
	lb $t2 0($t1)
	beqz $t2 returnCountOccurance  # If the null terminator is reached, return values
	
	li $t3 -1  # Counter for pattern address
	checkPatternOccurance:
		addi $t3 $t3 1  # Increment Counter
		add $t4 $a1 $t3   # Add counter for pattern address to pattern array
		lb $t4 0($t4)
		beqz $t4 noOccuranceOfChar  # If the pattern reaches the null terminator, the character isn't found
		bne $t2 $t4 checkPatternOccurance  # If the character isn't equal to current char,
		addi $v0 $v0 1  # Increment occurance counter
		
	noOccuranceOfChar:
	addi $t0 $t0 1  # Increment counter
	j lookForCharOccurance
    
    returnCountOccurance:
    jr $ra

replaceAllSubstr:
    # Define your code here
    ###########################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    move $v0, $a3
    li $v1, -200
    ##########################################
    jr $ra

split:
    # Define your code here
    ###########################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -200
    li $v1, -200
    ##########################################
    jr $ra
