# In XFCE module, home.nix is used to set if implementing xfce.refined or xfce.picom
{ home-manager, username, theme, ... }:
{
    home-manager.users.${username} = { pkgs, ...}: {
        imports = [
          ./.
        ];
    _module.args.theme = theme;
    athena.desktops.xfce.picom = true;
  };
}
