#!/bin/bash

for i in {1..16}
do
    j=$(($i+1))
    echo -n $(./test$i | egrep ", \"" | cut -d '"' -f 2 >> flag)
    ./test$i > test$j.cpp
    g++ test$j.cpp -o test$j
done
echo -n "flag: "
cat flag
