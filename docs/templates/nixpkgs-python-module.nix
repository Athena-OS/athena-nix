# https://nixos.org/manual/nixpkgs/unstable/#python
{
  lib,
  buildPythonPackage,
  callPackage,
  fetchPypi,
  # fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,

  # build-system
  setuptools,

  # dependencies
  cachecontrol,
  lxml-html-clean,
  requests,
  six,

  # optional-dependencies
  rich,
}:

buildPythonPackage rec {
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

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "NAME" ];

  build-system = [ setuptools ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  dependencies = [
    cachecontrol
    lxml-html-clean
    requests
    six
    whatever
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  optional-dependencies = {
    rich = [ rich ];
  };

  # check in passthru.tests.pytest to escape infinite recursion on pytest
  # doCheck = false;

  meta = {
    changelog = "https://github.com/NAME/REPO/blob/${version}/CHANGELOG.md";
    description = "Short description";
    homepage = "HOMEPAGE URL";
    license = lib.licenses.whatever; # https://github.com/NixOS/nixpkgs/blob/master/lib/licenses.nix
    maintainers = with lib.maintainers; [ whatever ]; # https://github.com/NixOS/nixpkgs/tree/master/maintainers
  };
}
