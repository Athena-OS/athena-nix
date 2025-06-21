{ lib
, stdenvNoCC
, fetchFromGitHub
, pciutils
, bash
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "athena-config-nix";
  version = "0-unstable-2025-06-21";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-config-nix";
    rev = "853fc68ccfe31968fc6c2533e03c2a895d48d677";
    hash = "sha256-qP+k7mB05MLaDlQzVAlUAoCCpRCJ2tcxY6n5C3Ppce0=";
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
