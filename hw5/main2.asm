# This main file tests your save_perm implementation 
.include "const.asm" # This file contains helpful macros and constants. Read this file first.
.text
main:
	# Sample Test 1
	la $a0, dst
	la $a1, perm1
	print_strl(msg_test1)
	# Function call
	jal save_perm
	# Save return value
	move $t0, $v0
	print_strl(msg_v0)
	print_int($t0) #$t0 contains $v0 from match_glob
	println
	
	# Sample Test 2
	la $a0, dst
	la $a1, perm2
	print_strl(msg_test2)
	# Function call
	jal save_perm
	# Save return value
	move $t0, $v0
	print_strl(msg_v0)
	print_int($t0) #$t0 contains $v0 from match_glob
	println
	
	# Terminate
	li $v0, 10
	syscall
	
.data
dst:   .space 2048
perm1: .asciiz "ATGCCGTA"
perm2: .asciiz "ATATAT"

# include student code
.include "hw5.asm"
