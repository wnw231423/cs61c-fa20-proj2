.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)
    
    mv s0, a0
    mv s1, a1
    
    # exception case:
    addi t0, x0, 1
    blt s1, t0, error
    
    addi t0, x0, 0 # t0 is the counter i
loop_start:
    bge t0, s1, loop_end
    slli t1, t0, 2
    add t1, t1, s0
    lw t2, 0(t1)  # get array[i]
    bge t2, x0, loop_continue
    sw x0, 0(t1)
loop_continue:
    addi t0, t0, 1
    jal x0, loop_start
loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
	ret
    
error:
    addi a0, x0, 17
    addi a1, x0, 78
    ecall
