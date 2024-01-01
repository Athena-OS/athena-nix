# Nix Packaging Guidelines

The purpose of this document is to provide guidelines to package tools following Nix best practices.

## Build packages

There are several ways to build local packages. What I'm currently using are `nix-build` and `nix-shell`.

### nix-build

Once you created your `package.nix`, you can use `nix-build` command to build your `package.nix` package file. The arguments of `niix-build` command can change according to the type of package we are trying to build.

In general, to build packages based on usual functions (like `mkDerivation`) require the usage of:
```sh
nix-build -E 'with import <nixpkgs> {}; callPackage ./package.nix {}'
```

For specific cases, like the usage of `buildPythonPackage` function, it is required to use:
```sh
nix-build -E 'with import <nixpkgs> {}; python3Packages.callPackage ./package.nix {}'
```

## Dependencies

Dependencies can be used by the following expressions:
* nativeBuildInputs: dependencies that should exist in the build environment
* buildInputs: dependencies that should exist in the runtime environment
* propagatedBuildInputs:  dependencies that should exist in the runtime environment and also propagated to downstream runtime environments. Usually used in Python packages

All dependencies used in **buildInputs** allow to link header and lib files correctly during the compilation of a tool.

## mkDerivation

This function automatically compiles source files if a **Makefile** exists. It means that we don't need to specify `make` commands in `buildPhase` or `installPhase`. Indeed, often it is not necessary to write any build instructions because the stdenv build system is based on autoconf, which automatically detected the structure of the project directory. We need only to eventually set make flags if needed. Use `makeFlags` to specify flags used on each phase or `buildFlags` to specify flags to be used only during the `buildPhase`.

For example, if `Makefile` is not in the root directory of the project source, you can instruct mkDerivation to find Makefile by:
```nix
  makeFlags = [
    "-C src"
  ];
```

Add `enableParallelBuilding = true;` to enable parallel building.

Only in case where the structure of the project does not allow to run autoconf process correctly, then we could be forced to write some code in some of nix phases.

### Usage of hooks

#### autoconf

In case your source project contains **configure** files, you can import **autoreconfHook** and use it as:
```nix
nativeBuildInputs = [autoreconfHook];
```
In this manner, it simulates the usage of `autoreconf` command and compile and install the tool.

In case the building produces an error due to, for example, obsolete macros that interrupts the autoconf process, try to use **configure** approach described in the next section.

#### configure

In case the **autoconf** method does not work, try to use this approach.

Some source files use **configure** file during compilation. This file can use arguments as `build` for cross-platform building, `host` and `target`.

Instead to write `./configure --build=arm --prefix=$out` in `buildPhase`, you can use:
```nix
configurePlatforms = [ "build" ];
```
Along with it, `configureFlags` can be used for adding additional flags. In this example we don't add the flag `--prefix=$out` because in Nix the default value of `--prefix` is already `$out`.

### Syntax

When using **mkDerivation** in a `.nix` package file, and its variables need to be used in other elements, instead of using `rec` you can use `finalAttrs`, as the following example:
```nix
  stdenv.mkDerivation (finalAttrs: {
    pname = "maltego";
    version = "4.6.0";
  
    src = fetchzip {
      url = "https://downloads.maltego.com/maltego-v4/linux/Maltego.v${finalAttrs.version}.linux.zip";
      hash = "sha256-q+1RYToZtBxAIDSiUWf3i/3GBBDwh6NWteHiK4VM1HY=";
    };
    ...
  })
```
In this manner, all the declared variables like `pname` or `version` can be accessed by `finalAttrs.<variable-name>`.

## Meta information

**meta** allows to specify several information about the package. The needed fields to set are mainly:
```nix
  meta = with lib; {
    homepage = "https://www.packagetool.com";
    description = "Description of the tool";
    mainProgram = "<tool-name>";
    maintainers = with maintainers; [ <maintainer list separated by space> ];
    platforms = with platforms; <platform list separated by ++>;
    sourceProvenance = with sourceTypes; [ <sourceTypes-value> ];
    license = licenses.<license-type>;
  };
```
Some of these fields accept only specific input values. For each one of these fields, to know what are the possible values to use, refer to the following:
* maintainers: [maintainer-list.nix](https://github.com/NixOS/nixpkgs/blob/master/maintainers/maintainer-list.nix) and [team-list.nix](https://github.com/NixOS/nixpkgs/blob/master/maintainers/team-list.nix) or running:
  ```nix
  nix repl -f '<nixpkgs>'
  builtins.attrNames lib.maintainers
  ```
* platforms: 
  ```nix
  nix repl -f '<nixpkgs>'
  builtins.attrNames lib.platforms
  ```
* sourceProvenance:
  ```nix
  nix repl -f '<nixpkgs>'
  builtins.attrNames lib.sourceTypes
  ```
  note that if nothing is specified, the default value is **fromSource**
* license:
  ```nix
  nix repl -f '<nixpkgs>'
  builtins.attrNames lib.licenses
  ```

## Misc

### Make binary wrapper

The creation of a binary wrapper is very comfortable since it allows to set environment variables along with it. An example:
```nix
  installPhase = ''
    runHook preInstall
  
    mkdir -p $out/{bin,share}
    chmod +x bin/maltego
  
    cp -aR . "$out/share/maltego/"
  
    makeWrapper $out/share/maltego/bin/maltego $out/bin/${finalAttrs.meta.mainProgram} \
      --set JAVA_HOME ${jre} \
      --prefix PATH : ${lib.makeBinPath [ jre ]}
  
    runHook postInstall
  '';
```

### Replace code strings

If it is needed to replace code strings inside source files, it is possible to use `substituteInPlace`, usually in `postPatch` for example:
```nix
  postPatch = ''
      substituteInPlace bin/maltego \
            --replace /usr/bin/awk ${lib.getExe gawk}
  '';
```
Note also the usage of `${lib.getExe gawk}`: **lib.getExe** can be used to retrive the path of a binary file.

### Create Desktop file

In a Nix package it is possible to create desktop files by importing `copyDesktopItems` and `makeDesktopItem` and use `desktopItems` as:
```nix
  nativeBuildInputs = [
    copyDesktopItems
  ];
```
and
```nix
  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      desktopName = "Maltego";
      exec = finalAttrs.meta.mainProgram;
      icon = finalAttrs.pname;
      comment = "An open source intelligence and forensics application";
      categories = [ "Network" "Security" ];
      startupNotify = false;
    })
  ];
```

### Create multiple icons from .ico file

If a source project has a `.ico` file, it is possible to generate icon images in different sizes that could be used in the desktop file of the tool. It can be reached by importing `icoutils` and use the following structure:
```nix
  nativeBuildInputs = [
    icoutils
  ];
```
and
```nix
  installPhase = ''
      runHook preInstall
  
      mkdir -p $out/{bin,share}
      chmod +x bin/maltego
  
      icotool -x bin/maltego.ico
  
      for size in 16 32 48 256
      do
        mkdir -p $out/share/icons/hicolor/$size\x$size/apps
        cp maltego_*_$size\x$size\x32.png $out/share/icons/hicolor/$size\x$size/apps/maltego.png
      done
  
      rm -r *.png
  
      cp -aR . "$out/share/maltego/"
  ...
```

