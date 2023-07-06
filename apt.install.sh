#!/bin/bash
input="./apt.list"

while IFS= read -r line
do
  sudo apt install "$line" -y
done < "$input"
