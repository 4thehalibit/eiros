# Controls whether the system allows mutable (imperative) user account management.
{ config, lib, ... }:
let
  eiros_accounts = config.eiros.system.security.accounts;
in
{
  options.eiros.system.security.accounts.mutable_users.enable = lib.mkOption {
    default = true;
    description = "Allow users to create new accounts.";
    example = lib.literalExpression ''
      {
        eiros.system.security.accounts.mutable_users.enable = false;
      }
    '';
    type = lib.types.bool;
  };

  config.users.mutableUsers = eiros_accounts.mutable_users.enable;
}
