{ ... }:
{
  # Users
  environment.pathsToLink = [ "/lib/pkgconfig" "/share/pkgconfig" ];
  users.users.raphael = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "render" "input" ]; # sudo
    linger = true;
  };
}
