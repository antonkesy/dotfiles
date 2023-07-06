#!/bin/bash
input="./pip.list"

while IFS= read -r line
do
  sudo pip install "$line"
done < "$input"
