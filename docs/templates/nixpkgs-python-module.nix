# https://nixos.org/manual/nixpkgs/unstable/#python
{
  lib,
  fetchPypi,
  python3,
  python3Packages,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "NAME";
  version = "VERSION";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-H10GiPyAvX6UVM5by4TqW+z6tcwPqskMnTML3BWJdVU=";
  };

  # Fetching from repo (e.g. GitHub) is preferred as published artifacts often don't include tests
  # src = fetchFromGitHub {
  #   owner = "OWNER";
  #   repo = "REPO";
  #   rev = "v${version}";
  #   hash = "sha256-8MOpbyw4HEJMcv84bNkNLBSZfEmIm3RDSUi0s62t9ko=";
  # };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    whatever
  ];

  meta = {
    description = "Short description";
    homepage = "HOMEPAGE URL";
    license = lib.licenses.whatever; # https://github.com/NixOS/nixpkgs/blob/master/lib/licenses.nix
    mainProgram = "PROGRAM";
    maintainers = with lib.maintainers; [ whatever ]; # https://github.com/NixOS/nixpkgs/tree/master/maintainers
    platforms = lib.platforms.whatever; # https://github.com/NixOS/nixpkgs/blob/master/lib/systems/platforms.nix
  };
}
