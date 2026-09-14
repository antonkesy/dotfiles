# make test / make dev in system/Arch; build context is the repo root
FROM archlinux:latest AS base

ARG USERNAME=ak
ARG UID=1000
ARG GID=1000

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# multilib: check mode cannot write pacman.conf
RUN printf '\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n' >> /etc/pacman.conf \
  && pacman -Syu --noconfirm \
  && pacman -S --noconfirm --needed sudo git make ansible \
  && ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime \
  && sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && locale-gen

RUN (groupdel "$(getent group ${GID} | cut -d: -f1)" 2>/dev/null || true) \
  && (userdel "$(getent passwd ${UID} | cut -d: -f1)" 2>/dev/null || true) \
  && groupadd -g ${GID} ${USERNAME} \
  && useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME}

FROM base AS ci
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME}
COPY --chown=${UID}:${GID} . /home/${USERNAME}/Projects/dotfiles
USER ${USERNAME}
WORKDIR /home/${USERNAME}/Projects/dotfiles

FROM base AS dev
RUN echo "${USERNAME}:toor" | chpasswd \
  && echo "${USERNAME} ALL=(ALL) ALL" > /etc/sudoers.d/${USERNAME}
USER ${USERNAME}
WORKDIR /home/${USERNAME}/Projects/dotfiles
CMD ["bash"]
