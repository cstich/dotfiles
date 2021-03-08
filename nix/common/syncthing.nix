{pkgs, lib, ...}:
{

  # The default max inotify watches is 8192.
  # Nowadays most apps require a good number of inotify watches,
  # the value below is used by default on several other distros.
  boot.kernel.sysctl."fs.inotify.max_user_watches" = lib.mkDefault 524288;

  services = {
     syncthing = {
       enable = true;
       user = "christoph";
       dataDir = "/home/christoph/.config/syncthing";
       configDir = "/home/christoph/.config/syncthing";
     };
  };
}
