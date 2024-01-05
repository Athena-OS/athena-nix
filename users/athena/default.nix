{ pkgs, username, ... }:
{
# Define a user account. Don't forget to change the password by ‘passwd’.
  users.users.${username} = {
    shell = pkgs.bash;
    isNormalUser = true;
    initialPassword = "athena";
    extraGroups = [ "wheel" "input" "video" "render" "networkmanager" ];
    packages = with pkgs; [
      firefox
      git
      vscodium
      wget
    #  thunderbird
    ];
  };
}
