{ lib
, fetchFromGitHub
, runtimeShell
, python3
, gobject-introspection
, libwnck
, glib
, gtk3
, python3Packages
, wrapGAppsHook
}:

python3Packages.buildPythonApplication {
  pname = "athena-welcome";
  version = "0-unstable-2024-04-24";

  src = fetchFromGitHub {
    owner = "Athena-OS";
    repo = "athena-welcome";
    rev = "347a620cc4fe2a45c103703d801ad6468b1b56eb";
    hash = "sha256-M1ncs5hcqjebFYthLQa+SVlaqYz0sv1XkPXAFAamQT8=";
  };

  format = "other";
  
  nativeBuildInputs = [ gobject-introspection wrapGAppsHook ];
  buildInputs = [ glib gtk3 libwnck ];
  propagatedBuildInputs = with python3Packages; [ pygobject3 ];

  makeWrapperArgs = [
    "--set GI_TYPELIB_PATH \"$GI_TYPELIB_PATH\""
  ];

  postPatch = ''
    substituteInPlace share/applications/athena-welcome.desktop \
      --replace /usr/bin/athena-welcome $out/bin/athena-welcome
    substituteInPlace autostart/athena-welcome.desktop \
      --replace /usr/bin/athena-welcome $out/bin/athena-welcome
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/applications,share/athena-welcome,share/icons/hicolor/scalable/apps}
    cp -r share/applications/athena-welcome.desktop $out/share/applications/athena-welcome.desktop
    cp -r share/athena-welcome/* $out/share/athena-welcome/
    cp -r share/icons/hicolor/scalable/apps/athenaos-hello.svg $out/share/icons/hicolor/scalable/apps/
    makeWrapper ${python3}/bin/python $out/bin/athena-welcome \
      --add-flags "$out/share/athena-welcome/athena-welcome.py" \
      --prefix PYTHONPATH : "$PYTHONPATH"
    runHook postInstall
  '';

  postInstall = ''
    install -Dm644 autostart/athena-welcome.desktop $out/etc/xdg/autostart/athena-welcome.desktop
  '';

  meta = with lib; {
    description = "Athena Welcome application";
    mainProgram = "athena-welcome";
    homepage = "https://github.com/Athena-OS/athena-welcome";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
  };
}
