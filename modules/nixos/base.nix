# Replaces tasks/core/base.yml, tasks/core/flatpak.yml, tasks/terminal/zsh.yml
# and tasks/misc/grub.yml (the /etc/default/grub copy).
{ pkgs, lib, ... }:
{
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 15;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true; # tasks/desktop/windows.yml
    configurationLimit = 20;
    # Old GRUB_GFXMODE=1920x1080 workaround for high-DPI menus lagging.
    # mkDefault so the qemu-vm profile can pick its own mode.
    gfxmodeEfi = lib.mkDefault "1920x1080";
    gfxmodeBios = lib.mkDefault "1920x1080";
  };
  boot.kernelParams = [ "noplymouth" ];

  services.upower.enable = true; # battery level

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.cpu.amd.updateMicrocode = true;

  programs.zsh.enable = true;
  programs.gnupg.agent.enable = true;
  programs.nix-ld.enable = true; # run the odd unpatched binary

  services.openssh.enable = true;
  services.smartd.enable = true;
  services.fstrim.enable = true;

  services.flatpak.enable = true; # tasks/core/flatpak.yml

  # Filesystem support: dosfstools/exfatprogs/ntfs-3g/btrfs/xfs/mdadm/lvm2.
  boot.supportedFilesystems = [
    "ntfs"
    "exfat"
    "btrfs"
    "xfs"
  ];
  services.lvm.enable = true;

  environment.systemPackages = with pkgs; [
    # --- core ---
    git
    git-lfs
    vim
    less
    wget
    curl
    rsync
    xz
    zstd
    zip
    unzip
    p7zip
    jq
    gnupg
    cacert
    stdenv.cc # base-devel equivalent: gcc + binutils
    gnumake
    pkg-config

    # --- network ---
    dnsutils # bind-tools
    nftables
    ipset
    ethtool
    iperf3
    openssh
    sshfs
    rclone
    cifs-utils # smbclient
    samba

    # --- filesystems / disks ---
    dosfstools
    exfatprogs
    ntfs3g
    btrfs-progs
    xfsprogs
    mdadm
    lvm2
    smartmontools
    hdparm

    # --- hardware inspection ---
    pciutils
    usbutils
    lm_sensors
    acpi
    linuxPackages.cpupower

    # --- process / debug ---
    strace
    lsof
    psmisc
    htop
    btop
    atop
    sysstat

    # --- docs ---
    man-pages
    man-pages-posix

    # --- graphics userspace ---
    mesa
    libva-utils
    intel-media-driver
  ];

  documentation.dev.enable = true;
}
