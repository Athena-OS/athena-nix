{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
, openssl
}:

rustPlatform.buildRustPackage {
  pname = "aegis-nix";
  version = "unstable-2024-01-23";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "aegis-nix";
    rev = "e33466784088fa14c7ccc5d26971c1038cdcf8ba";
    hash = "sha256-jdTAkbccU+a7Qy5aYwrSo8ZnoiZujE6qLNSr3qxtG7w=";
  };

  cargoHash = "sha256-ToH10Yb0SuHHHBbKSwhYZEF2s+X4SeB/oNS3igCAKzY=";

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