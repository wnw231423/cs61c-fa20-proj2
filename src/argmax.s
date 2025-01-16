.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    # exception case:
    addi t0, x0, 1
    blt a1, t0, error
    
    # Prologue
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)

    mv s0, a0
    mv s1, a1
    addi t0, x0, 1  # t0 is the counter, start comparision from second element
    addi t1, x0, 0  # t1 stores the current index of the largest element
    lw t2, 0(s0)  # t2 stores the current larget element
    
loop_start:
    bge t0, s1, loop_end
    slli t3, t0, 2
    add t4, t3, s0
    lw t5, 0(t4)
    bge t2, t5, loop_continue
    mv t1, t0
    mv t2, t5
loop_continue:
    addi t0, t0, 1
    jal x0, loop_start
loop_end:
    mv a0, t1
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
    
    ret

error:
    addi a0, x0, 17
    addi a1, x0, 77
    ecall