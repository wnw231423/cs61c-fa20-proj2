.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    addi t0, x0, 1
    blt a2, t0, error1
    blt a3, t0, error2
    blt a4, t0, error2
    
    # Prologue
    addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    addi t0, x0, 0  # t0 is the result
    addi t1, x0, 0  # t1 is the counter
loop_start:
    bge t1, a2, loop_end
    mul t4, t1, s3
    slli t4, t4, 2
    addi t4, t4, s0
    lw t2, 0(t4)

    mul t4, t1, s4
    slli t4, t4, 2
    addi t4, t4, s1
    lw t3, 0(t4)

    mul t2, t2, t3
    add t0, t0, t2
    
    addi t1, t1, 1
    jal x0, loop_start

loop_end:
    mv a0, t0

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24
    ret
    
error1:
    addi a0, x0, 17
    addi a1, x0, 75
    ecall
    
error2:
    addi a0, x0, 17
    addi a1, x0, 76
    ecall
