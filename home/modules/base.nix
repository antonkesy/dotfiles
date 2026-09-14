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
}
