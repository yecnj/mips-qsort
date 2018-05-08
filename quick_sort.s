	.data
#data: .word 8,5,14,10,12,3,9,6,1,15,7,4,13,2,11
#size: .word 15
#use below sample if above example is too large to debug
data: .word 4,2,5,3,1
size: .word 5
	.text

partition:
	# TODO: fill in your code here
	addi $t1, $a1, 0		# left -> t1
	addi $t2, $a2, 0		# right -> t2
	addi $t9, $a1, 0
	sll $t9, $t9, 2
	add $t3, $t9, $a0
	lw $t3, 0($t3)			# pivot -> t3

loop1:
	slt $t4, $t1, $t2		# if start(t1) < end(t2)
	bne $t4, 1, part_end	# is not true go end

loop2:
	addi $t9, $t2, 0
	sll $t9, $t9, 2
	add $t5, $t9, $a0
	lw $t5, 0($t5)
	slt $t5, $t3, $t5
	bne $t5, 1, loop3
	addi $t2, $a1, -1		# t2--;
	j loop2

loop3:
	addi $t9, $t1, 0
	sll $t9, $t9, 2
	add $t5, $t9, $a0
	lw $t5, 0($t5)
	slt $t5, $t5, $t3
	bne $t4, $zero, part_swap
	slt $t5, $t1, $t2
	bne $t5, 1, part_swap
	addi $t1, $a1, 1		# t1++;
	j loop3

part_swap:
	slt $t5, $t1, $t2
	bne $t4, 1, loop1
	add $t5, $t1, $zero
	add $t1, $t2, $zero
	add $t2, $t5, $zero
	j loop1

part_end:
	addi $t9, $t2, 0
	sll $t9, $t9, 2
	add $t5, $t9, $a0
	lw $t7, 0($t5)
	addi $t9, $t1, 0
	sll $t9, $t9, 2
	add $t6, $t9, $a0
	sw $t7, 0($t6)
	sw $t3, 0($t5)
	addu $v0, $zero, $t3
	jr $ra

quick_sort:
	# TODO: fill in your code here
	slt $t0, $a1, $a2		# if start(a1) < end(a2)
	bne $t0, 1, end_qsort	# is not true go end
	ori $t0, $t0, 0
	sw $ra, 16($sp)
	sw $a0, 12($sp)
	sw $a1, 8($sp)
	sw $a2, 4($sp)			# sw 4/a2, 8/a1, 12/a0, 16/ra
	jal partition			# return value of partition is v0
	sw $v0, 4($sp)			# v0 to stack pointer 4/v0, 8/a2, 12/a1, 16/a0, 20/ra
	lw $a0, 12($sp)			# a0 reload
	lw $a1, 8($sp)			# a1 reload
	addi $a2, $v0, -1		# a2 = v0 - 1
	jal quick_sort			# qsort(data, start, pos-1)
	lw $a0, 16($sp)			# a0 reload
	lw $a2, 8($sp)			# a2 reload
	lw $t0, 4($sp)			# v0 to t0
	addi $a1, $t0, 1		# a1 = v0 + 1
	jal quick_sort			# qsort(data, pos+1, end)
	ori $t0, $t0, 0
	addu $sp, $sp, 20		# except ra, don't need them
	lw $ra, 0($sp)			# ra reload
end_qsort:
	jr $ra

main:
	la 	$a0, data			# gload address of "data"."la" is pseudo instruction, see Appendix A-66 of text book.
	addi $a1, $zero, 0		# start = 0
	lw $a2, size			# loads data "size"
	addi $a2, $a2, -1		# end = size-1

	addi $sp, $sp, -4
	sw $ra, 0($sp)

	jal quick_sort			#quick_sort(data,0,size-1)

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra
