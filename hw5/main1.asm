# This main file tests your match_glob implementation 
.include "const.asm" # This file contains helpful macros and constants. Read this file first.
.text
main:	
	# Sample Test 1
	# print_strl is defined in const.asm
	print_strl(msg_test1)
	 
	# Load arguments
	la $a0, dna
	la $a1, pattern1

	# Function call
	jal match_glob

	# Save return values
	move $t0, $v0
	move $t1, $v1
	print_strl(msg_v0)
	# print_int is defined in const.asm
	print_int($t0) #$t0 contains $v0 from match_glob
	print_strl(msg_v1)
	print_int($t1) #$t1 contains $v1 from match_glob
	println
	
	# Sample Test 2
	print_strl(msg_test2) 
	# Load arguments
	la $a0, dna
	la $a1, pattern2
	# Function call
	jal match_glob
	# Save return values
	move $t0, $v0
	move $t1, $v1
	print_strl(msg_v0)
	print_int($t0) #$t0 contains $v0 from match_glob
	print_strl(msg_v1)
	print_int($t1) #$t1 contains $v1 from match_glob
	println
	
	# Sample Test 3
	print_strl(msg_test3) 
	# Load arguments
	la $a0, dna
	la $a1, pattern3
	# Function call
	jal match_glob
	# Save return values
	move $t0, $v0
	move $t1, $v1
	print_strl(msg_v0)
	print_int($t0) #$t0 contains $v0 from match_glob
	print_strl(msg_v1)
	print_int($t1) #$t1 contains $v1 from match_glob
	println
	
	# Sample Test 4
	print_strl(msg_test4) 
	# Load arguments
	la $a0, dna
	la $a1, pattern4
	# Function call
	jal match_glob
	# Save return values
	move $t0, $v0
	move $t1, $v1
	print_strl(msg_v0)
	print_int($t0) #$t0 contains $v0 from match_glob
	print_strl(msg_v1)
	print_int($t1) #$t1 contains $v1 from match_glob
	println
	
	# Sample Test 5
	print_strl(msg_test5) 
	# Load arguments
	la $a0, dna
	la $a1, pattern5
	# Function call
	jal match_glob
	# Save return values
	move $t0, $v0
	move $t1, $v1
	print_strl(msg_v0)
	print_int($t0) #$t0 contains $v0 from match_glob
	print_strl(msg_v1)
	print_int($t1) #$t1 contains $v1 from match_glob
	
	# Terminate
	li $v0, 10
	syscall

.data
dna: 	  .asciiz "ACGTTCAAGAGTACC"
#ACGTTCAAGAGTACC
pattern1: .asciiz "ACG"  	# Expect $v0: 0, $v1: irrelevant
pattern2: .asciiz "*"		# Expect $v0: 1, $v1: 15
pattern3: .asciiz "ACG*"	# Expect $v0: 1, $v1: 12
pattern4: .asciiz "*ACC"	# Expect $v0: 1, $v1: 12
pattern5: .asciiz "*AA*"	# Expect $v0: 1, $v1: 13

# include student code
.include "hw5.asm"
