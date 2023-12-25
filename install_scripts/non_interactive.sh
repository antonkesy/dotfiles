#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
NON_INTERACTIVE="${SCRIPT_DIR}/non_interactive/"

if [ ! -d "$NON_INTERACTIVE" ]; then
    echo "Directory '$NON_INTERACTIVE' does not exist."
    exit 1
fi

for script_file in "$NON_INTERACTIVE"*.sh; do
    if [ -f "$script_file" ]; then
        echo "Running script: $script_file"
        bash "$script_file"
    fi
done
