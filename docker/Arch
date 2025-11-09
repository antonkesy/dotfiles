ARG BASE_IMAGE=archlinux:latest
FROM ${BASE_IMAGE} AS base

ARG USERNAME=ak
ARG UID=1000
ARG GID=1000

ARG USERNAME=ak
ARG IS_DOCKER_BUILD=true

ENV TZ=Etc/UTC
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Initialize keyring, upgrade, install essentials
RUN pacman-key --init \
    && pacman-key --populate archlinux \
    && pacman -Syu --noconfirm \
    && pacman -S --noconfirm --needed \
       base-devel git sudo zsh tzdata \
    && pacman -Scc --noconfirm

# Set timezone (skip hwclock)
RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime

# Generate locale
RUN sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen

# Create user (handle existing GID/UID)
RUN (groupdel $(getent group ${GID} | cut -d: -f1) 2>/dev/null || true) \
    && (userdel $(getent passwd ${UID} | cut -d: -f1) 2>/dev/null || true) \
    && groupadd -g ${GID} ${USERNAME} \
    && useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USERNAME}
WORKDIR /home/${USERNAME}

FROM base AS minimum
COPY --chown=${USERNAME}:${USERNAME} . /home/${USERNAME}/dotfiles

FROM minimum AS test
CMD ["bash"]

FROM minimum AS demo
RUN bash -c "cd /home/${USERNAME}/dotfiles && make install_base install_auto && zsh"
