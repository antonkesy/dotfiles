FROM ubuntu:latest

RUN apt-get update && apt-get install -y git
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales

WORKDIR /home/root/

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
RUN git clone --recursive https://github.com/antonkesy/dotfiles.git # && cd dotfiles && ./link.sh && ./install_scripts/non_interactive.sh

CMD ["bash"]
