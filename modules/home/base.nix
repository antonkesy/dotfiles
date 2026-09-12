# Always on: the user-level half of what used to be environment.systemPackages
# in the NixOS base module. Filesystem tools, firmware, daemons and anything
# that needs root stay in ../setup.
{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    wget
    curl
    rsync
    xz
    zstd
    zip
    unzip
    p7zip
    jq

    dnsutils
    iperf3
    sshfs
    rclone

    strace
    lsof
    psmisc
    htop
    btop
    atop
    sysstat

    pciutils
    usbutils
    lm_sensors
    acpi
  ];

  # Same unit name and socket ($XDG_RUNTIME_DIR/ssh-agent, see
  # home/.config/zsh/path.zsh) as NixOS' programs.ssh.startAgent, which
  # ../setup enables; on NixOS the system unit must not be shadowed.
  services.ssh-agent.enable = !config.ak.nixos;
}
