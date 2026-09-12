# fonts.fontconfig.enable writes ~/.config/fontconfig/conf.d/10-hm-fonts.conf,
# so host-built apps on Arch/Ubuntu find these too. On NixOS the system side
# only keeps fonts.enableDefaultPackages.
{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.ak.desktop.enable {
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
    nerd-fonts.caskaydia-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
    nerd-fonts.symbols-only
    jetbrains-mono
    fira-code
    fira-mono
    fira-sans
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    liberation_ttf # also covers ttf-croscore (metric-compatible)
    dejavu_fonts
    ubuntu-classic
    corefonts # ttf-ms-fonts (unfree)
  ];
}
