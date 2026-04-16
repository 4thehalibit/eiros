# Controls whether the system allows mutable (imperative) user account management.
{ config, lib, ... }:
let
  eiros_accounts = config.eiros.system.accounts;
in
{
  options.eiros.system.accounts.mutable_users.enable = lib.mkOption {
    default = true;
    description = "Allow users to create new accounts.";
    example = false;
    type = lib.types.bool;
  };

  config.users.mutableUsers = eiros_accounts.mutable_users.enable;
}
