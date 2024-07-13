{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gnome,
  sassc,
  gnome-themes-extra,
  gtk-engine-murrine,
  colorVariants ? [ ],
  sizeVariants ? [ ],
  themeVariants ? [ ],
  tweakVersions ? [ ],
  iconVariants ? [ ],
}:

let
  pname = "matrix-gtk-theme";
  colorVariantList = [
    "dark"
    "light"
  ];
  sizeVariantList = [
    "compact"
    "standard"
  ];
  themeVariantList = [
    "default"
    "green"
    "grey"
    "orange"
    "pink"
    "purple"
    "red"
    "teal"
    "yellow"
    "all"
  ];
  tweakVersionList = [
    "neo"
    "trinity"
    "black"
    "float"
    "outline"
    "macos"
  ];
  iconVariantList = [
    "Dark"
    "Light"
  ];
in
lib.checkListOfEnum "${pname}: colorVariants" colorVariantList colorVariants lib.checkListOfEnum
  "${pname}: sizeVariants"
  sizeVariantList
  sizeVariants
  lib.checkListOfEnum
  "${pname}: themeVariants"
  themeVariantList
  themeVariants
  lib.checkListOfEnum
  "${pname}: tweakVersions"
  tweakVersionList
  tweakVersions
  lib.checkListOfEnum
  "${pname}: iconVariants"
  iconVariantList
  iconVariants

  stdenvNoCC.mkDerivation
  {
    inherit pname;
    version = "0-unstable-2024-07-13";

    src = fetchFromGitHub {
      owner = "D3vil0p3r";
      repo = "Matrix-GTK-Theme";
      rev = "ed0383d64406b76215e128b09b1f066ae319795d";
      hash = "sha256-YXOei/+35jvykv596oP5zRbAC0WnE3vTITm3YpzPy2g=";
    };

    propagatedUserEnvPkgs = [ gtk-engine-murrine ];

    nativeBuildInputs = [
      gnome.gnome-shell
      sassc
    ];
    buildInputs = [ gnome-themes-extra ];

    dontBuild = true;

    postPatch = ''
      patchShebangs themes/install.sh
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/themes
      cd themes
      ./install.sh -n Matrix \
      ${lib.optionalString (colorVariants != [ ]) "-c " + toString colorVariants} \
      ${lib.optionalString (sizeVariants != [ ]) "-s " + toString sizeVariants} \
      ${lib.optionalString (themeVariants != [ ]) "-t " + toString themeVariants} \
      ${lib.optionalString (tweakVersions != [ ]) "--tweaks " + toString tweakVersions} \
      -d "$out/share/themes"
      cd ../icons
      ${lib.optionalString (iconVariants != [ ]) "mkdir -p $out/share/icons"}
      ${lib.optionalString (iconVariants != [ ]) "cp -a " + toString iconVariants + " $out/share/icons/"}
      runHook postInstall
    '';

    meta = with lib; {
      description = "GTK theme based on the Matrix colour palette";
      homepage = "https://github.com/D3vil0p3r/Matrix-GTK-Theme";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [ d3vil0p3r ];
      platforms = platforms.unix;
    };
  }
