.data

string: .asciiz "WELCOME TO COMPUTER ARCHITECTURE CLASS" 

.text
.globl main
main:
		la 	$s1, string # $s1 holds the address to string
		li 	$s2, 0 # i = 0

loop:
		add 	$t1, $s1, $s2
		lb 	$t2, 0($t1)
		
		beqz 	$t2, done # Goto done if end of string
		blt	$t2, 65, print # Goto print if the char at $t2
		bgt	$t2, 90, print # is not a capital letter
		
		addi	$t2, $t2, 32 # Add 32 to make letter lower case
			
print:	
		move 	$a0, $t2 # Get the current char ready to print
		li 	$v0, 11 # Syscall number 11 is to print char
		syscall # Print value in $a0
			
		addi $s2, $s2, 1 # i++
		
		j loop
		
done:
		li $v0, 10 # Syscall number 10 is to terminate the program
		syscall # exit now
		
