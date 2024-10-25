.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    li t0, 5
    bne a0, t0, error_args_number
    
    # prologue
    addi sp, sp, -48
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    sw s11, 48(sp)

    
    # save parameters
    mv s0, a0
    mv s1, a1
    mv s2, a2

	# =====================================
    # LOAD MATRICES
    # =====================================
    li a0, 8
    jal ra, malloc
    beq a0, x0, error_malloc
    mv s3, a0  # int* rows
    addi s4, a0, 4  # int* cols
    
    li a0, 24
    jal ra, malloc
    beq a0, x0, error_malloc
    mv s8, a0  # int* rows_m0, cols_m0, rows_m1, cols_m1, rows_input, cols_input
    
    # Load pretrained m0
    lw a0, 4(s1)
    mv a1, s3
    mv a2, s4
    jal ra, read_matrix
    mv s5, a0  # int* m0
    lw t0, 0(s3)
    sw t0, 0(s8)
    lw t0, 0(s4)
    sw t0, 4(s8)

    # Load pretrained m1
    lw a0, 8(s1)
    mv a1, s3
    mv a2, s4
    jal ra, read_matrix
    mv s6, a0  # int* m1
    lw t0, 0(s3)
    sw t0, 8(s8)
    lw t0, 0(s4)
    sw t0, 12(s8)

    # Load input matrix
    lw a0, 12(s1)
    mv a1, s3
    mv a2, s4
    jal ra, read_matrix
    mv s7, a0  # int* input
    lw t0, 0(s3)
    sw t0, 16(s8)
    lw t0, 0(s4)
    sw t0, 20(s8)

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    lw t0, 0(s8)
    lw t1, 20(s8)
    mul t2, t0, t1
    slli a0, t2, 2
    jal ra, malloc
    beq a0, x0, error_malloc
    mv s9, a0  # int* m0*input
    
    mv a0, s5
    lw a1, 0(s8)
    lw a2, 4(s8)
    mv a3, s7
    lw a4, 16(s8)
    lw a5, 20(s8)
    mv a6, s9
    jal ra, matmul
    
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    mv a0, s9
    lw t0, 0(s8)
    lw t1, 20(s8)
    mul a1, t0, t1
    jal ra, relu
    
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    lw t0, 8(s8)
    lw t1, 20(s8)
    mul t2, t0, t1
    slli a0, t2, 2
    jal ra, malloc
    beq a0, x0, error_malloc
    mv s10, a0  # int* m1*ReLU(m0 * input)
    
    mv a0, s6
    lw a1, 8(s8)
    lw a2, 12(s8)
    mv a3, s9
    lw a4, 0(s8)
    lw a5, 20(s8)
    mv a6, s10
    jal ra, matmul
    
    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s1)
    mv a1, s10
    lw a2, 8(s8)
    lw a3, 20(s8)
    jal ra, write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s10
    lw t0, 8(s8)
    lw t1, 20(s8)
    mul a1, t0, t1
    jal ra, argmax
    mv s11, a0
    
    # Print classification
    bne, s2, x0, end
    mv a1, s11
    jal ra, print_int
    # Print newline afterwards for clarity
    li a1, '\n'
    jal ra, print_char
    
end:
    mv a0, s11
    
    #  do free
    mv a0, s3  # free rows and cols array
    jal ra, free
    mv a0, s8  #  free m0 m1 input cols and cols array
    jal ra, free
    mv a0, s5  #  free m0
    jal ra, free
    mv a0, s6  #  free m1
    jal ra, free
    mv a0, s7  #  free input
    jal ra, free
    mv a0, s9 #  free m0*input
    jal ra, free
    mv a0, s10  #  free m1*relu(m0*input)  
    jal ra, free
    
    
    # episode
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    addi sp, sp, 48

    ret
    
error_args_number:
    li a1, 89
    jal x0, exit2
error_malloc:
    li a1, 88
    jal x0, exit2