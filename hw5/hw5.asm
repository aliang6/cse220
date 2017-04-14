# Homework #5
# name: Andy Liang
# sbuid: 111008856

.text

# $a0 contains character array of sequence; $a0 contains character array of pattern
# Return 1 if sequence matches pattern, 0 otherwise
# Note: $a0 and $a1 are case insensitive
match_glob:
	# Store s registers and return address
	addi $sp $sp -20
	sw $ra 0($sp)
	sw $s0 4($sp)
	sw $s1 8($sp)
	sw $s2 12($sp)
	sw $s3 16($sp)
	
	move $s0 $a0  # Sequence array
	move $s1 $a1  # Pattern array
	
	# Find the length of the character array sequence
	li $s2 0  # Length counter
	seqLength:
		add $t1 $s2 $s0  # Increment address
		beqz $t1 seqLengthFound  # Null terminator reached
		addi $s2 $s2 1  # Increment counter
		j seqLength
		
	seqLengthFound:
	
	# Base Cases

	
	lw $ra 0($sp)
	lw $s0 4($sp)
	lw $s1 8($sp)
	lw $s2 12($sp)
	lw $s3 16($sp)
	addi $sp $sp 20
	jr $ra

# $a0 is the sequence array; $a1 is the starting destination address
save_perm:
	li $t0 0  # Traversal counter for the sequence array
	li $t1 0  # Traversal counter for the destination array
	savePermLoop:
		beqz $t0 noHyphen  # No hyphen required for the zeroeth bit
		li $t2 2
		div $t0 $t2  # Divide counter of the sequence array by two
		mfhi $t2
		bnez $t2 noHyphen  # Check if the sequence array is even
		add $t2 $t1 $a1
		li $t3 45  # Load '-' character
		sb $t3 0($t2)
		addi $t1 $t1 1  # Increment destination array character

		noHyphen:
		add $t2 $a0 $t0
		lb $t3 0($t2)  # Load byte at address
		beqz $t3 savePermReturn  # Null terminator
		add $t2 $a1 $t1
		sb $t3 0($t2)  # Store byte at address
		addi $t0 $t0 1  # Increment sequence array counter
		addi $t1 $t1 1  # Increment destination array character
		j savePermLoop
		
	savePermReturn:
	add $t2 $a1 $t1
	li $t3 0
	sb $t3 0($t2)  # Null terminator
	addi $t1 $t1 1  
	add $v0 $a1 $t1 # Address of byte after null terminator
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
		j constructElseReturn
	constNotA:
	bne $t0 84 constNotAT
		li $t0 65
		sb $t0 0($a0)
		j constructElseReturn
	constNotAT:
	bne $t0 67 constNotATC
		li $t0 71
		sb $t0 0($a0)
		j constructElseReturn
	constNotATC:
		li $t0 67
		sb $t0 0($a0)
		j constructElseReturn
	
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
	
permutations:
	li $v0, -200
	li $v1, -200
	jr $ra

.data
