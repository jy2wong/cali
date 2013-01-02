#!/bin/bash

while read line; do
    echo $line
    echo $line | ./cali
    echo
done < in/test_cases1
