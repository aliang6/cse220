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

replaceAllSubstr: # $a0 is address of destination string (must be null terminated, $a1 is the number of bytes in the
				  # destination array, $a2 is the input string, $a3 are the search characters, argument 4 is in the
				  # stack and is the string to replace the characters with.
    lw $t0 0($sp)  # Load returnStr argument to $t0
    addi $sp $sp -24  # Make space in stack to store values $s0 - $s5
    sw $ra 4($sp)  # Store return address in stack
    sw $s0 8($sp)
    sw $s1 12($sp)
    sw $s2 16($sp)
    sw $s3 20($sp)
    sw $s4 24($sp)
    move $s0 $a0  # Destination address
    move $s1 $a1  # Destination array byte length
    move $s2 $a2  # Input string
    move $s3 $a3  # Search character array
    move $s4 $t0  # Replacement String
    
    # Check if input string or character array is null
    lb $t0 0($s2)
    beqz $t0 errorReplaceAllSubstr
    lb $t0 0($s3)
    beqz $t0 errorReplaceAllSubstr
    
    # Find the total occurances of the search characters
    move $a0 $s2  # Copy input string into $a0
    move $a1 $s3  # Copy search characters into $a1
    jal countOccurrences
    move $v1 $v0
    
    beqz $v1 returnReplaceAllSubstr  # If there are no occurances, return the function
    
    # Find length of the input string
    li $t0 0  # Counter for finding string length
    findStringLength:
    	add $t1 $s2 $t0  # Add counter to address
    	lb $t1 0($t1)
    	beqz $t1 stringLengthCalculated  # Null terminator found
    	addi $t0 $t0 1
    	j findStringLength
    
    stringLengthCalculated:
    #Find length of the replacement string
    li $t1 0  # Counter for finding length of the replacement string
    findReplacementStringLength:
    	add $t2 $s4 $t1  # Add counter to address
    	lb $t2 0($t2)
    	beqz $t2 replacementStringLengthCalculated  # Null terminator found
    	addi $t1 $t1 1  # Increment counter
    	j findReplacementStringLength
    	
    replacementStringLengthCalculated:
    addi $t1 $t1 -1  # Substract one from the length of the search character array
    mult $t1 $v1  # Multiple the occurances by the length of the replacement string - 1
    mflo $t2
    add $t2 $t2 $t0  # Total length of the modified string
    addi $t2 $t2 1  # Total length of the modified string including null terminator
    bgt $t2 $s1 errorReplaceAllSubstr  # Error if the modified string length is longer than dstLen
    
    # Error checks completed=========================================================================
    
   	# Loop through string, looking for a occurances of the chars in #s3
   	li $t0 0  # Counter that goes through the input string
   	li $t1 0  # Counter that goes through the dst string
   	li $t9 0  # Counter that increments when a replacement is performed
   	
   	# Check if the $t0th byte of the input string is equal to one of the replacement strings
   	iterateThroughInputString:
   		add $t2 $s2 $t0  # Add counter to input string
   		lb $t2 0($t2)  #  Load the $t0th byte of the input string
   		beqz $t2 inputStringIterationComplete  # Null terminator reached
   		li $t3 0  # Counter for searchChar array
   		checkIfByteMatchesSearch:
   			add $t4 $s3 $t3  # Add counter to searchArray address
   			lb $t4 0($t4)
   			beqz $t4 searchCharNotFound  # Null terminator reached
   			beq $t2 $t4 searchCharFound  # Input character matches a search character
   			addi $t3 $t3 1  # Increment searchChar counter
   		j checkIfByteMatchesSearch
   		
   	searchCharFound:  
   	addi $t9 $t9 1  # Increment replacement counter
   	li $t3 0  # Counter for the replacement string
   	addi $t0 $t0 1  # Increment input string counter
   	replaceCharIteration: # Loop through the replacement string and replace the original character
   		add $t4 $s4 $t3  # Add counter to the replacement string
   		lb $t4 0($t4)
   		beqz $t4 iterateThroughInputString  # Null terminator reached
   		add $t5 $s0 $t1  # Add counter to the dst address
   		sb $t4 0($t5)  # Store the byte of the replacement string into dst
   		addi $t3 $t3 1  # Increment replacement string counter
   		addi $t1 $t1 1 # Increment dst address counter
   		j replaceCharIteration
   		
   	searchCharNotFound:
   		add $t3 $s0 $t1  # Add the counter to the dst address
   		sb $t2 0($t3)  # Store the same byte into the dst address
   		addi $t0 $t0 1  # Increment input string counter
   		addi $t1 $t1 1 # Increment dst address counter
   		j iterateThroughInputString
   	
   	
    errorReplaceAllSubstr:
    li $v1 -1 
    j returnReplaceAllSubstr
    
    inputStringIterationComplete:
    move $v1 $t9  # Number of replacements
    
    returnReplaceAllSubstr:
    move $v0 $s0  # Move starting addess of dst into return
    # Restore original values for $s0 - $s5
    lw $ra 4($sp)
    lw $s0 8($sp)
    lw $s1 12($sp)
    lw $s2 16($sp)
    lw $s3 20($sp)
    lw $s4 24($sp)
   	addi $sp $sp 24
    jr $ra

split:
    # Define your code here
    ###########################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -200
    li $v1, -200
    ##########################################
    jr $ra
