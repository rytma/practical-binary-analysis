CC := gcc
AS := nasm
OBJ := xor_encrypt heapoverflow heapcheck.so elfinject hello.bin

.PHONY: all clean

all: $(OBJ)

xor_encrypt: xor_encrypt.c
	$(CC) -o $@ $<

heapoverflow: heapoverflow.c
	$(CC) -o $@ -O2 -fno-builtin $<

heapcheck.so: heapcheck.c
	$(CC) -o $@ -fPIC -shared -D_GNU_SOURCE $< -ldl

elfinject: elfinject.c
	$(CC) -o $@ -O2 $< -lelf

hello.bin: hello.s
	$(AS) -f bin -o $@ $<

clean:
	rm $(OBJ)
