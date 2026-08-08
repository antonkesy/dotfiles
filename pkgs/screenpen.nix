# pipx `screenpen` from tasks/development/dev-tools.yml. Not in nixpkgs.
# Built from git rather than the PyPI sdist: the sdist omits requirements.txt,
# which its own setup.py reads at build time.
{
  lib,
  python3Packages,
  fetchFromGitHub,
  qt5,
}:
python3Packages.buildPythonApplication {
  pname = "screenpen";
  version = "0.3.1-unstable-2025-01-12";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rsusik";
    repo = "screenpen";
    rev = "504907dd197a2382ff379380c424c84f94a3284a";
    hash = "sha256-rZLtzQ1gUDX+W76h6Ochcc0LWebRYHHQBfRO95lyYpY=";
  };

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];
  propagatedBuildInputs = with python3Packages; [
    pyqt5
    matplotlib
    numpy
  ];

  doCheck = false; # no test suite upstream

  meta = {
    description = "Screen annotation software which allows drawing directly on the screen";
    homepage = "https://rsusik.github.io/screenpen/";
    license = lib.licenses.mit;
    mainProgram = "screenpen";
    platforms = lib.platforms.linux;
  };
}
