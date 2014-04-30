# Affine cipher
# Encryption: E(x) = (ax + b) mod m
# Decryption: D(x) = a^-1(x - b) mod m
# m is size of alphabet, for ASCII it's 128
# a and b are the keys
# x is the letter to be encrypted
# a and m must be coprime
# b is given by user

.data
	buffer: 	.space 	20
	string_prompt: 	.asciiz "Enter string: "
	shift_prompt:	.asciiz "Enter shift: "
.text

Main:
	la $a0, string_prompt	# print input prompt
	li $v0, 4
	syscall

	la $a0, buffer			# get input
	li $a1, 20
	li $v0, 8
	syscall
	
	move $s0, $a0 			# put input in $s0
	

	la $a0, shift_prompt	# print shift prompt
	li $v0, 4
	syscall

	la $v0, 5				# get shift amount
	syscall
	
	move $s1, $v0 			# put shift in $s1
	li $s2, 15				# store affine key in $s2
	li $s3, 128				# store alphabet size in $s3
	
	add $t0, $zero, $zero 	# loop counter in $t0

Loop:
	add $t1, $s0, $t0			# $t1 = address of current byte = starting location + loop counter
	lb $t2, ($t1)				# load current byte of input into $t2
	beq $t2, 0, Exit			# if we reached null characters, quit looping

	mult $t2, $s2				# multiply by affine key
	mflo $t2					# move multiplication result from Lo to $t2
	add $t2, $t2, $s1			# add shift amount
	div $t2, $s3				# divide by alphabet size
	mfhi $t2					# move remainder value from Hi to $t2

	la $a0, ($t2)				# put shifted byte into $a0
	li $v0, 11					# print $a0
	syscall
	addi $t0, $t0, 1			# increment loop counter
	j Loop	

Exit:
	li $v0, 10
	syscall
