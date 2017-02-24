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

.macro convert(%ascii) # Assumes %ascii is an ascii with the value 0-F inclusive
	move $t0 %ascii
	bge $t0 65 convertL	# If $t0 is A-F, branch to convertL
	addi $t0 $t0 -0x30	# Subtract by 0x30 if 0-9
	j converted
	convertL:
	addi $t0 $t0 -0x37 # Subtract by 0x37 if A-F
	converted:
	move %ascii $t0

.end_macro



.text
.globl main
main:
	load_args()		# Load_args
	
	# Check if number of arguments is 3
	lw $t0, numargs		# Load numargs into $s0
	bne $t0, 3, error	# If numargs != 3, branch to error
	
	
	# Load address of fromBase to $s1
	lw $s1, fromBase 
	
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
	
	
	# Load address address of toBase to $s2
	lw $s2 toBase	
	
	# Check if toBase is more than one character
	lb $s1 1($s2) 	# Overwrite $s1 to hold byte 1 of toBase
	bnez $s1 error 	#If byte 1 is not equal to 0, branch to error
	
	# Check if toBase is out of bounds
	lb $s1, 0($s2)	#Load byte 0 of toBase into $s1
	blt $s1 50 error	# If fromBase is less than 2 (ASCII 50), branch to error
	bgt $s1 57 middleRestrictionT	#If toBase is greater than 9 (ASCII 57), branch to middleRestrictionT
	blt $s1 58 withinBoundsT	# If toBase is less than 10 [ASCII 58 (:)], branch to withinBoundsT
	middleRestrictionT:
		blt $s1 65 error # If toBase is less than 10/A (ASCII 65), branch to error
		bgt $s1 70 error # If toBase is greater than 15/F (ASCII 70), branch to error
	withinBoundsT: # fromBase and toBase are within bounds
	
	
	# Check if integer is valid
	lw $s2 integer	# Overwrite $s2 to contain the address of the integers argument
	li $t3 0	# Create a counter that starts at 0
	check:
		add $t0 $s2 $t3 # Adds the counter to the address
		lb $t1 0($t0)	# Load byte $t3 of $s2 into $t1
		beqz $t1 integerValid	# If $t1 equals null (ASCII 0), branch to integerValid
		blt $t1 48 error	# If $t1 is less than 0 (ASCII 48), branch to error
		bge $t1 $s0 error 	# If $t1 is greater than or equal to fromBase, branch to error
		blt $s0 58 integerByteValid  # If fromBase is less than 10 [ASCII 58 (:)], branch to integerValid
		blt $s0 65 error	# If fromBase is less than ASCII 65 (10/A) , branch to error
		integerByteValid:
			addi $t3 $t3 1	# Increment $t3 by 1
			j check  # Loop to check 
	integerValid: # Integer is valid
	
	
	# Once there are no errors:
	convert ($s0)	# Convert fromBase to base 10
	li $t2 0	# Will be used to hold the current total
	li $t3 0	# Will be used as a counter
	
	convertIntegerF: # Convert integer from fromBase to base 10
		add $t0 $s2 $t3  # Add the counter to the address
		lb $t1 0($t0)	# Load byte $t3 of $s2 into $t1
		beqz $t1 base10 # If $t1 is null, branch to base 10
		convert($t1) # Else convert $t1 into decimal
		mul $t2 $t2 $s0	# Multiply the current total by fromBase
		add $t2 $t2 $t1 # Add $t1 to the current total
		addi $t3 $t3 1	# Increment the counter by 1
		j convertIntegerF
	
	
base10: # Convert number from base 10 to base toBase
	move $s2 $t2 	# Overwrite $s2 to equal the integer in decimal form
	convert($s1)	# Convert toBase to decimal
	li $t0 0	# Overwrite $t0 to be 0
	li $t2 31	# Buffer position
	convertIntegerT: 
		div $s2 $s1  # Divide integer by toBase
		mfhi $t3	# Move remainder into $t3
		mflo $t4	# Move quotient into $t4
		ble $t3 9 convertNumber	# If the remainder is less than or equal to 9, branch to convertNumber
		addi $t3 $t3 0x37	# Convert remainder > 10 to ASCII
		j store
		convertNumber:
			addi $t3 $t3 0x30	# Convert remainder <= 9 to ASCII
			
		store:
		la $t5 buffer	# Load buffer address to $t5
		add $t5 $t5 $t2		# Add $t2 to buffer address
		sb $t3 0($t5) 	# Store the remainder in buffer
		move $s2 $t4
		addi $t2 $t2 -1 # Buffer position - 1
		beqz $t4 integerConverted	# Once the quotient is 0, the integer is converted
		j convertIntegerT

error:	#Error label
	li $v0 4	# Prints error message
	la $a0 Err_string
	syscall
	j end
	
integerConverted:
	

print:	#Print label
	li $v0 4
	la $a0 buffer
	syscall
	
end:
	li $v0 10		# Ends program
	syscall
