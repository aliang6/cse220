# Homework #1
# Name: Andy Liang
# SBUID: 111008856

.data
.align 2

	numargs: .word 0
	integer: .word 0
	fromBase: .word 0
	toBase: .word 0
	Err_string: .asciiz "ERROR\n"
	
	# buffer is 32 space characters
	buffer: .ascii "                                "
	newline: .asciiz "\n"
	
# Helper macro for grabbing command line arguments
.macro load_args
    sw $a0, numargs
    lw $t0, 0($a1)
    sw $t0, integer
    lw $t0, 4($a1)
	sw $t0, fromBase
	lw $t0, 8($a1)
	sw $t0, toBase
.end_macro



.text
.globl main
main:
	load_args()		# Load_args
	
	# Check if number of arguments is 3
	lw $t0, numargs		# Load numargs into $s0
	bne $t0, 3, error	# If numargs != 3, branch to error
	
	lw $s1, fromBase # Load address of fromBase to $s1
	
	# Check if fromBase is more than one character
	lb $s0, 1($s1)	 # Load byte 1 of fromBase into $s0
	bnez $s0, error	 # If byte 1 is not equal to 0 (i.e. not equal to the null terminator), branch to error
	
	# Check if fromBase is out of bounds
	lb $s0, 0($s1)   # Load byte 0 of frombase into $s0
	blt $s0 50 error	# If fromBase is less than 2 (ASCII 50), branch to error
	bgt $s0 57 middleRestrictionF # If fromBase is greater than 9 (ASCII 57), branch to middleRestrictionF
	blt $s0 58 withinBoundsF	 # If fromBase is less than 10 (ASCII 58), branch to withinBoundsF
	middleRestrictionF:
		blt $s0 65 error # If fromBase is less than A (ASCII 65), branch to error
		bgt $s0 70 error # If fromBase is greater than F (ASCII 70), branch to error
	withinBoundsF:	# fromBase is within bounds
	
	
	lw $s2 toBase	# Load address address of toBase to $s2
	
	# Check if toBase is more than one character
	lb $s1 1($s2) 	# Overwrite $s1 to hold byte 1 of toBase
	bnez $s1 error 	#If byte 1 is not equal to 0, branch to error
	
	# Check if toBase is out of bounds
	lb $s1, 0($s2)	#Load byte 0 of toBase into $s1
	blt $s1 50 error	# If fromBase is less than 2 (ASCII 50), branch to error
	bgt $s1 57 middleRestrictionT	#If toBase is greater than 9 (ASCII 57), branch to middleRestrictionT
	blt $s1 58 withinBoundsT	# If toBase is less than 10 (ASCII 58), branch to withinBoundsT
	middleRestrictionT:
		blt $s1 65 error # If toBase is less than 10/A (ASCII 65), branch to error
		bgt $s1 70 error # If toBase is greater than 15/F (ASCII 70), branch to error
	withinBoundsT: # fromBase and toBase are within bounds
	
	# Check if integer is valid
	
	
	# Once there are no errors:
	beq $s0 65 base10 	# If fromBase is equal to 10/A (ASCII 65), branch to base10
	#move $t1 $s0 	# Copy value to be converted to $t1
	
while:
	beq $t1, $0, base10 # If $t1 is equal to 0, branch to base 10
	
	
	
	
	
	
base10: # Convert number from base 10 to base toBase
	li $t0 10 # Load 10 into $t0
	beq $s1 10 print # If toBase is equal to 10 (ASCII, branch to print integer

error:	#Error label
	li $v0 4	# Prints error message
	la $a0 Err_string
	syscall
	j end

print:	#Print label
	li $v0 1
	move $a0 $t5
	syscall
	
end:
	li $v0 10		# Ends program
	syscall
