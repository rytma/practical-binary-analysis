CXX := g++
OBJ := basic_capstone_linear

.PHONY: all clean

all: loader.o $(OBJ)

loader.o: ../inc/loader.cc
	$(CXX) -std=c++11 -c ../inc/loader.cc

basic_capstone_linear:
	$(CXX) -std=c++11 -o basic_capstone_linear basic_capstone_linear.cc loader.o -lbfd -lcapstone

clean:
		rm -r $(OBJ) *.o
