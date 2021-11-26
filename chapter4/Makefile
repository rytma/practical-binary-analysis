CXX := g++
OBJ := loader_demo

.PHONY: all clean

all: loader.o $(OBJ)

loader.o: ../inc/loader.cc
	$(CXX) -std=c++11 -c ../inc/loader.cc

loader_demo:
	$(CXX) -std=c++11 -o loader_demo loader_demo.cc loader.o -lbfd

clean:
		rm -r $(OBJ) *.o
