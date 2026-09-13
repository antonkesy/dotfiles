# Always on: every user-level CLI tool, on every distro. Filesystem tools,
# firmware, daemons and anything that only works as root stay in system/Arch (ansible).
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

  # Socket $XDG_RUNTIME_DIR/ssh-agent, which home/.config/zsh/path.zsh and
  # home/.config/hypr/hyprland.lua export.
  services.ssh-agent.enable = true;
}
