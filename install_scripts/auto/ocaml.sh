#!/bin/bash

sudo apt-get install opam
opam init --auto-setup -n
opam switch create 5.3.0
opam install ocaml-lsp-server odoc ocamlformat utop -y
