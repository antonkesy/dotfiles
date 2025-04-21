FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN apt-get update && apt-get install -y git locales tzdata sudo build-essential

WORKDIR /home/root/

COPY . /home/root/dotfiles

CMD ["bash"]
