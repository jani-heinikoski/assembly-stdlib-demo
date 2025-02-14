# Stack should not be executable
.section .note.GNU-stack, "", @progbits

# Data section for global constants
.section .data
    malloc_failed_err_msg:
        .asciz  "Malloc failed to allocate space on the heap."
    fgets_failed_err_msg:
        .asciz  "Fgets failed due to an error or EoF occured while no characters were read."
    arg_was_null_err_msg:
        .asciz  "Argument buffer was null."       
    ask_for_input_msg:
        .asciz  "Please give some input (max. %d characters): "
    your_input_msg:
        .asciz  "Your input was: "
    max_characters:
        .quad   8

.section .text
    .globl  main
    .type   main, @function
    .extern puts # int puts(const char *s);
    .extern printf # int printf(const char *restrict format, ...);
    .extern fgets # char *fgets(char s[restrict .size], int size, FILE *restrict stream);
    .extern malloc # void *malloc(size_t size);
    .extern free # void free(void *_Nullable ptr);
    .extern exit # [[noreturn]] void exit(int status);
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

argument_buffer_was_null:
    leaq    arg_was_null_err_msg(%rip), %rdi
    call    puts
    movb    $3, %dil
    call    exit

# Asks the user to give input to stdin
ask_user_for_input:
    # Prologue
    pushq   %rbp
    movq    %rsp, %rbp
    
    # Prepare arguments for printf
    leaq    ask_for_input_msg(%rip), %rdi
    movq    max_characters(%rip), %rsi
    # Printf uses varargs -> need to specify 0 arguments in vector registers
    xorq    %rax, %rax
    # Ask the user for input
    call    printf

    # Epilogue
    leave
    ret

# Reads input from user from stdin
get_input_from_stdin:
    # Prologue
    pushq   %rbp
    movq    %rsp, %rbp

    # Allocate a (max_characters + 2)-byte buffer on the heap with malloc
    movq    max_characters(%rip), %rdi
    addq    $2, %rdi
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

    # Epilogue
    leave
    ret

print_output_to_stdout:
    # Prologue
    pushq   %rbp
    movq    %rsp, %rbp
    
    # Null-check the argument buffer
    testq   %rdi, %rdi
    jz      argument_buffer_was_null

    # Save the argument buffer to stack
    subq    $8, %rsp
    pushq   %rdi

    # Prepare arguments for printf
    leaq    your_input_msg(%rip), %rdi
    # Printf uses varargs -> need to specify 0 arguments in vector registers
    xorq    %rax, %rax
    # Print your_input_msg to stdout
    call    printf

    # Print the given arg buffer to stdout
    popq    %rdi
    call    puts

    # Epilogue
    leave
    ret

main:
    # Prologue
    pushq   %rbp
    movq    %rsp, %rbp

    call    ask_user_for_input
    call    get_input_from_stdin
    # Save the returned ptr to the buffer on the stack + align stack
    pushq   %rax
    subq    $8, %rsp
    # Prepare arguments for print_output_to_stdout
    movq    %rax, %rdi
    call    print_output_to_stdout

    # Free the memory reserved on heap
    movq    8(%rsp), %rdi
    call    free

    # Epilogue - Return 0 from main
    xorq    %rax, %rax
    leave
    ret
