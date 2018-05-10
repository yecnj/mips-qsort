	.data
data: .word 8,5,14,10,12,3,9,6,1,15,7,4,13,2,11
size: .word 15
#use below sample if above example is too large to debug
#data: .word 4,2,5,3,1
#size: .word 5
	.text

partition:
	# TODO: fill in your code here
	addi 	$t1, $a1, 0				# left -> t1
	addi 	$t2, $a2, 0				# right -> t2

	addi 	$t9, $a1, 0
	sll 	$t9, $t9, 2
	add 	$t3, $t9, $a0		
	lw 		$t3, 0($t3)				# pivot -> t3

loop1:
	slt 	$t4, $t1, $t2			# if start(t1) < end(t2)
	bne 	$t4, 1, part_end		# is not true go end

loop2:
	addi 	$t9, $t2, 0
	sll 	$t9, $t9, 2
	add 	$t5, $t9, $a0
	lw 		$t5, 0($t5)				# data[right] -> t5

	slt	 	$t5, $t3, $t5
	bne 	$t5, 1, loop3			# if not pivot < data[right] go next
	
	addi 	$t2, $t2, -1			# t2--;
	j 		loop2

loop3:
	addi 	$t9, $t1, 0
	sll 	$t9, $t9, 2
	add	 	$t5, $t9, $a0
	lw 		$t5, 0($t5)				# data[left] -> t5

	slt 	$t5, $t3, $t5
	bne 	$t5, $zero, part_swap	# if data[left] > pivot go next

	slt 	$t5, $t1, $t2
	bne 	$t5, 1, part_swap		# if not left < right go next

	addi 	$t1, $t1, 1				# t1++;
	j 		loop3

part_swap:
	slt $t5, $t1, $t2
	bne $t4, 1, loop1				# if not left < right go next

	addi $t8, $t1, 0
	sll $t8, $t8, 2
	add $t8, $t8, $a0				# t8 has data[left]

	addi $t9, $t2, 0
	sll $t9, $t9, 2
	add $t9, $t9, $a0				# t9 has data[right]

	lw $t6, 0($t8)
	lw $t7, 0($t9)
	sw $t7, 0($t8)
	sw $t6, 0($t9)					# swap them
	j loop1

part_end:
	addi $t9, $t2, 0
	sll $t9, $t9, 2
	add $t5, $t9, $a0
	lw $t7, 0($t5)					# data[right] -> t7

	addi $t9, $a1, 0
	sll $t9, $t9, 2
	add $t6, $t9, $a0				# data[start] -> t6

	sw $t7, 0($t6)					# data[start] = data[right]
	sw $t3, 0($t5)					# data[right] = pivot
	
	addu $v0, $zero, $t2			# return right
	jr $ra

quick_sort:
	# TODO: fill in your code here
	slt $t0, $a1, $a2				# if start(a1) < end(a2)
	bne $t0, 1, end_qsort			# is not true go end

	subu $sp, $sp, 16
	sw $ra, 16($sp)
	sw $a0, 12($sp)
	sw $a1, 8($sp)
	sw $a2, 4($sp)					# sw 4/a2, 8/a1, 12/a0, 16/ra

	jal partition					# return value of partition is v0

	subu $sp, $sp, 4
	sw $v0, 4($sp)					# v0 to stack pointer 
	lw $a0, 16($sp)					# a0 reload
	lw $a1, 12($sp)					# a1 reload
	addi $a2, $v0, -1				# a2 = v0 - 1

	jal quick_sort					# qsort(data, start, pos-1)

	lw $a0, 16($sp)					# a0 reload
	lw $a2, 8($sp)					# a2 reload
	lw $t0, 4($sp)					# v0 to t0
	addi $a1, $t0, 1				# a1 = v0 + 1

	jal quick_sort					# qsort(data, pos+1, end)

	ori $t0, $t0, 0

	addu $sp, $sp, 20				# except ra, don't need them
	lw $ra, 0($sp)					# ra reload

end_qsort:
	jr $ra

main:
	la 	$a0, data					# gload address of "data"."la" is pseudo instruction, see Appendix A-66 of text book.
	addi $a1, $zero, 0				# start = 0
	lw $a2, size					# loads data "size"
	addi $a2, $a2, -1				# end = size-1

	addi $sp, $sp, -4
	sw $ra, 0($sp)

	jal quick_sort					# quick_sort(data,0,size-1)

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra
