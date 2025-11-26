#!/usr/bin/env bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: speedup input_file output_file"
    exit 1
fi

# Assign arguments to variables
INPUT_FILE="$1"
OUTPUT_FILE="$2"

# Ensure the output file ends with .mp3
if [[ "$OUTPUT_FILE" != *.mp3 ]]; then
    OUTPUT_FILE="${OUTPUT_FILE}.mp3"
fi

# Run the ffmpeg command
ffmpeg -i "$INPUT_FILE" -filter:a "atempo=1.8" -vn "$OUTPUT_FILE"

# Check if the command was successful
if [ $? -eq 0 ]; then
    echo "Conversion successful! Output saved to $OUTPUT_FILE"
else
    echo "An error occurred during the conversion."
    exit 1
fi
