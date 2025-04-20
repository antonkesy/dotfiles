FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN apt-get update && apt-get install -y git locales tzdata sudo

WORKDIR /home/root/

RUN mkdir -p ~/.ssh/
RUN ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
COPY . /home/root/dotfiles

CMD ["bash"]
