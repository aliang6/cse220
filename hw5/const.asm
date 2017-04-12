# print a string at %label
.macro print_strl (%label)
	la $a0, %label
	li $v0, 4
	syscall
.end_macro

# print newline
.macro println
	li $a0, 10 # newline char is 10 in ASCII
	li $v0, 11
	syscall
.end_macro

.macro print_int(%reg)
	# Move value in %reg to $a0 to print as int.
	move $a0, %reg
	li $v0, 1
	syscall
	println
.end_macro

.macro print_str(%reg)
	# Move value in %reg to $a0 to print as string.
	move $a0, %reg
	li $v0, 4
	syscall
	println
.end_macro

.data
# Test related constant strings
msg_v0:     .asciiz "$v0: "
msg_v1:     .asciiz "$v1: "
msg_output: .asciiz "Output:\n"
msg_test1: 	.asciiz "===Test1===\n"
msg_test2: 	.asciiz "===Test2===\n"
msg_test3: 	.asciiz "===Test3===\n"
msg_test4: 	.asciiz "===Test4===\n"
msg_test5: 	.asciiz "===Test5===\n"
msg_test6: 	.asciiz "===Test6===\n"
msg_test7: 	.asciiz "===Test7===\n"
msg_test8: 	.asciiz "===Test8===\n"
msg_test9: 	.asciiz "===Test9===\n"
msg_test10: .asciiz "===Test10===\n"