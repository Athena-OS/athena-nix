{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
, coreutils
, gzip
}:

rustPlatform.buildRustPackage {
  pname = "cyber-toolnix";
  version = "0-unstable-2024-04-25";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "cyber-toolnix";
    rev = "5b6c24a88ef5d1ac255fe5100f21f9d0f9fa8d23";
    hash = "sha256-b02yi0svqZ+lmYkTRN/UM/KL1hKINGFch3H4LcuyeWg=";
  };

  cargoHash = "sha256-gROuQlqHCFG30tb63HxXkpHw4h8/EBNLTdEE6YTNeik=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  propagateBuildInputs = [
    coreutils
    gzip
  ];

  postPatch = ''
    substituteInPlace src/utils.rs \
      --replace "\"base64\"" "\"${coreutils}/bin/base64\"" \
      --replace "\"gunzip\"" "\"${gzip}/bin/gunzip\""
  '';

  meta = with lib; {
    description = "Set your Cyber Security role";
    mainProgram = "cyber-toolnix";
    homepage = "https://github.com/Athena-OS/cyber-toolnix";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ d3vil0p3r ];
  };
}
