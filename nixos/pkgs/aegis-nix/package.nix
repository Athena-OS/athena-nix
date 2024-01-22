{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
, openssl
}:

rustPlatform.buildRustPackage {
  pname = "athena-nix";
  version = "unstable-2024-01-22";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "aegis-nix";
    rev = "9b9b5f5646cac763fd8bb86ba8bf012099263fb7";
    hash = "sha256-ZYio0KESZk94/bG6NEnVATu+ZYXtGTb6RkpyDRCLPBA=";
  };

  cargoHash = "sha256-cm8/tfcjU1is6dQVoZHRyFHKSVWreRDmohb8SI1q4Tc=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  postPatch = ''
    substituteInPlace src/functions/users.rs \
      --replace "\"openssl\"" "\"${openssl}/bin/openssl\""
  '';

  meta = with lib; {
    description = "Aegis - secure, rust-based installer back-end for Athena OS";
    mainProgram = "athena-aegis";
    homepage = "https://github.com/Athena-OS/aegis-nix";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ d3vil0p3r ];
  };
}