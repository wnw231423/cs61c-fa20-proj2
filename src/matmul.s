.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:
    # Error checks
    addi t0, x0, 1
    blt a1, t0, error_m0
    blt a2, t0, error_m0
    blt a4, t0, error_m1
    blt a5, t0, error_m1
    bne a2, a4, error_match
    
    # Prologue
    addi, sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6
    
    addi t0, x0, 0  # outer loop counter
    addi t2, x0, 0  # offset for matrix d
outer_loop_start:
    bge t0, s1, outer_loop_end
    addi t1, x0, 0  # inner loop counter
    
    mul t3, t0, s2  # m1's vector start point
    slli t3, t3, 2
    add t3, t3, s0
inner_loop_start:
    bge t1, s5, inner_loop_end
    add t4, t1, s3  # m2's vector start point
    
    mv a0, t3
    mv a1, t4
    mv a2, s2
    addi a3, x0, 1
    mv a4, s5
    
    addi sp, sp, -20
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    
    jal ra, dot

    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    addi sp, sp, 20

    slli t5, t2, 2
    add t5, t5, s6
    sw a0, 0(t5)
    
    addi t2, t2, 1
    addi t1, t1, 1
    jal x0, inner_loop_start
    
inner_loop_end:
    addi t0, t0, 1
    jal x0, outer_loop_start

outer_loop_end:
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi, sp, sp, 32
    
    ret
    
error_m0:
    addi a0, x0, 17
    addi a1, x0, 72
    ecall
error_m1:
    addi a0, x0, 17
    addi a1, x0, 73
    ecall
error_match:
    addi a0, x0, 17
    addi a1, x0, 74
    ecall
