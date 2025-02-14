# Define the compiler
CC = gcc
CFLAGS = -fno-builtin -g
LDFLAGS = -lc

# Define the source and output files
SRC = stdlib_demo.s
OUT = stdlib_demo

# Default target
all: $(OUT)

# Rule to assemble the program
$(OUT): $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(OUT) $(LDFLAGS)

# Clean rule to remove generated files
clean:
	rm -f $(OUT)
