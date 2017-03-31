.data

newline:  .asciiz "\n"
##################################################################
# Arguments for test cases.
boardArray: .space 210
num_rows: .word 10
num_cols: .word 10

set_slot_msg: .asciiz "##### Testing set_slot #####"
set_slot_row: .word 9
set_slot_col: .word 9
set_slot_char: .asciiz "R"
set_slot_turn: .word 255

get_slot_msg: .asciiz "##### Testing get_slot #####"
get_slot_row: .word 9
get_slot_col: .word 9

clear_board_msg: .asciiz "##### Testing clear_board #####"

load_board_msg: .asciiz "##### Testing load_board #####"

display_board_msg: .asciiz "##### Testing display_board #####"

##################################################################
# Constants
.eqv QUIT 10
.eqv PRINT_STRING 4
.eqv PRINT_INT 1
.eqv PRINT_CHAR 11

.text
.globl main

main:

    ##########################
    # set_slot
    ##########################
    la $a0, set_slot_msg
    li $v0, PRINT_STRING
    syscall
    la $a0, newline
    li $v0, PRINT_STRING
    syscall

    la $a0 boardArray
    lw $a1 num_rows
    lw $a2 num_cols
    lw $a3 set_slot_row
    addi $sp $sp -12
 	lw $t0 set_slot_col
 	sw $t0 0($sp)
 	lw $t0 set_slot_char
 	sw $t0 4($sp)
 	lw $t0 set_slot_turn
 	sw $t0 8($sp)
    jal set_slot
    addi $sp $sp 12
    # print return value
    move $a0, $v0
    li $v0, PRINT_INT
    syscall
    la $a0, newline
    li $v0, PRINT_STRING
    syscall
    
    ##########################
    # get_slot
    ##########################
    la $a0, get_slot_msg
    li $v0, PRINT_STRING
    syscall
    la $a0, newline
    li $v0, PRINT_STRING
    syscall
    la $a0 boardArray
    lw $a1 num_rows
    lw $a2 num_cols
    lw $a3 get_slot_row
    addi $sp $sp -4
 	lw $t0 get_slot_col
 	sw $t0 0($sp)
    jal get_slot
   	addi $sp $sp 4
    # print return value
    move $a0, $v0
    li $v0, PRINT_CHAR
    syscall
    move $a0, $v1
    li $v0, PRINT_INT
    syscall
    la $a0, newline
    li $v0, PRINT_STRING
    syscall
    
    ##########################
    # clear_board
    ##########################
    la $a0, clear_board_msg
    li $v0, PRINT_STRING
    syscall
    la $a0, newline
    li $v0, PRINT_STRING
    syscall
    la $a0 boardArray
    lw $a1 num_rows
    lw $a2 num_cols
    jal clear_board
    # print return value
    move $a0, $v0
    li $v0, PRINT_INT
    syscall
    la $a0, newline
    li $v0, PRINT_STRING
    syscall
    
	
    ##########################
    # load_board
    ##########################
    
    
    ##########################
    # display_board
    ##########################
    la $a0, display_board_msg
    li $v0, PRINT_STRING
    syscall
    la $a0, newline
    li $v0, PRINT_STRING
    syscall
    la $a0 boardArray
    lw $a1 num_rows
    lw $a2 num_cols
    jal display_board
    # print return value
    move $a0, $v0
    li $v0, PRINT_INT
    syscall
    la $a0, newline
    li $v0, PRINT_STRING
    syscall
    
    # Exit the program
    li	$v0, 10
    syscall

####################################################################
# End of MAIN program
####################################################################

.include "hw4.asm"