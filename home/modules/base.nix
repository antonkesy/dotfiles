# Always on, every distro. Anything needing root is in system/Arch.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    less
    man-pages
    man-pages-posix

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

  # socket $XDG_RUNTIME_DIR/ssh-agent; zsh/path.zsh and hyprland.lua export it
  services.ssh-agent.enable = true;
}
