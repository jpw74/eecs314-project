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
	
	move $s0, $a0 		# put input in $s0
	

	la $a0, shift_prompt	# print shift prompt
	li $v0, 4
	syscall

	li $v0, 5		# get shift amount
	syscall
	
	move $s1, $v0 		# put shift in $s1
	
	add $t0, $zero, $zero 	# loop counter in $t0

Loop:
	add $t1, $s0, $t0	# $t1 = address of current byte = starting location + loop counter
	lb $t2, ($t1)		# load current byte of input into $t2
	beq $t2, 0, Exit	# if we reached null characters, quit looping
	add $t2, $t2, $s1	# add shift amount to current byte
	la $a0, ($t2)		# put shifted byte into $a0
	li $v0, 11		# print $a0
	syscall
	addi $t0, $t0, 1	# increment loop counter
	j Loop	

Exit:
	li $v0, 10
	syscall
