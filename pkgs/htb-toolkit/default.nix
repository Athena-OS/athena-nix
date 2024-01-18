{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
, coreutils
, noto-fonts-color-emoji
, gnome
, libsecret
, bash
, openvpn
, nerdfonts
}:

rustPlatform.buildRustPackage rec {
  pname = "htb-toolkit";
  version = "unstable-2024-01-17";

  src = fetchFromGitHub {
    owner = "D3vil0p3r";
    repo = "htb-toolkit";
    rev = "54e11774ea8746ea540548082d3b25c22306b4fc";
    hash = "sha256-QYUqdqFV9Qn+VbJTnz5hx5I0XV1nrzCoCKtRS7jBLsE=";
  };

  cargoHash = "sha256-XDE6A6EIAUbuzt8Zb/ROfDAPp0ZyN0WQ4D1gWHjRVhg=";

  patchPhase = ''
    runHook prePatch
    patch -p1 < ${./main.patch}
    patch -p1 < ${./manage.patch}
    patch -p1 < ${./play.patch}
    patch -p1 < ${./types.patch}
    patch -p1 < ${./utils.patch}
    runHook postPatch
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  propagateBuildInputs = [
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    coreutils
    noto-fonts-color-emoji
    gnome.gnome-keyring
    libsecret
    openvpn
  ];

  postPatch = ''
    substituteInPlace src/manage.rs \
      --replace /usr/share/htb-toolkit/icons/ $out/share/htb-toolkit/icons/
    substituteInPlace src/utils.rs \
      --replace /usr/bin/bash ${bash}
    substituteInPlace src/appkey.rs \
      --replace secret-tool ${lib.getExe libsecret}
    substituteInPlace src/vpn.rs \
      --replace "arg(\"openvpn\")" "arg(\"${openvpn}/bin/openvpn\")"
  '';

  meta = with lib; {
    description = "Play Hack The Box directly on your system";
    homepage = "https://github.com/D3vil0p3r/htb-toolkit";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ d3vil0p3r ];
    mainProgram = "htb-toolkit";
  };
}