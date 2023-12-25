FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN apt-get update && apt-get install -y git locales tzdata

WORKDIR /home/root/

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
RUN git clone --recursive https://github.com/antonkesy/dotfiles.git # && cd dotfiles && ./link.sh && ./install_scripts/non_interactive.sh

CMD ["bash"]
