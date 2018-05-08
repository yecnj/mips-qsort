	.data
data:	.word 8,5,14,10,12,3,9,6,1,15,7,4,13,2,11
size:	.word 15
#use below sample if above example is too large to debug
#data:	.word 4,2,5,3,1
#size:	.word 5
	.text

partition:
	# TODO: fill in your code here
	jr 	$ra

quick_sort:
	# TODO: fill in your code here
	jr 	$ra

main:
	la 	$a0, data				#load address of "data"."la" is pseudo instruction, see Appendix A-66 of text book.
	addi 	$a1, $zero, 0
	lw 	$a2, size				#loads data "size"
	addi	$a2, $a2, -1

	addi 	$sp, $sp, -4
	sw	$ra, 0($sp)

	jal 	quick_sort				#quick_sort(data,0,size-1)

	lw	$ra, 0($sp)
	addi	$sp, $sp, 4

	jr 	$ra
