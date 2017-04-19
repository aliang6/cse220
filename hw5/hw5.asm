# Homework #5
# name: Andy Liang
# sbuid: 111008856

.text

# Helper function toLowerCase

# $a2 contains the letter to be made to lowercase
# Return in $v0
toLowerCase:
	move $v0 $a2
	beq $a2 65 toLowerCaseOne  # Check if 'A'
	beq $a2 67 toLowerCaseOne  # Check if 'C'
	beq $a2 71 toLowerCaseOne  # Check if 'G'
	beq $a2 84 toLowerCaseOne  # Check if 'T'
	j charactersConvertedOne
	toLowerCaseOne:
	addi $v0 $a2 32 
	charactersConvertedOne:
	jr $ra
	

# $a0 contains character array of sequence; $a0 contains character array of pattern
# Return 1 if sequence matches pattern, 0 otherwise
# Note: $a0 and $a1 are case insensitive
match_glob:
	addi $sp $sp -12
	sw $ra 0($sp)
	sw $s0 4($sp)
	sw $s1 8($sp)
	sw $s2 12($sp)
	sw $s3 16($sp)
	
	# Copy arguments into s registers
	move $s0 $a0 
	move $s1 $a1
	li $v0 0
	li $v1 0
	
	# Calculate length of sequence
    li $s2 0  # Counter for finding string length
    findStringLengthOne:
    	add $t0 $a0 $s2  # Add counter to address
    	lb $t0 0($t0)
    	beqz $t0 stringLengthCalculatedOne  # Null terminator found
    	addi $s2 $s2 1
    	j findStringLengthOne
	
	stringLengthCalculatedOne:
	# Calculate length of pattern
	li $s3 0  # Counter for finding string length
    findStringLengthTwo:
    	add $t0 $a1 $s3  # Add counter to address
    	lb $t0 0($t0)
    	beqz $t0 stringLengthCalculatedTwo  # Null terminator found
    	addi $s3 $s3 1
    	j findStringLengthTwo
	stringLengthCalculatedTwo:
	
	matchGlobLoop:
		addi $sp $sp -12
		sw $ra 0($sp)
		sw $a0 4($sp)
		sw $a1 8($sp)
		# Base Cases
		
		# Wildcard is the only character left
		lb $t0 1($a1)
		bne $t0 0 baseCaseTwo
		lb $t0 0($a1) 
		bne $t0 42 baseCaseTwo
		lw $ra 0($sp)
		addi $sp $sp 12
		li $v0 1
		# Calculate remaining length of sequence
		li $t1 0  # Counter
		findRemSeqLength:
    		add $t0 $a0 $t1  # Add counter to address
    		lb $t0 0($t0)
    		beqz $t0 remSeqLengthCalculated  # Null terminator found
    		addi $t1 $t1 1
    		j findRemSeqLength
    	remSeqLengthCalculated:
    	add $v1 $v1 $t1
		jr $ra
		
		baseCaseTwo:
		# Seq and pat are identical
		bne $s2 $s3 baseCaseThree
		li $t2 0  # Traversal counters
		li $t3 0
		seqPatEqualityLoop:
			add $t0 $a0 $t2
			add $t1 $a1 $t3
			lb $a2 0($t0)
			beq $a2 0 seqPatEqual  # Null terminator reached
			# toLowerCase
			jal toLowerCase
			move $t0 $v0
			lb $a2 0($t1)
			jal toLowerCase
			move $t1 $v0
			# Equality check
			bne $t0 $t1 baseCaseThree
			addi $t2 $t2 1 # Increment counters
			addi $t3 $t3 1
			j seqPatEqualityLoop
			
		seqPatEqual:
		lw $ra 0($sp)
		addi $sp $sp 12
		li $v0 1
		jr $ra
		
		baseCaseThree:
		xor $t0 $s2 $s3  # XOR of lengths
		bnez $t0 matchGlobElse
		li $v0 0
		li $v1 0
		lw $ra 0($sp)
		addi $sp $sp 12
		jr $ra
		
		
	matchGlobElse:
		lb $a2 0($a0)  # Load character of sequence
		jal toLowerCase
		move $t0 $v0
		lb $a2 0($a1)  # Load character of pattern
		jal toLowerCase
		move $t1 $v0
		
		move $s0 $a0
		move $s1 $a1 
		
		# Check for equality
		bne $t0 $t1 seqPatNotEq
		addi $a0 $a0 1  # Increment sequence address
		addi $a1 $a1 1  # Increment pattern address 
		jal matchGlobLoop
		lw $ra 0($sp)
		addi $sp $sp 12
		jr $ra
		
		seqPatNotEq:
		bne $t1 42 patNotWild
		move $a0 $s0
		move $a1 $s1
		addi $a1 $a1 1 # Increment sequence address
		jal matchGlobLoop
		
		bne $v0 1 noMatchFound
		lw $ra 0($sp)
		addi $sp $sp 12
		jr $ra  # Return
		noMatchFound:
		move $a0 $s0
		addi $a0 $a0 1
		move $a1 $s1
		jal matchGlobLoop
		addi $v1 $v1 1  # Increment global length
		lw $ra 0($sp)
		addi $sp $sp 12
		jr $ra
		
		patNotWild:
		lw $ra 0($sp)
		addi $sp $sp 12
		li $v0 0
		jr $ra
	
	lw $ra 0($sp)
	lw $s0 4($sp)
	lw $s1 8($sp)
	addi $sp $sp 12
	jr $ra

