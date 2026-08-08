# Replaces tasks/containers/{docker,virtualbox}.yml. The old playbook created
# the docker group by hand and never added the user to vboxusers; the NixOS
# options do both.
{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  users.users.ak.extraGroups = [
    "docker"
    "vboxusers"
  ];

  environment.systemPackages = with pkgs; [
    docker-compose
    docker-buildx
    lazydocker
  ];
}
