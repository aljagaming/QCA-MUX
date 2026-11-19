#!/bin/bash

set -e

file_name=$(basename "$1" .ps)

ps2pdf -q "$file_name.ps" "$file_name.pdf" > /dev/null 2>&1
rm "$file_name.ps"

pdfcrop "$file_name.pdf" "$file_name.pdf"

pdftoppm -png -r 1200 "$file_name.pdf" "$file_name"

rm "$file_name.pdf"
