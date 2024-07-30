{
  lib,
  fetchPypi,
  python3,
  python3Packages,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "NAME";
  version = "VERSION";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-H10GiPyAvX6UVM5by4TqW+z6tcwPqskMnTML3BWJdVU=";
  };

  nativeBuildInputs = with python3Packages; [ setuptools ];

  propagatedBuildInputs = with python3Packages; [
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
