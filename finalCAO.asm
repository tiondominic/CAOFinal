.data
	sus: .asciiz "amongus"
	result: .space 100
	UpperBound: .word 101
	LowBound: .word 1
	High: .asciiz "Higher\n"
	Low: .asciiz "Lower\n"
	Guess: .asciiz "Guess: "
	newLine: .asciiz "\n"
	
	filename: .asciiz "song.txt"
	buffer: .space 1028
.align 2
	pitches: .space 1028
	
.text
Random:
	lw $a0, LowBound
	lw $a1, UpperBound
	li $v0, 42
	syscall
	move $s0, $a0

GameLoop:
	li $v0, 4
	la $a0, Guess
	syscall
	
	li $v0, 5
	syscall
	move $t1, $v0
	
	li $v0, 4
	la $a0, newLine
	syscall

	blt $t1, $s0, printHigher
	bgt $t1, $s0, printLower
	beq $t1, $s0, ReadFile
	
printHigher:
	li $v0, 4
	la $a0, High
	syscall
	
	j GameLoop

printLower:
	li $v0, 4
	la $a0, Low
	syscall
	
	j GameLoop
	
ReadFile:
    
    	li $v0, 13
	la $a0, filename
	li $a1, 0
	syscall
	move $s0, $v0
	
	li $v0, 14
	move $a0, $s0
	la $a1, buffer
	li $a2, 1000
	syscall
	move $t1, $v0
	
	#print input from the file
	li $v0, 4 
    	la $t0, buffer
    	move $a0, $t0
    	syscall
    	
    	li   $v0, 16
    	move $a0, $s0
   	syscall
   	
   	la $t0, buffer
   	la $t1, pitches
   	la $t2, 0
   	
 
Iterate:
    	
    	lb   $t3, 0($t0)
    	beqz $t3, PlayMusic

    	li   $t4, 32
    	beq  $t3, $t4, Store 
	
    	li   $t4, 10
    	beq  $t3, $t4, Store

    	li   $t4, 48
    	sub  $t3, $t3, $t4
    	li   $t4, 10
    	mul  $t2, $t2, $t4
    	add  $t2, $t2, $t3

    	addiu $t0, $t0, 1
    	j Iterate
    	
    	
Store:
    
    	sw   $t2, 0($t1)
    	addiu $t1, $t1, 4
    	li   $t2, 0    
    	addiu $t0, $t0, 1    
    	j Iterate
    	
    	
PlayMusic:
    	la $t1, pitches
    	li $a2, 0
    	li $a3, 127

PlayLoop:
    	lw $a0, 0($t1)
    	beqz $a0, End

    	la $a1, 1000 #hardcoded duration 

    	li $v0, 31
    	syscall

    	li $v0, 32
    	la $a0, 400 #delay in ms (change here)
    	syscall

    	addiu $t1, $t1, 4
    	j PlayLoop

End:
	li $v0, 10
    	syscall
