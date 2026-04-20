# Restricts sudo execution to members of the wheel group only.
{ config, lib, ... }:
let
  eiros_sudo = config.eiros.system.security.sudo;
in
{
  options.eiros.system.security.sudo = {
    wheel_only = lib.mkOption {
      default = true;
      description = "Restrict sudo to wheel group members only. Prevents non-wheel users from escalating privileges even if misconfigured sudoers rules exist.";
      example = lib.literalExpression ''
        {
          eiros.system.security.sudo.wheel_only = false;
        }
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_sudo.wheel_only {
    security.sudo.execWheelOnly = true;
  };
}
