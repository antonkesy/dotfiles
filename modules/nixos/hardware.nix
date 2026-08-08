# Replaces tasks/hardware/{audio,bluetooth,webcam,logitech}.yml.
{ pkgs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # tasks/hardware/webcam.yml did `modprobe uvcvideo`.
  boot.kernelModules = [ "uvcvideo" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libva-vdpau-driver
    ];
  };

  # tasks/hardware/logitech.yml was never imported by site.yml, but litra needs
  # udev rules to work without sudo — solaar's module provides them properly.
  hardware.logitech.wireless.enable = true;

  environment.systemPackages = with pkgs; [
    # --- audio ---
    alsa-utils
    alsa-ucm-conf
    sof-firmware
    pavucontrol
    # --- bluetooth ---
    bluez
    bluez-tools
    bluetui
    # --- webcam ---
    v4l-utils
    guvcview
    libusb1
  ];
}
