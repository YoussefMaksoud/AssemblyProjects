# swap.asm
# ENCM 369 Winter 2020 Lab 3 Exercise F

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

# int quux[] =  { 0x11, 0x21, 0x31, 0x41, 0x51, 0x61 }
	.data
        .globl	quux
quux:	.word	0x11, 0x21, 0x31, 0x41, 0x51, 0x61

# int main(void)
#
        .text
        .globl  main
main:
	addi	$sp, $sp, -32
 	sw 	$ra, 0($sp)

	la	$t0, quux	# $t0 = &quux[0]
	addi	$a0, $t0, 8	# $a0 = &quux[2]
	addi	$a1, $t0, 12	# $a1 = &quux[3]
	jal	swap
	
	la	$t0, quux	# $t0 = &quux[0]
	addi	$a0, $t0, 4	# $a0 = &quux[1]
	addi	$a1, $t0, 16	# $a1 = &quux[4]
	jal	swap
	
	la	$t0, quux	# $t0 = &quux[0]
	addi	$a0, $t0, 0	# $a0 = &quux[0]
	addi	$a1, $t0, 20	# $a1 = &quux[5]
	jal	swap

	

	add	$v0, $zero, $zero		
	lw	$ra, 0($sp)
	addi	$sp, $sp, 32
	jr	$ra

# void swap(int *p, int *q)
#
	.text
	.globl  swap
swap:
	lw	$t0,($a0)			#loads word at &a0 into $t0
	lw	$t1,($a1)			#loads word at &a1 into $t1
	add	$s0,$zero,$t0			#$s0 = t0
	sw	$t1,($a0)			#store value of $t1 at &a0 (swapped)
	sw	$s0,($a1)			#store calue of $s0 at &a1 (swapped)
	
	jr	$ra
