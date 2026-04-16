# Installs and starts a graphical Polkit authentication agent for Wayland sessions.
{ config, lib, pkgs, ... }:
let
  eiros_polkit_agent = config.eiros.system.security.polkit_agent;
in
{
  options.eiros.system.security.polkit_agent.enable = lib.mkOption {
    default = true;
    description = "Start a Polkit authentication agent (lxqt-policykit) as a systemd user service. Required for graphical password prompts when privileged actions (e.g. mounting drives, changing network settings) are requested on a Wayland desktop without a full DE.";
    example = lib.literalExpression ''
      {
        eiros.system.security.polkit_agent.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_polkit_agent.enable {
    assertions = [
      {
        assertion = config.security.polkit.enable;
        message = "eiros.system.security.polkit_agent requires the Polkit framework to be active. Enable eiros.system.security.polkit.enable = true.";
      }
    ];

    environment.systemPackages = [ pkgs.lxqt.lxqt-policykit ];

    systemd.user.services.polkit-agent = {
      description = "Polkit authentication agent";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
        Restart = "on-failure";
      };
    };
  };
}
