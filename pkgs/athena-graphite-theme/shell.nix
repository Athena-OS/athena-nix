with import <nixpkgs> {};
let 
  athena-graphite-theme = pkgs.callPackage ./default.nix { };
in
  stdenv.mkDerivation rec {
    name = "env";
    
    buildInputs = [
      curl
      git
      nix
      perl
      athena-graphite-theme
    ];
  }
