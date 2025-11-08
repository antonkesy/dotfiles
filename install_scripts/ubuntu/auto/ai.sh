#!/bin/bash

# https://ollama.com/download
curl -fsSL https://ollama.com/install.sh | sh

# won't work (without restart)/(in docker)
# export PATH=$PATH:/usr/.local/bin
# ollama pull gemma3:12b
