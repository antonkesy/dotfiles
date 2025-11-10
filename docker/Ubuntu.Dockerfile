ARG BASE_IMAGE=ubuntu:latest
FROM ${BASE_IMAGE} AS base

ARG UID=1000
ARG GID=1000
ARG USERNAME=ak
ARG IS_DOCKER_BUILD=true

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update -y && apt-get install -y git locales tzdata sudo build-essential

# Create user (handle existing GID/UID)
RUN (groupdel $(getent group ${GID} | cut -d: -f1) 2>/dev/null || true) \
    && (userdel $(getent passwd ${UID} | cut -d: -f1) 2>/dev/null || true) \
    && groupadd -g ${GID} ${USERNAME} \
    && useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USERNAME}

WORKDIR /home/${USERNAME}

FROM base AS minimum
COPY --chown=${USERNAME} . /home/${USERNAME}/dotfiles

FROM minimum AS test
CMD ["bash"]
