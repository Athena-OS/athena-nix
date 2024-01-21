{ lib
, stdenv
, fetchFromGitHub
, pciutils
, bash
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "athena-config";
  version = "unstable-2024-01-12";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-config";
    rev = "de05e4111f95a354b53e417ab90db90cf6eeee2c";
    hash = "sha256-PFslrVxNteL/fyNZriT7oEMdqPpzFstICes0XOATCHE=";
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
    homepage = "https://github.com/Athena-OS/athena-config";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
})
