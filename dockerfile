FROM ubuntu:latest

WORKDIR /home/root/workspaces

RUN apt-get update && apt-get install -y git
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
RUN git clone --recursive https://github.com/antonkesy/dotfiles.git && cd dotfiles && ./link.sh
RUN cd dotfiles

CMD ["bash"]
