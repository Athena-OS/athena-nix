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
    rev = "8bb96e6a855293778e44c3196b7bcc38edbaedc1";
    hash = "sha256-IuOqkB6VN4CgmGqqEvzLR2vnmxjI8PAFHUhibCRTUow=";
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
