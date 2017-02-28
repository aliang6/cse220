##############################################################
# Homework #3
# name: Andy Liang
# sbuid: 111008856
##############################################################
.text

##############################
# FUNCTIONS
##############################

indexOf:  # $a0 is the string, $a1 is the char to find, $a2 is the index to start at

    li $v0 -1  # Default immediate
    lookForChar:
    add $t3 $a0 $a2  # Add counter to address
    lb $t4 0($t3)
   	beq $t4 0 returnIndexOf # If the null terminator is reached, return char not found.
    bne $t4 $a1 charNotFound  # If char not found,
    move $v0 $a2  # else, char found
    j returnIndexOf
    charNotFound:
    addi $a2 $a2 1  # Increment counter
    j lookForChar
    
    returnIndexOf:
    jr $ra

replaceAllChar:  # $a0 is the string to be modified, $a1 is the pattern, $a2 is the replacement
	move $v0 $a0  # Return value is the starting address of the string
	li $t0 0  # Counter for amount of replacements
	
    
    
    jr $ra

countOccurrences:
    # Define your code here
    ###########################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -200
    ##########################################
    jr $ra

replaceAllSubstr:
    # Define your code here
    ###########################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    move $v0, $a3
    li $v1, -200
    ##########################################
    jr $ra

split:
    # Define your code here
    ###########################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -200
    li $v1, -200
    ##########################################
    jr $ra
