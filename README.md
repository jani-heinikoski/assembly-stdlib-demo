
# Calling functions in x86-64 assembly language

This small program is intended for educational purposes. It shows how the C standard library can be used in x86-64 assembly language. Listing of the C standard library functions used in the program:

- puts # int puts(const char *s);
- printf # int printf(const char *restrict format, ...);
- fgets # char *fgets(char s[restrict .size], int size, FILE *restrict stream);
- malloc # void *malloc(size_t size);
- free # void free(void *_Nullable ptr);
- exit # [[noreturn]] void exit(int status);




## Sequence diagram

![Program execution sequence diagram](https://github.com/jani-heinikoski/assembly-stdlib-demo/blob/main/docs/sequencediagram.png)


## Compile and run locally

Clone the project (HTTPS)

```bash
  git clone https://github.com/jani-heinikoski/assembly-stdlib-demo.git
```

Go to the project directory

```bash
  cd assembly-stdlib-demo
```

Compile the program using GNU make

```bash
  make
```

Run the executable

```bash
  ./stdlib_demo
```

## Assembly language specifications

**Instruction set architecture (ISA):** x86-64

**Kernel:** Linux

**Assembler:** GNU Assembler (GAS)

**Assembly language syntax:** AT&T
