with import <nixpkgs> {};
let 
  athena-welcome = pkgs.callPackage ./package.nix { };
in
  stdenv.mkDerivation rec {
    name = "env";
    
    buildInputs = [
      curl
      git
      nix
      athena-welcome
    ];
  }