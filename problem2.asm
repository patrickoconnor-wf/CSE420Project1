#
#  Author: Aviral Shrivastava
#  Email: Aviral.Shrivastava@asu.edu
#  Course: CSE 230
# 
#  *** Caller Save Convention ***
#  Callee assumes that callee will not change anything other than $v0, and $v1
#         Therefore callee does not need to worry about the functions that it calls 
#         However, if it changes any register, it must restore it, including $ra, $sp, and any other registers
#
# We try this convention on the following program
#
#int square(int x) {
#    return mult(x,x);
#}
#
#int mult (x,y) {
#    int product=0;
#    for (i=0; i<y; i++)
#       product += x;
#    return product;
#}
#

.data

strPromptU:	 .asciiz "Enter the value of `u`:" 
strPromptV: 	 .asciiz "Enter the value of `v`:" 
strFormula:	 .asciiz "10u^2+4uv+v^2-1=" 
strCR:		 .asciiz "\n" 

.text
		.globl main
main:
		# Prompt user for the value of `u`
		li $v0, 4   # syscall number 4 will print string whose address is in $a0       
		la $a0, strPromptU      # "load address" of the string
		syscall     # actually print the string  

		# Now read in the value for `u`
		li $v0, 5      # syscall number 5 will read an int
		syscall        # actually read the int
		move $s0, $v0  # save result in $s0 for later


		# Propmy user for the value of `v`
		li $v0, 4      # syscall number 4 will print string whose address is in $a0   
		la $a0, strPromptV      # "load address" of the string
		syscall        # actually print the string

		# Now read in the value for `v`
		li $v0, 5      # syscall number 5 will read an int
		syscall        # actually read the int
		move $s1, $v0  # save result in $s1 for later

		move $a0, $s0
		jal square
		move $s2, $v0 # $s2 = u^2
		
		move $a0, $s2
		addi $a1, $zero, 10
		jal mult
		move $s2, $v0 # $s2 = 10*u^2
		
		move $a0, $s0
		move $a1, $s1
		jal mult
		move $s3, $v0 # $s3 = u*v
		
		addi $a0, $zero, 4
		move $a1, $s3
		jal mult
		move $s3, $v0 # $s3 = 4*u*v
		
		move $a0, $s1
		move $a1, $s1
		jal square
		move $s4, $v0 # $s4 = v^2
		
		add $s5, $s2, $s3
		add $s5, $s5, $s4
		subi $s5, $s5, 1 # $s5 = 10u^2+4uv+v^2-1

		# Print the formula that was run
		li $v0, 4      # syscall number 4 -- print string
	        la $a0, strFormula   
	        syscall        # actually print the string 
	          
	        # Print the result that is stored in $s5
	        li $v0, 1         # syscall number 1 -- print int
	        move $a0, $s5     # print $s2
	        syscall           # actually print the int
	        
		# Print a new line
		li $v0, 4      # syscall for print string
	        la $a0, strCR  # address of string with a carriage return
	        syscall        # actually print the string

		# Exit
		li $v0, 10  # Syscall number 10 is to terminate the program
		syscall     # exit now


square:		add $sp, $sp, -8 # Save space on the stack pointer
		sw $ra, 0($sp) # Store $ra for later
		sw $a1, 4($sp) # Store $a1 for later
		
		move $a1, $a0 # Set $a1 to the value of $a0
		jal mult      # to essentially multiply $a0 by it self
		
		lw $ra, 0($sp) # Restore the original $ra
		lw $a1, 4($sp) # Restore the origianl $a1
		add $sp, $sp, 8 # Free the saved space on the stack pointer
		jr $ra # Return to where square was called from
		
mult:		li $t1, 0 # i = 0
		li $t2, 0 # product = 0
	
loop:		bge $t1, $a1, loopExit # While i is less than y
		add $t2, $t2, $a0 # product += x
		add $t1, $t1, 1 # i++
		
		j loop

loopExit:	move $v0, $t2 # Return product
		jr $ra # Return to where mult was called from
				