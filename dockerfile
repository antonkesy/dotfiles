FROM ubuntu:latest

WORKDIR /home/root/workspaces

RUN apt-get update && apt-get install -y git

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
RUN git clone --recursive https://github.com/antonkesy/dotfiles.git && cd dotfiles && ./link.sh

CMD ["bash"]
