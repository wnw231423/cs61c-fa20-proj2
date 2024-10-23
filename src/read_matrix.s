.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:
    # Prologue
	addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    
    # save parameters
    mv s0, a0
    mv s1, a1
    mv s2, a2
    
    # do fopen
    mv a1, s0
    addi a2, x0, 0
    jal ra, fopen
    addi t0, x0, -1
    beq a0, t0, error2
    mv s5, a0  # s5 is the file descriptor
    
    # do fread to get the # of elements
    addi a0, x0, 8
    jal ra, malloc
    beq a0, x0, error1
    mv s6, a0  # s6 is the temp heap space to store rows and cols
    
    mv a1, s5
    mv a2, s6
    addi a3, x0, 8
    jal ra, fread
    addi t0, x0, 8
    blt a0, t0, error3
    
    lw t0, 0(s6)
    lw t1, 4(s6)
    
    sw t0, 0(s1)
    sw t1, 0(s2)

    mul s3, t0, t1  # the # of elements in matrix
    
    # call malloc for matrix
    slli a0, s3, 2
    jal ra, malloc
    beq a0, x0, error1
    mv s4, a0  # s4 is the pointer to the buffer
    
    # do fread and get exact matrix
    mv a1, s5
    mv a2, s4
    slli a3, s3, 2
    jal ra, fread
    blt a0, s3, error3
    
    # do fclose
    mv a1, s5
    jal ra, fclose
    bne a0, x0, error4
    
    # put return value
    mv a0, s4
    
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi sp, sp, 32
    
    ret
 
 error1:
    addi a1, x0, 88
    jal x0, exit2
error2:
    addi a1, x0, 90
    jal x0, exit2
error3:
    addi a1, x0, 91
    jal x0, exit2
error4:
    addi a1, x0, 92
    jal x0, exit2