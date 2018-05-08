	.data
data: .word 8,5,14,10,12,3,9,6,1,15,7,4,13,2,11
size: .word 15
#use below sample if above example is too large to debug
#data: .word 4,2,5,3,1
#size: .word 5
	.text

partition:
	# TODO: fill in your code here
	addi $v0, $a2, 0		# For test, $v0 = end
	jr $ra

quick_sort:
	# TODO: fill in your code here
	slt $t1, $a1, $a2		# if start < end
	bne $t1, 1, END			# is not true go END
	jal partition			# partition
	addi $a3, $a2, 0		# save end
	addi $a2, $v0, -1		# end = pos-1
	jal quick_sort			# qsort(data, start, pos-1)
	addi $a2, $a3, 0		# load end
	addi $a1, $v0, 1		# start = pos+1
	jal quick_sort			# qsort(data, pos+1, end)
	END:
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
