

# BEGINNING of start-up & clean-up code.  Do NOT edit this code.
	.data
exit_msg_1:
	.asciiz	"***About to exit. main returned "
exit_msg_2:
	.asciiz	".***\n"
main_rv:
	.word	0
	
	.text
	# adjust $sp, then call main
	addi	$t0, $zero, -32		# $t0 = 0xffffffe0
	and	$sp, $sp, $t0		# round $sp down to multiple of 32
	jal	main
	nop
	
	# when main is done, print its return value, then halt the program
	sw	$v0, main_rv	
	la	$a0, exit_msg_1
	addi	$v0, $zero, 4
	syscall
	nop
	lw	$a0, main_rv
	addi	$v0, $zero, 1
	syscall
	nop
	la	$a0, exit_msg_2
	addi	$v0, $zero, 4
	syscall
	nop
	addi	$v0, $zero, 10
	syscall
	nop	
# END of start-up & clean-up code.


#int aaa[] = {9, -11, 12, 7, -15};
#int bbb[] = {-21, 1, 3};
#int ccc[] = {-101, 0, 0, 102, 0, 0, -100};
	.data
	.globl		aaa
	.globl		bbb
	.globl		ccc
	
aaa:	.word		9, -11, 12, 7, -15
bbb:	.word		-21, 1, 3
ccc:	.word		-101, 0, 0, 102, 0, 0, -100

#int  main (void)

	.text
	.globl 		main
	.globl 		foo
	.globl 		foo_sum
	
main:	#()
	#main prologue
	addi 	$sp,$sp,-24		#expands stack by 4 words
	sw	$s0,0($sp)#alpha		#stores the value of $s0 in memory
	sw	$s1,4($sp)#beta		#stores the value of $s1 in memory
	sw	$s2,8($sp)#gamma		#stores the value of $s2 in memory
	sw	$s3,12($sp)		#stores the value of $s3 in memory
	sw	$s4,16($sp)
	sw	$ra,20($sp)		#stores the value of $s4 in memory
	
	#main body
	addi	$s2,$zero,2000		#gamma = 2000
	la	$a0,aaa			#$a0 = aaa
	addi	$a1,$zero,5		#$a1 = 5
	addi	$a2,$zero,10		#$a2 = 10
	jal 	foo_sum			#invokes foo_sum
	add	$s0,$zero,$v0		#alpha = foo_sum rv
	la	$a0,bbb			#$a0 = bbb
	addi	$a1,$zero,3		#$a1 = 3
	addi	$a2,$zero,20		#$a2 = 20
	jal 	foo_sum			#invokes foo_sum
	add	$s1,$zero,$v0		#beta = foo_sum rv
	la	$a0,ccc			#$a0 = ccc
	addi	$a1,$zero,7		#$a1 = 7
	addi	$a2,$zero,100		#$a2 = 100
	jal	foo_sum			#invokes foo_sum
	sub	$t0,$s0,$s1		#$t0 = alpha = beta
	add	$t1,$t0,$v0		#$t1 = foo_sum rv + $t0
	add	$s2,$s2,$t1		#s2 += $t1
	
	#main epilogue
	lw	$s0,0($sp)		#stores the value of $s0 in memory
	lw	$s1,4($sp)		#stores the value of $s1 in memory
	lw	$s2,8($sp)		#stores the value of $s2 in memory
	lw	$s3,12($sp)		#stores the value of $s3 in memory
	lw	$s4,16($sp)
	lw	$ra,20($sp)
	addi 	$sp,$sp,24		
	
	jr $ra
	

foo:	#(int x, int bound)
	#foo body
	add	$v0,$zero,$a0		#rv = x
	mul	$t0,$a0,-1		#-x
	mul	$t3,$a1,-1		#-bound
L1:
	blt	$a0,$a1,L6		#(if x < bound) jump
	add	$v0,$zero,$a1		#rv = bound
	j	L3		
L6:
	blt	$t3,$a0,L2		#(if -bound < x) jump
	add	$v0,$zero,$a1		#rv = bound
	j 	L3
L2:	
	blt	$zero,$a0,L3		#(if x > 0) jump
	add	$v0,$zero,$t0		#rv = -x
L3:
	jr	$ra



foo_sum:#(const int *x, int n, int b)	
	#foo_sum prologue
	addi 	$sp,$sp,-28		#expands stack by 4 words
	sw	$s0,0($sp)#x		#stores the value of $s0 in memory
	sw	$s1,4($sp)#n		#stores the value of $s1 in memory
	sw	$s2,8($sp)#b		#stores the value of $s2 in memory
	sw	$s3,12($sp)#k		#stores the value of $s3 in memory
	sw	$s4,16($sp)#sum		#stores the value of $s4 in memory
	sw 	$ra,20($sp)		#stores return address in memory

	#foo_sum body
	add 	$s4,$zero,$zero		#sum = 0
	add	$s3,$zero,$zero		#k = 0
	add	$s1,$zero,$a1		#$s1 = n
	add	$s2,$zero,$a2		#$s2 = b
	add	$t1,$zero,$a0		#saves initial address of array
	add	$t2,$zero,$a0		#saves initial address of array
	
L4:#start loop
	blt	$s1,$s3,L5	
	beq	$s1,,$s3,L5
	
	lw	$a0,($t1)
	add	$a1,$zero,$s2
	jal	foo			#invokes foo
	add	$s4,$s4,$v0		#sum+= foo rv
	addi	$s3,$s3,1		#k++
	sll	$t0,$s3,2		#k*4
	add	$t1,$zero,$t2		#off set t1 by k
	add 	$t1,$t1,$t0		#return t1 original address to prepare for nest incrementation
	j	L4	
L5:#end loop
	add	$v0,$zero,$s4

	#foo_sum epilogue
	lw	$s0,0($sp)#x		#stores the value of $s0 in memory
	lw	$s1,4($sp)#n		#stores the value of $s1 in memory
	lw	$s2,8($sp)#b		#stores the value of $s2 in memory
	lw	$s3,12($sp)#k		#stores the value of $s3 in memory
	lw	$s4,16($sp)#sum		#stores the value of $s4 in memory
	lw 	$ra,20($sp)		#stores return address in memory
	addi 	$sp,$sp,28
	jr 	$ra