# Athena Nix

Athena Nix currently provides several configurations (still in test):
* **gnome**
* **xfce**

A configuration can be deployed in several ways:

#### Remote
```
sudo nixos-rebuild switch --flake 'github:Athena-OS/athena-nix#gnome'
```

#### Local
Running command inside `athena-nix` directory:
```
git clone https://github.com/Athena-OS/athena-nix
cd athena-nix
sudo nixos-rebuild switch --flake '.#gnome'
```
Running command outside `athena-nix` directory:
```
sudo nixos-rebuild switch --flake '<local-path-to-dir-containing-flake.nix>/.#gnome'
```
