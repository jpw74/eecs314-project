# REGISTER USAGE
# $s0	input type	1 = CLI, 2 = file
# $s1	output type	1 = CLI, 2 = file
# $s2	output file	if applicable
# $s3	cipher type	1 = Caesar, 2 = Aphine
# $s4	input string
# $s5 	output string

.data
	buffer: 		.space 		20
	output:			.space		20
	in_type_prompt:		.asciiz		"Would you like to input from the command line [1] or a file [2]? "
	out_type_prompt:	.asciiz		"Would you like to write to the command line [1] or a file [2]? "
	cipher_prompt:		.asciiz		"Select which cipher you would like:\n[1] Caesar\n[2] Affine\n"
	string_prompt:		.asciiz		"Enter your string: "
	not_implemented:	.asciiz		"This feature has not been implemented yet.\n"
	invalid_input:		.asciiz		"Invalid input.\n"
	caesar_shift:		.asciiz		"Enter shift amount: "

.text
	jal GetInput		# get input type in $t0, input in $s0
	jal GetOutput		# get output type in $t1, file name in $t2 if applicable
	jal GetCipher		# get cipher type in $t3
	
	la $s5, output		# $s5 = starting address of output memory 
	
	beq $s3, 1, Caesar

CipherReturn:
	add $t0, $zero, $zero	# initialize loop counter for output
	beq $s1, 1, CLIOutput	# at this point $s1 can't be anything else because of NotImplemented and InvalidInput
				# but branching anywhere because we'll beq $s1, 2, FileOutput sometime in the future

	j Exit

########## END OF PROGRAM - EVERYTHING BELOW IS CALLED INTO AND RETURNS ABOVE ##########


########## CAESAR CIPHER ##########
Caesar:
	la $a0, caesar_shift	# print shift prompt
	li $v0, 4
	syscall

	li $v0, 5		# get shift amount
	syscall
	
	move $t0, $v0 		# put shift in $t0
	
	add $t1, $zero, $zero 	# loop counter in $t1
	# FALL THROUGH TO CaesarLoop

CaesarLoop:
	add $t2, $s4, $t1	# $t2 = address of current byte = starting location + loop counter
	lb $t3, ($t2)		# load current byte of input into $t3
	beq $t3, 0, CipherReturn# if we reached null characters, quit looping and return above
	add $t3, $t3, $t0	# $t3 = current byte + shift amount
	add $t4, $s5, $t1	# $t4 = current output memory location = starting location of output memory + loop counter
	sb $t3, ($t4)		# store shifted byte into current output memory location
	addi $t1, $t1, 1	# increment loop counter
	j CaesarLoop	
########### END CAESAR CIPHER ##########


########## HELPER ROUTINES HERE TIL END ##########
GetInput:
	la $a0, in_type_prompt	# display input prompt
	li $v0, 4
	syscall
	
	li $v0, 5		# get input type
	syscall
	
	move $s0, $v0		# put input type in $s0
	
	la $t9, GetInput	# start over if they choose file input
	beq $s0, 2, NotImplemented
	beq $s0, 1, CLIInput

	la $t9, GetInput	# start over if fallen through to here
	j InvalidInput		# using helper InvalidInput label for consistency

CLIInput:	
	la $a0, string_prompt	# print input prompt
	li $v0, 4
	syscall
	
	la $a0, buffer		# get input
	li $a1, 20
	li $v0, 8
	syscall
	
	move $s4, $a0 		# put input in $s4
	jr $ra			# return into main - $ra was set when jal'ing into GetInput

GetOutput:
	la $a0, out_type_prompt	# display output type prompt
	li $v0, 4
	syscall
	
	li $v0, 5		# get output type
	syscall
	
	move $s1, $v0		# put output type in $s1
	
	la $t9, GetOutput	# start over if they chose file output
	beq $s1, 2, NotImplemented
	beq $s1, 1, DummyReturn
	
	la $t9, GetOutput	# invalid input if fallen through to here
	j InvalidInput		# using InvalidInput label for consistency
	
DummyReturn:
	# dummy routine to exit from GetOutput - $ra is saved from jal'ing into GetOutput
	jr $ra

GetCipher:
	la $a0, cipher_prompt	# display cipher type prompt
	li $v0, 4
	syscall
	
	li $v0, 5		# get cipher type
	syscall
	
	move $s3, $v0		# put cipher type in $s3

	slti $t0, $s3, 1	# if cipher type is less than 1 or greater than 2 => invalid input => start over
	sgt $t0, $s3, 2
	la $t9, GetCipher
	beq $t8, 1, InvalidInput
	
	jr $ra

CLIOutput:
	add $t1, $s5, $t0
	lb $t2, ($t1)
	beq $t2, 0 Exit
	la $a0, ($t2)
	li $v0, 11
	syscall
	addi $t0, $t0, 1
	j CLIOutput

InvalidInput:
	# helper routine for invalid input
	# prints invalid input message, then returns to whatever label was set in $t9
	# NEED TO SET $t9 BEFORE CALLING FOR IT TO WORK
	la $a0, invalid_input
	li $v0, 4
	syscall
	jr $t9

NotImplemented:
	# helper routine features that aren't implemented yet
	# prints not implemented message, then jumps to whatever label was set in $t9
	# NEED TO SET $t9 BEFORE CALLING FOR IT TO WORK
	la $a0, not_implemented
	li $v0, 4
	syscall
	jr $t9
	
Exit:
	li $v0, 10
	syscall
