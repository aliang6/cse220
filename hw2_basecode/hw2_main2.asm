# hw2_main2.asm
# This file is NOT part of your homework 2 submission.
# Any changes to this file WILL NOT BE GRADED.

.data

pi: .float 3.1415926535897924
input_buffer: .space 50
prompt: .asciiz "Enter a string of binary digits or an IEEE special value: "
print_error: .asciiz "Error in btof function"
print_positive: .asciiz "\nPostive Value\n"
print_special:  .asciiz "\nSpecial Value\n"
print_negative: .asciiz "\nNegative Value\n"


# Constants
.eqv QUIT 10
.eqv PRINT_STRING 4
.eqv PRINT_FLOAT 2
.eqv PRINT_INT 1
.eqv READ_STRING 8

.text
.globl _start

####################################################################
# This is the "main" of your program; Everything starts here.
####################################################################

_start:
	li $v0, 1
	# Ask the user for input value
	jal prompt_user

	# This program performs NO ERROR checking on the user input.
	# Your function can should assume the user has inputted a string
	# which is consistent with the homework specification.

	# Save the float value on the stack
	addi $sp, $sp, -4
	sw $v1, 0($sp)

	# Check for input error report from btof
	blt $v0, $0, Error_quit

	##################
	# print_parts
	##################
	move $a0, $v1
	jal print_parts
	move $t9, $v0

	li $v0, PRINT_STRING
	beqz $t9, Spec
	li $t0, 1
	beq $t9, $t0, Pos
	la $a0, print_negative
	syscall
	j Next

Spec:
	la $a0, print_special
	syscall
	j Next
Pos:
	la $a0, print_positive
	syscall

Next:
	#######################
	# print_binary_product
	#######################
	lw $a0, 0($sp)
	jal print_binary_product

	li $t1, -1
	beq $v0, $t1 exit
	la $a0, print_special
	li $v0, PRINT_STRING
	syscall
	j exit

Error_quit:
	li $v0, PRINT_STRING
	la $a0, print_error
	syscall

	# Exit the program
exit:
	addi $sp, $sp, 4
	li $v0, QUIT
	syscall

###################################################################
# End of MAIN program
####################################################################

####################################################################
# Function which asks the user to enter a input value, calls btof
# function and then returns the IEEE-754 single precision representation
# of the input value
#
# Parameters passed:
# $v0 = success or error
# $v1 = return value of user entered value
####################################################################

prompt_user:

	# Push Address onto the stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	# Ask the user for a string
	li $v0, PRINT_STRING
	la $a0, prompt
	syscall

	li $v0, READ_STRING
	la $a0, input_buffer
	li $a1, 49 		# If you have a space of N this value should be (N-1), extra space holds the return character
	syscall

	##################
	# btof
	##################

	la $a0, input_buffer
	jal btof

	# return value from btof is expected in $v1
	# leave it there to return

	# Get $ra from the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

#################################################################
# Student defined functions will be included starting here
#################################################################

.include "hw2.asm"
