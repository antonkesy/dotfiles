FROM ubuntu:latest

RUN apt-get update && apt-get install -y git

WORKDIR /dotfiles

RUN git clone --recursive https://github.com/antonkesy/dotfiles.git && cd dotfiles && ./link.sh

CMD ["bash"]
