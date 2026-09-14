# Docker clients; the daemon is system-side. cli-plugins links let a
# distro-installed docker find compose/buildx.
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
