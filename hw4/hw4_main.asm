.data

newline:  .asciiz "\n"
##################################################################
# Arguments for test cases.
.align 2
boardArray: .space 210
num_rows: .word 10
num_cols: .word 10

set_slot_msg: .asciiz "##### Testing set_slot #####"
set_slot_row: .word 9
set_slot_col: .word 9
set_slot_charOne: .word 82  # ASCII for "R"
set_slot_charTwo: .word 89  # ASCII for "Y"
set_slot_turn: .word 255

get_slot_msg: .asciiz "##### Testing get_slot #####"
get_slot_row: .word 9
get_slot_col: .word 9

clear_board_msg: .asciiz "##### Testing clear_board #####"

load_board_msg: .asciiz "##### Testing load_board #####"
load_board_fileName: .asciiz "save_board.txt"

save_board_msg: .asciiz "##### Testing save_board #####"
save_board_fileName: .asciiz "save_board.txt"

drop_piece_msg: .asciiz "##### Testing drop_piece #####"
drop_piece_col: .word 4
drop_piece_turn: .word 1

display_board_msg: .asciiz "##### Testing display_board #####"

undo_piece_msg: .asciiz "##### Testing undo_piece #####"

check_winner_msg: .asciiz "##### Testing check_winner #####"

check_diagonal_winner_msg: .asciiz "##### Testing check_diagonal_winner #####"

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
 	lw $t0 set_slot_charOne
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
    # save_board
    ##########################
    la $a0, save_board_msg
    li $v0, PRINT_STRING
    syscall
    la $a0, newline
    li $v0, PRINT_STRING
    syscall
    la $a0 boardArray
    lw $a1 num_rows
    lw $a2 num_cols
    li $a3 9
    addi $sp $sp -12
 	li $t0 9
 	sw $t0 0($sp)
 	lw $t0 set_slot_charOne
 	sw $t0 4($sp)
 	li $t0 255
 	sw $t0 8($sp)
    jal set_slot
    la $a0 boardArray
    lw $a1 num_rows
    lw $a2 num_cols
    li $a3 0
    li $t0 0
 	sw $t0 0($sp)
 	lw $t0 set_slot_charTwo
 	sw $t0 4($sp)
 	li $t0 2
 	sw $t0 8($sp)
    jal set_slot
    addi $sp $sp 12
    la $a0 boardArray
    lw $a1 num_rows
    lw $a2 num_cols
    la $a3 load_board_fileName
    #jal save_board
    move $a0, $v0
    li $v0, PRINT_INT
    syscall
    la $a0, newline
    li $v0, PRINT_STRING
    syscall
    
	
    ##########################
    # load_board
    ##########################
    la $a0, load_board_msg
    li $v0, PRINT_STRING
    syscall
    la $a0, newline
    li $v0, PRINT_STRING
    syscall
    la $a0 boardArray
    la $a1 load_board_fileName
    #jal load_board
    # print return value
    move $a0, $v0
    li $v0, PRINT_INT
    syscall
    li $a0 32
    li $v0 PRINT_CHAR
    syscall
    move $a0, $v1
    li $v0, PRINT_INT
    syscall
    la $a0, newline
    li $v0, PRINT_STRING
    syscall
    
    ##########################
    # drop_piece
    ##########################
    la $a0, drop_piece_msg
    li $v0, PRINT_STRING
    syscall
    la $a0, newline
    li $v0, PRINT_STRING
    syscall
    la $a0 boardArray
    lw $a1 num_rows
    lw $a2 num_cols
    li $a3 5
    addi $sp $sp -8
 	lw $t0 set_slot_charTwo
 	sw $t0 0($sp)
 	lw $t0 drop_piece_turn
 	sw $t0 4($sp)
    jal drop_piece
   	move $a0, $v0
    li $v0, PRINT_INT
    syscall
    li $a0 32
    li $v0 PRINT_CHAR
    syscall
    la $a0 boardArray
    lw $a1 num_rows
    lw $a2 num_cols
    li $a3 5
 	lw $t0 set_slot_charTwo
 	sw $t0 0($sp)
 	lw $t0 drop_piece_turn
 	sw $t0 4($sp)
    jal drop_piece
   	addi $sp $sp 8
   	move $a0, $v0
    li $v0, PRINT_INT
    syscall
    li $a0 32
    li $v0 PRINT_CHAR
    syscall
    la $a0 boardArray
    lw $a1 num_rows
    lw $a2 num_cols
    li $a3 5
 	lw $t0 set_slot_charTwo
 	sw $t0 0($sp)
 	lw $t0 drop_piece_turn
 	sw $t0 4($sp)
    jal drop_piece
   	move $a0, $v0
    li $v0, PRINT_INT
    syscall
	li $a0 32
    li $v0 PRINT_CHAR
    syscall
    la $a0 boardArray
    lw $a1 num_rows
    lw $a2 num_cols
    li $a3 5
 	lw $t0 set_slot_charOne
 	sw $t0 0($sp)
 	lw $t0 drop_piece_turn
 	sw $t0 4($sp)
    jal drop_piece
   	addi $sp $sp 8
   	move $a0, $v0
    li $v0, PRINT_INT
    syscall
    la $a0, newline
    li $v0, PRINT_STRING
    syscall
    addi $sp $sp 8
    
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
    #jal display_board
    # print return value
    move $a0, $v0
    li $v0, PRINT_INT
    syscall
    la $a0, newline
    li $v0, PRINT_STRING
    syscall
    
    ##########################
    # undo_piece
    ##########################
    la $a0, undo_piece_msg
    li $v0, PRINT_STRING
    syscall
    la $a0, newline
    li $v0, PRINT_STRING
    syscall
    la $a0 boardArray
    lw $a1 num_rows
    lw $a2 num_cols
    jal undo_piece
    move $a0, $v0
    li $v0, PRINT_CHAR
    syscall
    li $a0 32
    li $v0 PRINT_CHAR
    syscall
    move $a0, $v1
    li $v0, PRINT_INT
    syscall
    la $a0, newline
    li $v0, PRINT_STRING
    syscall
    
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
    #jal display_board
    # print return value
    move $a0, $v0
    li $v0, PRINT_INT
    syscall
    la $a0, newline
    li $v0, PRINT_STRING
    syscall
    
    ##########################
    # check_winner
    ##########################
    la $a0, check_winner_msg
    li $v0, PRINT_STRING
    syscall
    la $a0, newline
    li $v0, PRINT_STRING
    syscall
    la $a0 boardArray
    lw $a1 num_rows
    lw $a2 num_cols
    jal check_winner
    # print return value
    move $a0, $v0
    li $v0, PRINT_CHAR
    syscall
    la $a0, newline
    li $v0, PRINT_STRING
    syscall

	##########################
    # check_diagonal_winner
    ##########################
    la $a0, check_diagonal_winner_msg
    li $v0, PRINT_STRING
    syscall
    la $a0, newline
    li $v0, PRINT_STRING
    syscall	
	la $a0 boardArray
    lw $a1 num_rows
    lw $a2 num_cols
    li $a3 9
    addi $sp $sp -12
 	li $t0 1
 	sw $t0 0($sp)
 	lw $t0 set_slot_charOne
 	sw $t0 4($sp)
 	li $t0 11
 	sw $t0 8($sp)
    jal set_slot
    addi $sp $sp 12
    la $a0 boardArray
    lw $a1 num_rows
    lw $a2 num_cols
    li $a3 8
    addi $sp $sp -12
 	li $t0 2
 	sw $t0 0($sp)
 	lw $t0 set_slot_charOne
 	sw $t0 4($sp)
 	li $t0 12
 	sw $t0 8($sp)
    jal set_slot
    addi $sp $sp 12
    la $a0 boardArray
    lw $a1 num_rows
    lw $a2 num_cols
    li $a3 7
    addi $sp $sp -12
 	li $t0 3
 	sw $t0 0($sp)
 	lw $t0 set_slot_charTwo
 	sw $t0 4($sp)
 	li $t0 13
 	sw $t0 8($sp)
    jal set_slot
    addi $sp $sp 12
    la $a0 boardArray
    lw $a1 num_rows
    lw $a2 num_cols
    li $a3 6
    addi $sp $sp -12
 	li $t0 4
 	sw $t0 0($sp)
 	lw $t0 set_slot_charOne
 	sw $t0 4($sp)
 	li $t0 14
 	sw $t0 8($sp)
    jal set_slot
    addi $sp $sp 12
    la $a0, newline
    li $v0, PRINT_STRING
    syscall
    la $a0 boardArray
    lw $a1 num_rows
    lw $a2 num_cols
    jal display_board
    la $a0 boardArray
    lw $a1 num_rows
    lw $a2 num_cols
    jal check_diagonal_winner
    # print return value
    move $a0, $v0
    li $v0, PRINT_CHAR
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