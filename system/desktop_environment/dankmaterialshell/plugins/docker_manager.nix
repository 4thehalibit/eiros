# dockerManager DMS plugin — Docker/Podman container management bar widget.
# Only active when the Docker module is enabled.
{ inputs, config, ... }:
{
  eiros.system.desktop_environment.dankmaterialshell.plugins = {
    dockerManager = {
      enable = config.eiros.system.virtualization.docker.enable;
      src = inputs.dms_docker_manager;
    };
  };

  eiros.system.user_defaults.dms.external_plugin_settings = {
    dockerManager = {
      terminalApp = "ghostty";
    };
  };
}
