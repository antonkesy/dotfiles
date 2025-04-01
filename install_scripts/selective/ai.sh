#!/bin/bash

# https://ollama.com/download
curl -fsSL https://ollama.com/install.sh | sh

ollama pull gemma3:12b
