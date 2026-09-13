# Docker clients. The daemon, the docker group and nvidia-container-toolkit
# are system-side (system/Arch). The cli-plugins links make `docker compose` and
# `docker buildx` resolve against a distro-installed docker too.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    docker-compose
    docker-buildx
    lazydocker
  ];

  home.file = {
    ".docker/cli-plugins/docker-compose".source = "${pkgs.docker-compose}/bin/docker-compose";
    ".docker/cli-plugins/docker-buildx".source = "${pkgs.docker-buildx}/bin/docker-buildx";
  };
}
