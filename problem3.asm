.data
array: 	.word 0 : 10

.text
		.globl main

main:		
		la 	$s0, array # $s1 holds the address to string
		li 	$s1, 0 # i = 0

initArray:
		bge $s1, 10, doneInitArray
    		add $s3, $s1, $s1    # double the index
    		add $s3, $s3, $s3    # double the index again (now 4x)
    		add $s2, $s3, $s0    # combine the two components of the address
    		addi $s4, $s1, 1
    		li $s5, 3
    		    		
    		move $a0, $s5
    		move $a1, $s4
    		jal mult
    		
    		move $s4, $v0
    		
    		sw $s4, 0($s2)       # get the value from the array cell
		
		addi $s1, $s1, 1		
				
		j initArray
		
doneInitArray:

		li 	$s1, 0 # i = 0
		li 	$s5, 0 # sum = 0
		add	$sp, $sp, 4 # create space for 1 local variable
		sw 	$s5, 0($sp)	# need to save this in memory to create a pointer
sumArray:
		bge $s1, 10, doneSumArray
    		add $s3, $s1, $s1    # double the index
    		add $s3, $s3, $s3    # double the index again (now 4x)
    		add $s2, $s3, $s0    # combine the two components of the address
  
    	  				
    		lw $t1, 0($s6)
		
		li $v0, 1
		move $a0, $t1
		syscall		
    		
    				
    		move $a0, $s5						
    		move $a1, $s2
    		
    		jal pSum
    		
		addi $s1, $s1, 1
				
		j sumArray
		
doneSumArray:

		lw $t1, 0($sp)
		
		li $v0, 1
		move $a0, $t1
		syscall
		
		# Exit
		li $v0, 10  # Syscall number 10 is to terminate the program
		syscall     # exit now		
		
		
pSum:		
		lw $t1, 0($a0)
		lw $t2, 0($a1)
		add $t2, $t2, $t1
		sw $t2, 0($a0)
		jr $ra		
		
mult:		li $t1, 0 # i = 0
		li $t2, 0 # product = 0
	
loop:		bge $t1, $a1, loopExit # While i is less than y
		add $t2, $t2, $a0 # product += x
		add $t1, $t1, 1 # i++
		
		j loop

loopExit:	move $v0, $t2 # Return product
		jr $ra # Return to where mult was called from
		
