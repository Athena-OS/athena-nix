{ lib
, stdenvNoCC
, fetchFromGitHub
, pciutils
, bash
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "athena-config-nix";
  version = "0-unstable-2024-07-19";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-config-nix";
    rev = "ee4ffc0677cc0d7a84b0d6c8f5f5e8560aeb6b93";
    hash = "sha256-D+uNiODp6N+TANpk55cJ50u8e5JZCXEzmJD3qyB9D+M=";
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
