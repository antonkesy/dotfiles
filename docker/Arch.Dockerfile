ARG BASE_IMAGE=archlinux:latest
FROM ${BASE_IMAGE} AS base

ARG USERNAME=ak
ARG UID=1000
ARG GID=1000
ARG IS_DOCKER_BUILD=true

ENV TZ=Etc/UTC
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Install sudo
RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm --needed sudo

# Set timezone (skip hwclock)
RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime

# Generate locale
RUN sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && locale-gen

FROM base AS ci
# Create user (handle existing GID/UID) with sudo privileges WITHOUT password
RUN (groupdel $(getent group ${GID} | cut -d: -f1) 2>/dev/null || true) \
  && (userdel $(getent passwd ${UID} | cut -d: -f1) 2>/dev/null || true) \
  && groupadd -g ${GID} ${USERNAME} \
  && useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME} \
  && echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} \
  && chmod 440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}

COPY --chown=${USERNAME}:${USERNAME} . /home/${USERNAME}/workspace/dotfiles
WORKDIR /home/${USERNAME}/workspace/dotfiles

FROM base AS dev
# Create user (handle existing GID/UID) with sudo privileges WITH password
RUN (groupdel $(getent group ${GID} | cut -d: -f1) 2>/dev/null || true) \
  && (userdel $(getent passwd ${UID} | cut -d: -f1) 2>/dev/null || true) \
  && groupadd -g ${GID} ${USERNAME} \
  && useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME} \
  && echo "${USERNAME}:toor" | chpasswd \
  && echo "${USERNAME} ALL=(ALL) ALL" > /etc/sudoers.d/${USERNAME} \
  && chmod 440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}

COPY --chown=${USERNAME}:${USERNAME} . /home/${USERNAME}/workspace/dotfiles
WORKDIR /home/${USERNAME}/workspace/dotfiles

CMD ["bash"]
