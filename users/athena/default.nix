{ pkgs, username, ... }:
{
# Define a user account. Don't forget to change the password by ‘passwd’.
  users.users.${username} = {
    shell = pkgs.bash;
    isNormalUser = true;
    initialPassword = "temp123";
    extraGroups = [ "wheel" "input" "video" "render" ];
  };
}