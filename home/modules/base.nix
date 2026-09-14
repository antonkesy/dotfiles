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

  # No services.ssh-agent: gpg-agent serves the ssh socket as well (git.nix),
  # so one pam_gnupg preset at login unlocks the signing key and the ssh keys.
}
