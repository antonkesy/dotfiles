FROM ubuntu:latest AS dev

ARG USERNAME=ak
ARG IS_DOCKER_BUILD=true

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update -y && apt-get install -y git locales tzdata sudo build-essential

RUN groupadd -r ${USERNAME} && useradd -m -r -g ${USERNAME} ${USERNAME}
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USERNAME}

WORKDIR /home/${USERNAME}

FROM dev AS base
COPY --chown=${USERNAME} . /home/${USERNAME}/dotfiles

FROM base AS test
CMD ["bash"]

FROM base AS demo
RUN bash -c "cd /home/${USERNAME}/dotfiles && make install_all_auto && zsh"
