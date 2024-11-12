#! /bin/bash

input_file="testfile.txt"

sed -i '5,$ { /welcome/ s/give/learning/g }' "$input_file"
