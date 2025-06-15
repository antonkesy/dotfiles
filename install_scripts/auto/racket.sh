#!/bin/bash

sudo snap install racket || echo "Error Okay; Snap not working in Docker"
sudo apt install -y graphviz
