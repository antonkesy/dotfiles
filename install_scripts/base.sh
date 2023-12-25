#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

${SCRIPT_DIR}/base/python.sh
${SCRIPT_DIR}/base/misc.sh
${SCRIPT_DIR}/base/java.sh
${SCRIPT_DIR}/base/clang.sh
${SCRIPT_DIR}/base/c++.sh
${SCRIPT_DIR}/base/dotnet.sh
${SCRIPT_DIR}/base/flatpack.sh
${SCRIPT_DIR}/base/go.sh
${SCRIPT_DIR}/base/homebrew.sh
${SCRIPT_DIR}/base/rust.sh
${SCRIPT_DIR}/base/bazel.sh
