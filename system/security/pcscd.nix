{ config, lib, ... }:
let
  eiros_pcscd = config.eiros.system.security.pcscd;
in
{
  options.eiros.system.security.pcscd.enable = lib.mkOption {
    default = false;
    description = "Enable the PC/SC smart card daemon. Required for YubiKey, smart cards, and hardware security keys used for SSH, GPG, or FIDO2.";
    type = lib.types.bool;
  };

  config = lib.mkIf eiros_pcscd.enable {
    services.pcscd.enable = true;
  };
}
