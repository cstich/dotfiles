{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    maestral
  ];

  networking.firewall = {
    allowedTCPPorts = [ 17500 ];
    allowedUDPPorts = [ 17500 ];
  };

  systemd.user.services.dropbox = {
    description = "Dropbox Maestral";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.maestral.out}/bin/maestral start";
      ExecReload = "${pkgs.coreutils.out}/bin/kill -HUP $MAINPID";
      KillMode = "control-group"; # upstream recommends process
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 10;
    };
  }; 
}
