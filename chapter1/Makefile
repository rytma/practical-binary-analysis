CC := gcc
OBJ := multiple_functions

.PHONY: all clean

all: $(OBJ)

multiple_functions: multiple_functions.c
	$(CC) -E -P multiple_functions.c > multiple_functions.i
	$(CC) -S -masm=intel multiple_functions.c
	$(CC) -c multiple_functions.c
	$(CC) multiple_functions.c -lm 
	cp a.out a.out.stripped
	strip --strip-all a.out.stripped
	@echo
	@echo "******* CREATED FILES *******"
	@echo "multiple_functions.i: preprocessed source"
	@echo "multiple_functions.s: assembly code"
	@echo "multiple_functions.o: object file"
	@echo "a.out               : binary executable"
	@echo "a.out.stripped      : stripped binary executable"
	@echo "******* CREATED FILES *******"
	@echo

clean:
	rm -f *.i *.o a.out a.out.stripped
