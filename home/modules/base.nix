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

    dnsutils
    iperf3
    sshfs
    rclone

    strace
    lsof
    psmisc
    htop
    sysstat

    pciutils
    usbutils
    lm_sensors
    acpi
  ];
}
