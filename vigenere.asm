# Vigenere Cipher
# M: plaintext
# C: ciphertext
# K: key
# C = (M + K) mod alphabet size (128 for ASCII)

.data
	buffer: 	.space 	20
	string_prompt: 	.asciiz "Enter plaintext: "
	key_prompt:	.asciiz "Enter key string (it must contain the same number of characters as the plaintext): "
.text

Main:
	# Plaintext string
	la $a0, string_prompt	# print input prompt
	li $v0, 4
	syscall

	la $a0, buffer			# get plaintext
	li $a1, 20
	li $v0, 8
	syscall
	
	move $s0, $a0 			# put plaintext in $s0
	
	# Key string
	la $a0, key_prompt		# print key prompt
	li $v0, 4
	syscall

	la $a0, buffer			# get key string
	li $a1, 20
	li $v0, 8				
	syscall
	
	move $s1, $a0 			# put key string in $s1
	li $s2, 128				# put alphabet size in $s2

	add $t0, $zero, $zero 	# loop counter in $t0

Loop:
	add $t1, $s0, $t0			# $t1 = address of current byte in plaintext = starting location + loop counter
	add $t2, $s1, $t0			# $t2 = address of current byte in keytext = starting location + loop counter
	lb $t3, ($t1)				# load current byte of plaintext into $t3
	lb $t4, ($t2)				# load current byte of keytext into $t4
	beq $t3, 0, Exit			# if we reached null characters, quit looping

	add $t3, $t3, $t4			# add current letter of plaintext and keytext
	div $t3, $s2				# divide by alphabet size
	mfhi $t3					# store remainder value from Hi in $t3 

	la $a0, ($t3)				# put encrypted byte into $a0
	li $v0, 11					# print $a0
	syscall
	addi $t0, $t0, 1			# increment loop counter
	j Loop	

Exit:
	li $v0, 10
	syscall