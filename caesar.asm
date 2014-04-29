.data
	buffer: 	.space 	20
	string_prompt: 	.asciiz "Enter string: "
	shift_prompt:	.asciiz "Enter shift: "
.text

	la $a0, string_prompt	# print input prompt
	li $v0, 4
	syscall

	la $a0, buffer		# get input
	li $a1, 20
	li $v0, 8
	syscall
	
	move $t0, $a0 		# put input in $t0
	

	la $a0, shift_prompt	# print shift prompt
	li $v0, 4
	syscall

	la $v0, 5		# get shift amount
	syscall
	
	move $t1, $v0 		# put shift in $t1
	
	lb $t5, ($t0)		# load first byte of input into $t5
	add $t5, $t5, $t1	# add shift amount to first byte
	la $a0, ($t5)		# put shifted byte into $a0
	li $v0, 11		# print $a0
	syscall
	
	lb $t5, 1($t0)		# load second byte into $t5
	add $t5, $t5, $t1	# add shift amount to $t5
	la $a0, ($t5)		# move shifted byte into $a0
	li $v0, 11		# print $a0
	syscall

	# exit program
	li $v0, 10
	syscall