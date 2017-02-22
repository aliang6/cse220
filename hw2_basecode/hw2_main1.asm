# hw2_main1.asm
# This file is NOT part of your homework 2 submission.
# Any changes to this file WILL NOT BE GRADED.

.data

newline:  .asciiz "\n"
comma:    .asciiz ", "
testchar: .byte '9'

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

	##################
	# char2digit
	##################
	li $a0, '@'
	jal char2digit

	# print return value
	move $a0, $v0
	li $v0, PRINT_INT
	syscall
	li $v0, PRINT_STRING
	la $a0, newline
	syscall

	##################
	# memchar2digit
	##################
	la $a0, testchar
	jal memchar2digit

	# print return value
	move $a0, $v0
	li $v0, PRINT_INT
	syscall
	li $v0, PRINT_STRING
	la $a0, newline
	syscall

	##################
	# fromExcessk
	##################
	li $a0, 2
	li $a1, 0
	jal fromExcessk

	# print return value
	move $a0, $v0
	li $v0, PRINT_INT
	syscall
	li $v0, PRINT_STRING
	la $a0, comma
	syscall
	move $a0, $v1
	li $v0, PRINT_INT
	syscall
	li $v0, PRINT_STRING
	la $a0, newline
	syscall

	##################
	# printNbitBinary
	##################
	li $a0, 8
	li $a1, 3
	jal printNbitBinary

	# print return value
	move $a0, $v0
	li $v0, PRINT_INT
	syscall
	li $v0, PRINT_STRING
	la $a0, newline
	syscall

	# Exit the program
	li $v0, QUIT
	syscall

###################################################################
# End of MAIN program
####################################################################


#################################################################
# Student defined functions will be included starting here
#################################################################

.include "hw2.asm"
