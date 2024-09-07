#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

input_dir=$1

# Check if the provided directory exists
if [ ! -d "$input_dir" ]; then
    echo "The directory '$input_dir' does not exist."
    exit 1
fi

# Find 'oriserve' directories inside the input directory and create 'test.txt' in them
find "$input_dir" -type d -name "oriserve" | while read dir; do
    echo "Creating test.txt in $dir"
    touch "$dir/test.txt"
done

echo "Operation complete."
