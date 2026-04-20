# Switches D-Bus to dbus-broker, the modern upstream-recommended implementation.
# Drop-in compatible — no configuration changes required for existing services.
{ config, lib, ... }:
let
  eiros_dbus = config.eiros.system.security.dbus;
in
{
  options.eiros.system.security.dbus = {
    broker = lib.mkOption {
      default = true;
      description = "Use dbus-broker instead of the classic dbus reference implementation. Drop-in compatible.";
      example = lib.literalExpression ''
        {
          eiros.system.security.dbus.broker = false;
        }
      '';
      type = lib.types.bool;
    };
  };

  config = lib.mkIf eiros_dbus.broker {
    services.dbus.implementation = "broker";
  };
}
