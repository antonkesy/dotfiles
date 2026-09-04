# AUR `webots-bin`. Not in nixpkgs.
#
# ponytail: buildFHSEnv, not autoPatchelfHook. Upstream ships a 3 GB prebuilt
# tree with its own Qt, OpenEXR, OpenAL and ICU, and some of those bundled libs
# reference siblings the tarball does not actually contain (libImath-2_5.so.25).
# Patching that tree is a losing game; give it an FHS root and move on.
{
  lib,
  stdenvNoCC,
  fetchurl,
  buildFHSEnv,
  makeDesktopItem,
  copyDesktopItems,
}:
let
  version = "R2025a";

  webots-tree = stdenvNoCC.mkDerivation {
    pname = "webots-tree";
    inherit version;

    src = fetchurl {
      url = "https://github.com/cyberbotics/webots/releases/download/${version}/webots-${version}-x86-64.tar.bz2";
      hash = "sha256-xRJ/tCBsV6WuVSPxt/Pai2cLyJJtmuCFleE58ibzjDg=";
    };

    dontBuild = true;
    dontConfigure = true;
    dontFixup = true; # nothing in this tree is meant to be patched

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r . $out/
      runHook postInstall
    '';
  };

  desktopItem = makeDesktopItem {
    name = "webots";
    desktopName = "Webots";
    comment = "Open source robot simulator";
    exec = "webots %f";
    icon = "webots";
    terminal = false;
    categories = [
      "Development"
      "Science"
      "Education"
    ];
  };
in
buildFHSEnv {
  pname = "webots";
  inherit version;

  targetPkgs =
    pkgs: with pkgs; [
      # graphics
      libGL
      libGLU
      libglvnd
      mesa
      libdrm
      wayland
      libxkbcommon
      # x11
      libx11
      libxext
      libxrender
      libxi
      libxrandr
      libxcursor
      libxcomposite
      libxdamage
      libxfixes
      libxtst
      libxcb
      libxcb-util
      libxcb-image
      libxcb-keysyms
      libxcb-render-util
      libxcb-wm
      libsm
      libice
      # audio
      alsa-lib
      libpulseaudio
      sndio
      # misc runtime
      glib
      gtk3
      gdk-pixbuf
      pango
      cairo
      atk
      at-spi2-core
      dbus
      fontconfig
      freetype
      zlib
      libxml2
      libxslt
      libgcrypt
      libgpg-error
      libssh
      openssl
      libjpeg
      libpng
      libtiff
      ffmpeg
      nss
      nspr
      cups
      expat
      pciutils
      python3
      gcc-unwrapped.lib
    ];

  # webots' own launcher lives inside the tree.
  runScript = "${webots-tree}/webots";

  profile = ''
    export WEBOTS_HOME=${webots-tree}
    export LD_LIBRARY_PATH=${webots-tree}/lib/webots''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
    export QT_PLUGIN_PATH=${webots-tree}/lib/webots/qt/plugins
  '';

  extraInstallCommands = ''
    install -Dm644 ${webots-tree}/resources/icons/core/webots.png \
      $out/share/icons/hicolor/128x128/apps/webots.png
  '';

  nativeBuildInputs = [ copyDesktopItems ];
  desktopItems = [ desktopItem ];

  meta = {
    description = "Open source robot simulator";
    homepage = "https://cyberbotics.com";
    license = lib.licenses.asl20;
    mainProgram = "webots";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
