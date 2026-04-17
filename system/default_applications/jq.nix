{ config, lib, pkgs, ... }:
let
  eiros_jq = config.eiros.system.default_applications.jq;
in
{
  options.eiros.system.default_applications.jq = {
    enable = lib.mkOption {
      default = true;
      description = "Install jq, a lightweight and flexible command-line JSON processor.";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_jq.enable {
    environment.systemPackages = [ pkgs.jq ];
  };
}
