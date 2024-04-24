{ lib
, stdenvNoCC
, fetchFromGitHub
, pciutils
, bash
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "athena-config-nix";
  version = "unstable-2024-04-24";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-config-nix";
    rev = "f558dcc861dbf6646f5e297149976ddb348ef5eb";
    hash = "sha256-iFp4xH3zvKMDOE2zKG3EAn5abZ7fBjDMWqvCyA9x7IU=";
  };

  buildInputs = [ pciutils ];

  postPatch = ''
    patchShebangs athena-motd shell-rocket troubleshoot
  '';

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp -r bin/* $out/bin/
    cp -r share/* $out/share/
  '';

  meta = with lib; {
    description = "Athena OS environment files";
    homepage = "https://github.com/Athena-OS/athena-config-nix";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
})
