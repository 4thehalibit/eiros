# Enables the PC/SC smart card daemon for YubiKey and hardware security key support.
{ config, lib, ... }:
let
  eiros_pcscd = config.eiros.system.security.pcscd;
in
{
  options.eiros.system.security.pcscd.enable = lib.mkOption {
    default = false;
    description = "Enable the PC/SC smart card daemon. Required for YubiKey, smart cards, and hardware security keys used for SSH, GPG, or FIDO2.";
    example = true;
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_pcscd.enable {
    services.pcscd.enable = true;
  };
}
