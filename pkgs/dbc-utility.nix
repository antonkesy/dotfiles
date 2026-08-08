# tasks/desktop/apps.yml cloned this, ran `uv run python scripts/build_linux.py`
# as root to make a PyInstaller bundle, copied it to /opt/DBCUtility and hand-wrote
# a .desktop file. It is a plain hatchling PyQt5 app, so none of that is needed —
# pyinstaller is dropped from the dependency list on purpose.
{
  lib,
  python3Packages,
  fetchFromGitHub,
  qt5,
  copyDesktopItems,
  makeDesktopItem,
}:
python3Packages.buildPythonApplication rec {
  pname = "dbc-utility";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "busaudit";
    repo = "dbcUtility";
    rev = "v${version}";
    hash = "sha256-D8pgIpdvUQ4BeYKtx+VxZTEqA5Rd3WO6HcEEnjQcHkM=";
  };

  build-system = [ python3Packages.hatchling ];

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    copyDesktopItems
  ];

  dependencies = with python3Packages; [
    pyqt5
    cantools
    qtawesome
  ];

  # Upstream pins pyinstaller as a runtime dep purely to build its own bundle.
  pythonRemoveDeps = [ "pyinstaller" ];

  doCheck = false;

  postInstall = ''
    install -Dm644 icons/dbc-utility.png \
      $out/share/icons/hicolor/256x256/apps/dbc-utility.png || true
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "dbc-utility";
      desktopName = "DBC Utility";
      comment = "View, edit and manage CAN DBC files";
      exec = "dbcUtility %f";
      icon = "dbc-utility";
      categories = [
        "Development"
        "Engineering"
      ];
    })
  ];

  meta = {
    description = "PyQt5 GUI for viewing, editing and managing CAN DBC files";
    homepage = "https://github.com/busaudit/dbcUtility";
    license = lib.licenses.gpl3Only;
    mainProgram = "dbcUtility";
    platforms = lib.platforms.linux;
  };
}
