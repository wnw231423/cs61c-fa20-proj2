.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:
    # Prologue
    addi sp, sp, -28
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    
    mv a1, s0
    li a2, 1
    jal ra, fopen
    li t0, -1
    beq a0, t0, error_fopen
    mv s4, a0
    
    li a0, 8
    jal ra, malloc
    beq a0, x0, error_malloc
    mv s5, a0
    
    sw s2, 0(s5)
    sw s3, 4(s5)
    
    mv a1, s4
    mv a2, s5
    li a3, 2
    li a4, 4
    jal ra, fwrite
    li t0, 2
    blt a0, t0, error_fwrite
    
    mv a1, s4
    mv a2, s1
    mul a3, s2, s3
    li a4, 4
    jal ra, fwrite
    mul t0, s2, s3
    blt a0, t0, error_fwrite
    
    mv a1, s4
    jal ra, fclose
    li t0, -1
    beq a0, t0, error_fclose
    
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28
    
    ret
    
error_malloc:
    li a1, 88
    jal x0, exit2
error_fopen:
    li a1, 93
    jal x0, exit2
error_fwrite:
    li a1, 94
    jal x0, exit2
error_fclose:
    li a1, 95
    jal x0, exit2
