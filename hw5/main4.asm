# This main file tests your match_glob implementation 
.include "const.asm" # This file contains helpful macros and constants. Read this file first.
.text
main:	
	# Sample Test 1
	print_strl(msg_test1) 
	# Load arguments
	la $a0, dna1
	li $a1, 0
	la $a2, res
	li $a3, 3
	# Function call
	jal permutations
	# Save return values
	move $t0, $v0
	move $t1, $v1
	print_strl(msg_v0)
	print_int($t0)
	print_strl(msg_v1)
	print_int($t1)
	println
	# permutations does not null terminate the final output
	# $t1 is the address of the byte after last saved permutation
	sb $zero, 0($t1) 
	print_strl(msg_output)
	print_strl(res)
	println
	
	# Sample Test 2
	print_strl(msg_test2) 
	# Load arguments
	la $a0, dna1
	li $a1, 0
	la $a2, res
	li $a3, 0
	# Function call
	jal permutations
	# Save return values
	move $t0, $v0
	move $t1, $v1
	print_strl(msg_v0)
	print_int($t0)
	print_strl(msg_v1)
	print_int($t1)
	println
	# permutations does not null terminate the final output
	# $t1 is the address of the byte after last saved permutation
	sb $zero, 0($t1) 
	print_strl(msg_output)
	print_strl(res)
	println
	
	# Sample Test 3
	print_strl(msg_test3) 
	# Load arguments
	la $a0, dna1
	li $a1, 0
	la $a2, res
	li $a3, 4
	# Function call
	jal permutations
	# Save return values
	move $t0, $v0
	move $t1, $v1
	print_strl(msg_v0)
	print_int($t0)
	print_strl(msg_v1)
	print_int($t1)
	println
	# permutations does not null terminate the final output
	# $t1 is the address of the byte after last saved permutation
	sb $zero, 0($t1) 
	print_strl(msg_output)
	print_strl(res)
	println
	
	# Sample Test 4
	print_strl(msg_test4) 
	# Load arguments
	la $a0, dna2
	li $a1, 3
	la $a2, res
	li $a3, 6
	# Function call
	jal permutations
	# Save return values
	move $t0, $v0
	move $t1, $v1
	print_strl(msg_v0)
	print_int($t0)
	print_strl(msg_v1)
	print_int($t1)
	println
	# permutations does not null terminate the final output
	# $t1 is the address of the byte after last saved permutation
	sb $zero, 0($t1) 
	print_strl(msg_output)
	print_strl(res)
	
	# Terminate
	li $v0, 10
	syscall

.data
res:      .space 2048
dna1:     .space 4 
dna2:  	  .ascii "ATC@@@"
pattern1: .asciiz "ACG*"
pattern2: .asciiz "ACG"
pattern3: .asciiz "*"
pattern4: .asciiz "*AA*"

# include student code
.include "hw5.asm"
