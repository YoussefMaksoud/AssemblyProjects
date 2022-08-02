# stub1.asm
# ENCM 369 Winter 2020 Lab 2
# This program has complete start-up and clean-up code, and a "stub"
# main function.

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

# Below is the stub for main. Edit it to give main the desired behaviour.
	.data
	.globl 	alpha
alpha:	.word 	0xb1, 0xe1, 0x91, 0xc1, 0x81, 0xa1, 0xf1, 0xd1
	.globl	beta
beta:	.word	0x0, 0x10, 0x20, 0x30, 0x40, 0x50, 0x60, 0x70

#	Variable	Register
#	*palpha		$s0
#	*pbeta		$s1
#	*guarda		$s2
#	*guardb		$s3
#	min		$s4
#	k		$s5
	.text
	.globl	main
main:
	la 	$s0,alpha		# $s0 = &alpha
	la	$s1,beta		# $s1 = &beta
	addi	$s2,$s0,32		# $s2 = &alpha + 8
	addi	$s3,$s1,32		# $s3 = &beta + 8
	lw 	$s4,($s0)		# min = *palpha
	add	$s5,$zero,$zero	
	addi	$s6,$zero,8	
	
	addi 	$s0,$s0,4		#p++
L1:
	beq	$s0,$s2,L3		# if(palpha == guarda)
	lw	$t0,($s0)		# $t0 = *palpha
	slt	$t1,$t0,$s4		# if(min > $t0) $t = 1
	beq 	$t1,$zero,L2		# if($t1 != 0) jump L3
	add	$s4,$t0,$zero		#min = *palpha
L2:	
	addi 	$s0,$s0,4		# p++
	j 	L1
L3:	
	la 	$t0,alpha
	addi 	$t1,$s1,32
L4:	
	slt	$t8,$s6,$s5
	beq	$s5,$s6,L5
	bne	$t8,$zero,L5			#beginning of array (alpha			#end of array (beta)
	lw 	$t2,($t1)			#loads t2 with value at beta
	sw 	$t2,($t0)
	add	$t0,$t0,4
	add	$t1,$t1,-4
	addi	$s5,$s5,1
	j	L4
L5:



	add	$v0, $zero, $zero	# return value from main = 0
	jr	$ra
