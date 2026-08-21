# Replaces tasks/hardware/{fingerprint,dell-laptop}.yml.
# setup/manual/fingerprint.sh used `pam-auth-update` (Debian tooling that never
# worked on Arch); the PAM wiring below is the real thing.
{ pkgs, ... }:
{
  services.fprintd.enable = true;
  # Scoped to sudo/hyprlock only, not the login screen itself.
  security.pam.services = {
    sudo.fprintAuth = true;
    hyprlock.fprintAuth = true;
  };

  # ponytail: power-profiles-daemon rather than tlp — DankMaterialShell's NixOS
  # module already enables it and drives it from the bar, and the two conflict.
  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;
  powerManagement.enable = true;

  environment.systemPackages = with pkgs; [
    dell-command-configure
    powertop
    acpi
    brightnessctl
  ];
}
