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
    rev = "e116417789031d87421e6c564bb8d3d52f757392";
    hash = "sha256-C9m2SZlTE82ofhtkPoeMOgKAvGvoeIH8Dmr/w8qjqLI=";
  };

  cargoHash = "sha256-O5dLVFuS3NQL/pC+nXdlRHY8ChBV1A//ImkP4/bCG8w=";

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