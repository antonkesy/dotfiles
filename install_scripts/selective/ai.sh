#!/bin/bash

# https://ollama.com/download
curl -fsSL https://ollama.com/install.sh | sh

ollama pull llama3.2
ollama pull codellama
ollama pull phi3
