# Stack should not be executable
.section .note.GNU-stack, "", @progbits

# Data section for global constants
.section .data
    malloc_failed_err_msg:
        .asciz  "Malloc failed to allocate space on the heap."
    fgets_failed_err_msg:
        .asciz  "Fgets failed due to an error or EoF occured while no characters were read."

.section .text
    .globl  main
    .type	main, @function
    .extern puts
    .extern fgets
    .extern malloc
    .extern free
    .extern exit
    .extern stdin
    .extern stdout

# Handles exit if malloc fails to allocate space on the heap
malloc_failed:
    leaq    malloc_failed_err_msg(%rip), %rdi
    call    puts
    movb    $1, %dil
    call    exit

# Handles exit if fgets fails
fgets_failed:
    leaq    fgets_failed_err_msg(%rip), %rdi
    call    puts
    movb    $2, %dil
    call    exit

# Reads input from user and prints it back to stdout
echo_input_to_stdout:
    pushq   %rbp
    movq    %rsp, %rbp

    # Allocate a 64-byte buffer on the heap with malloc 
    movq    $64, %rdi
    call    malloc

    # Test if malloc failed
    testq   %rax, %rax
    jz      malloc_failed

    # Save the buffer pointer on the stack
    pushq   %rax
    # Align the stack on a 16-byte boundary before calling fgets
    subq    $8, %rsp

    # Prepare arguments for fgets
    movq    %rax, %rdi
    movq    $64, %rsi
    movq    stdin(%rip), %rdx
    # Read input from the user using fgets
    call    fgets

    # Test if fgets failed
    testq   %rax, %rax
    jz      fgets_failed

    # Restore the pointer to the buff from stack
    movq    8(%rsp), %rdi
    # Print the input of the user back to stdout
    call    puts

    # Restore the pointer to the buff from stack and free the space
    movq    8(%rsp), %rdi
    call    free

    leave
    ret

main:
    # Prologue
    pushq   %rbp
    movq    %rsp, %rbp

    call    echo_input_to_stdout

    # Return 0 from main
    xorq    %rax, %rax
    leave
    ret