# $a0 is the destination address; $a1 is the sequence array
save_perm:
	li $t0 0  # Traversal counter for the destination array
	li $t1 0  # Traversal counter for the sequence array
	savePermLoop:
		beqz $t1 noHyphen  # No hyphen required for the zeroeth bit
		li $t2 2
		div $t1 $t2  # Divide counter of the sequence array by two
		mfhi $t2
		bnez $t2 noHyphen  # Check if the sequence array is even
		add $t2 $t0 $a0
		li $t3 45  # Load '-' character
		sb $t3 0($t2)
		addi $t0 $t0 1  # Increment destination array character

		noHyphen:
		add $t2 $a1 $t1
		lb $t3 0($t2)  # Load byte at seq address
		beqz $t3 savePermReturn  # Null terminator
		add $t2 $a0 $t0
		sb $t3 0($t2)  # Store byte at dst address
		addi $t0 $t0 1  # Increment destination array character
		addi $t1 $t1 1  # Increment sequence array counter
		j savePermLoop
		
	savePermReturn:
	add $v0 $a0 $t0
	addi $t0 $t0 -1
	add $t2 $a0 $t0
	li $t3 0
	sb $t3 0($t2)  # Null terminator
	jr $ra

# a0 is the space to store the next character for the permutation; $a1 is the character array representing the 
# current state of the permutation; $a2 is the number describing the location of the character to be filled in the
# sequence array 
# Return the number of candidates that are present; max 4
# Note: $a1 is not necessarily null terminated 
construct_candidates:
	li $t0 2
	div $a2 $t0
	mfhi $t0  # Divide the location number by two
	beqz $t0 candElse  # If location mod two is zero, branch to the else case
	addi $a2 $a2 -1  # n - 1
	add $t0 $a1 $a2
	lb $t0 0($t0)  # Load byte at seq[n-1]
	bne $t0 65 constNotA
		li $t0 84
		sb $t0 0($a0)
		j constructReturn
	constNotA:
	bne $t0 84 constNotAT
		li $t0 65
		sb $t0 0($a0)
		j constructReturn
	constNotAT:
	bne $t0 67 constNotATC
		li $t0 71
		sb $t0 0($a0)
		j constructReturn
	constNotATC:
		li $t0 67
		sb $t0 0($a0)
		j constructReturn
	
	candElse:
		li $t0 65
		sb $t0 0($a0)  # Load 'A'
		li $t0 67
		sb $t0 1($a0)  # Load 'C'
		li $t0 71
		sb $t0 2($a0)  # Load 'G'
		li $t0 84
		sb $t0 3($a0)  # Load 'T'
		li $v0 4
		j constructElseReturn
		
	constructReturn:
		li $v0 1
		
	constructElseReturn:
	jr $ra
	
	
# $a0 is the buffer character sequence of size length
# $a1 is n; continue creating permutation on the nth character (seq[n-1])
# $a2 is the pointer of the location to store the result when the premutation is complete (size == length)
# $a3 is the length i.e. the total number of characters for each permutation
permutations:
	# Error checks
	blez $a3 permutationError  # Length is less than or equal to zero
	li $t0 2
	div $a3 $t0
	mfhi $t0
	beq $t0 1 permutationError  # Length is odd
	
	# 

	li $v0, -200
	li $v1, -200
	permutationError:
	li $a0 -1
	li $a1 0
	jr $ra

.data
