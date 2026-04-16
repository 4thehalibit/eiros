# Configures the GnuPG agent with pinentry flavor and optional SSH key support.
{ config, lib, pkgs, ... }:
let
  eiros_gpg = config.eiros.system.security.gpg;
in
{
  options.eiros.system.security.gpg = {
    enable = lib.mkOption {
      default = true;
      description = "Enable the GnuPG agent for GPG key management, commit signing, and pass/age workflows.";
      example = false;
      type = lib.types.bool;
    };

    ssh_support = {
      enable = lib.mkOption {
        default = false;
        description = "Use gpg-agent as the SSH agent (replaces ssh-agent with GPG-backed SSH keys).";
        example = true;
        type = lib.types.bool;
      };
    };

    pinentry_flavor = lib.mkOption {
      default = "gnome3";
      description = "Pinentry flavor for GPG passphrase prompts (gnome3, gtk2, curses, tty, qt).";
      example = "curses";
      type = lib.types.enum [ "curses" "emacs" "gnome3" "gtk2" "qt" "rofi" "tty" ];
    };
  };

  config = lib.mkIf eiros_gpg.enable {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = eiros_gpg.ssh_support.enable;
      pinentryPackage = lib.mkDefault (
        if eiros_gpg.pinentry_flavor == "gnome3" then
          pkgs.pinentry-gnome3
        else if eiros_gpg.pinentry_flavor == "gtk2" then
          pkgs.pinentry-gtk2
        else if eiros_gpg.pinentry_flavor == "curses" then
          pkgs.pinentry-curses
        else if eiros_gpg.pinentry_flavor == "qt" then
          pkgs.pinentry-qt
        else
          pkgs.pinentry-tty
      );
    };
  };
}
