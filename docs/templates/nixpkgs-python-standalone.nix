{
  lib,
  fetchFromGitHub,
  python3,
  python3Packages,
  makeWrapper,
}:

python3Packages.buildPythonApplication rec {
  pname = "NAME";
  version = "VERSION";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "OWNER";
    repo = "REPO";
    rev = "v${version}";
    hash = "sha256-8MOpbyw4HEJMcv84bNkNLBSZfEmIm3RDSUi0s62t9ko=";
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = with python3Packages; [
    whatever
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/whatever}
    rm README.md requirements.txt LICENSE.md
    cp -a * $out/share/whatever/
    makeWrapper ${python3}/bin/python $out/bin/whatever \
      --add-flags "$out/share/whatever/NAME.py" \
      --prefix PYTHONPATH : ${python3Packages.makePythonPath propagatedBuildInputs}
    runHook postInstall
  '';

  meta = {
    description = "Short description";
    homepage = "HOMEPAGE URL";
    license = lib.licenses.whatever; # https://github.com/NixOS/nixpkgs/blob/master/lib/licenses.nix
    mainProgram = "PROGRAM";
    maintainers = with lib.maintainers; [ whatever ]; # https://github.com/NixOS/nixpkgs/tree/master/maintainers
    platforms = lib.platforms.whatever; # https://github.com/NixOS/nixpkgs/blob/master/lib/systems/platforms.nix
  };
}
