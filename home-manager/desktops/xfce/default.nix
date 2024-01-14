# In XFCE module, home.nix is used to set if implementing xfce.refined or xfce.picom
{ home-manager, username, theme, ... }:
{
    home-manager.users.${username} = { pkgs, ...}: {
        imports = [
          ./xfce.nix
        ];
    _module.args.theme = theme;
    athena.desktops.xfce.refined = true;
  };
}
