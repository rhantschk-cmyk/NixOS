{ ... }:
{
  # Users
  users.users.raphael = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "render" "input" ]; # sudo
    linger = true;
  };
}
