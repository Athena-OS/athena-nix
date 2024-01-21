{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
, openssl
}:

rustPlatform.buildRustPackage {
  pname = "athena-nix";
  version = "unstable-2024-01-21";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "aegis-nix";
    rev = "27eb346fdc42f4cbb59847b6d2fc29693a6cd3d5";
    hash = "sha256-77j9p9zEy18akbzBt7P6Q417Zm0Rc8zuU8759YwvCU0=";
  };

  cargoHash = "sha256-O5dLVFuS3NQL/pC+nXdlRHY8ChBV1A//ImkP4/bCG8w=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  propagatedBuildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "Aegis - secure, rust-based installer back-end for Athena OS";
    mainProgram = "athena-aegis";
    homepage = "https://github.com/Athena-OS/aegis-nix";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ d3vil0p3r ];
  };
}