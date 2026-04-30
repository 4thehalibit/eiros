# NinjaOne remote access client (ncplayer).
# Extracts the binary from a user-supplied .deb, wraps it in an FHS environment
# to satisfy its library dependencies, and registers the ninjarmm:// URL scheme
# so browsers can launch remote sessions directly.
#
# Usage:
#   1. Download the x64 Debian/Ubuntu installer from your NinjaOne portal.
#   2. Set eiros.system.default_applications.utilities.ninjaone.deb_path to its path.
#   3. Rebuild. The ncplayer binary and URL scheme handler are installed automatically.
#
# To update: download the new .deb, update deb_path, and rebuild.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.eiros.system.default_applications.utilities.ninjaone;

  ncplayer-bin = pkgs.stdenv.mkDerivation {
    name = "ninjarmm-ncplayer-bin";
    src = cfg.deb_path;
    nativeBuildInputs = [ pkgs.dpkg ];
    unpackPhase = "true";
    installPhase = ''
      mkdir -p $out/bin
      dpkg-deb -x $src extracted
      cp extracted/opt/ncplayer/bin/ncplayer $out/bin/ncplayer
      chmod +x $out/bin/ncplayer
    '';
  };

  ncplayer-fhs = pkgs.buildFHSEnv {
    name = "ncplayer";
    targetPkgs = pkgs: with pkgs; [
      libdrm
      libgbm
      mesa
      dbus
      stdenv.cc.cc.lib
    ];
    runScript = "${ncplayer-bin}/bin/ncplayer";
  };

  ncplayer-desktop = pkgs.writeTextFile {
    name = "ninjarmm-ncplayer-desktop";
    destination = "/share/applications/ninjarmm-ncplayer.desktop";
    text = ''
      [Desktop Entry]
      Type=Application
      Name=NinjaOne Remote Player
      Exec=ncplayer %u
      StartupNotify=false
      MimeType=x-scheme-handler/ninjarmm;
    '';
  };
in
{
  options.eiros.system.default_applications.utilities.ninjaone = {
    enable = lib.mkOption {
      default = false;
      description = "Install the NinjaOne remote access client (ncplayer).";
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.utilities.ninjaone.enable = true;
          eiros.system.default_applications.utilities.ninjaone.deb_path = ./ninjarmm-ncplayer_amd64.deb;
        }
      '';
      type = lib.types.bool;
    };

    deb_path = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to the NinjaOne ncplayer .deb installer downloaded from your NinjaOne portal.
        The file is copied into the Nix store at evaluation time.

        Note: the installer is tenant-specific (tied to your NinjaOne account) and should
        NOT be committed to a public repository. Reference it with an absolute path outside
        your config repo, e.g. /home/user/private/ninjarmm-ncplayer_amd64.deb.

        New installers are released frequently. To update, download the latest .deb from
        your portal, update this path, and rebuild.
      '';
      example = lib.literalExpression ''
        {
          eiros.system.default_applications.utilities.ninjaone.deb_path = /home/user/private/ninjarmm-ncplayer_amd64.deb;
        }
      '';
    };
  };

  config = lib.mkIf (cfg.enable && cfg.deb_path != null) {
    environment.systemPackages = [
      ncplayer-fhs
      ncplayer-desktop
    ];

    # Register ninjarmm:// as a system-wide URL scheme handled by ncplayer.
    xdg.mime.defaultApplications = {
      "x-scheme-handler/ninjarmm" = "ninjarmm-ncplayer.desktop";
    };
  };
}
