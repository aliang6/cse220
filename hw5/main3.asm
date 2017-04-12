# This main file tests your construct_candidates implementation 
.include "const.asm" # This file contains helpful macros and constants. Read this file first.
.text
main:
	# Sample Test 1
	la $a0, cand
	la $a1, dna1
	li $a2,	2
	print_strl(msg_test1)
	# Function call
	jal construct_candidates
	# Save return value
	move $t0, $v0
	print_strl(msg_v0)
	print_int($t0) #$t0 contains $v0 from match_glob
	println
	
	# Sample Test 2
	la $a0, cand
	la $a1, dna2
	li $a2,	5
	print_strl(msg_test2)
	# Function call
	jal construct_candidates
	# Save return value
	move $t0, $v0
	print_strl(msg_v0)
	print_int($t0) #$t0 contains $v0 from match_glob
	println
	
	# Sample Test 3
	la $a0, cand
	la $a1, dna3
	li $a2,	9
	print_strl(msg_test3)
	# Function call
	jal construct_candidates
	# Save return value
	move $t0, $v0
	print_strl(msg_v0)
	print_int($t0) #$t0 contains $v0 from match_glob
	println
	
	# Terminate
	li $v0, 10
	syscall
	
.data
cand: .space 4
dna1: .asciiz "AT"
dna2: .asciiz "ATCGG"
dna3: .ascii  "ATCGGCTAA@@@@@@@"	

# include student code
.include "hw5.asm"
