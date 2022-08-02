# stub2.asm
# ENCM 369 Winter 2020 Lab 3
# This program has complete start-up and clean-up code, and a "stub"
# main function. It's exactly the same as stub1.asm from Lab 2, except
# that comments have been added to help explain the organization of main.

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
	.text
	.globl	main
main:
	# If main needs a prologue, start it here.
	addi	$sp,$sp,-12			#stack grows by 3 words
	sw	$s0,0($sp)			#stores $s0 in first stack pointer offset
	sw	$s1,4($sp)			#stores $s1 in second stack pointer offset
	sw	$s2,8($sp)			#stores $s2 in third offset of stack pointer
	addi	$s0,$zero,0x6000		#horse = 0x6000
	addi	$s1,$zero,0x2000		#cow = 0x2000
	addi	$s2,$zero,0x30000		#tuna = 0x30000

	
	# Start body of main here.
	jal	shark				#invokes method shark
	add 	$s1,$s1,$v0			#cow = cow + shark return
	lw	$t0,4($sp)			#loads tuna into $t0
	sll	$t1,$t0,1			#$t1 = tuna*2
	add	$t2,$s1,$t1			#$t2 = cow + tuna*2
	add	$s0,$s0,$t2			#horse = horse + $t2
	add	$v0, $zero, $s0			#return value from main = 0
	
	# If main needs an epilogue, start it here.
	lw	$s0,0($sp)			#restores $s0 
	lw	$s1,4($sp)			#restores $s1 
	lw	$s2,8($sp)			#restores $s2 
	jr	$ra
	
	
	
shark:	
	#shark prologue
	#addi	$sp,$sp,-32		#expands stack by 5 words
	addi 	$a0,$zero,5		#$a0 = 5
	addi	$a1,$zero,4		#$a1 = 4
	addi	$a2,$zero,3		#$a2 = 3
	addi	$a3,$zero,2		#$a3 = 2
	sw	$a0,0($sp)		#stores $a0 in first offset of stack 
	sw	$a1,4($sp)		#stores $a1 in second offset of stack 
	sw	$a2,8($sp)		#stores $a2 in third offset of stack 
	sw	$a3,12($sp)		#stores $a3 in fourth offset of stack 
	sw	$ra,16($sp)		#stores $ra in fifth offset of stack
	sw	$s0,20($sp)		#stores $s0
	sw	$s1,24($sp)		#stores $s1
	sw	$s2,28($sp)		#stores $s2
	
	
	#shark Body
	lw	$a0,8($sp)
	lw	$a1,4($sp)
	jal	whale
	add	$s0,$v0,$zero
	lw	$a0,12($sp)
	lw	$a1,0($sp)
	jal	whale
	add	$s1,$v0,$zero
	lw	$a0,4($sp)
	lw	$a1,12($sp)
	jal	whale
	add	$s2,$v0,$zero
	add  	$t0,$s0,$s1
	add	$v0,$t0,$s2
	
	
	#shark epilogue
	lw	$ra,16($sp)		#restores return address
	lw	$s0,20($sp)		#stores $s0
	lw	$s1,24($sp)		#stores $s1
	lw	$s2,28($sp)		#stores $s2
	addi	$sp,$sp,32		#restores stack size
	jr	$ra
	
	
whale:	
	#whale Body
	sll  	$t0,$a0,6
	add	$v0,$a1,$t0
	jr	$ra
	
	
