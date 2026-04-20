# Eiros

A modular, declarative NixOS system configuration built with Nix flakes. Eiros manages both system-level and user-level settings around the MangoWC Wayland compositor and Dank Material Shell (DMS) desktop environment.

The core repo defines the module schemas and defaults. Personal hardware and user configuration lives in separate flake repos that are injected at build time via `--override-input`.

## Features

- **Modular architecture** — `.nix` files in subdirectories are auto-loaded; no manual imports needed
- **MangoWC integration** — declarative keybinds, settings, and wallpaper per user
- **Dank Material Shell** — clipboard history, dynamic theming (matugen wallpaper-based auto-theming), system monitoring, DankSearch, wallpaper carousel, Docker container management widget, SSH connections launcher, optional VPN management widget, optional audio visualizer, and optional CalDAV calendar sync
- **Home directory management** via [hjem](https://github.com/feel-co/hjem)
- **Hardware support** — NVIDIA PRIME (offload/sync), Intel/AMD CPU microcode, Bluetooth, printing, fingerprint, zram compressed swap
- **Performance tuning** — TCP BBR congestion control, network buffer tuning, kernel sysctl defaults (vm, scheduler, memory overcommit), PipeWire low-latency quantum
- **Security-first defaults** — UFW firewall enabled, SSH disabled, no password auth over SSH, kernel/filesystem hardening sysctl (fs.protected_*, kptr_restrict, bpf_jit_harden), ICMP redirect blocking, sudo restricted to wheel group, dbus-broker, kernel module blacklisting (FireWire DMA, legacy protocols), optional sops-nix secret management
- **Virtualization** — KVM/QEMU, Libvirt, Docker (own module, NVIDIA CDI), Distrobox, Virt Manager, Windows 11 guest support (swtpm TPM 2.0 + Secure Boot)
- **Shell toolchain** — zoxide, atuin, delta, lazygit, pay-respects, and optional Zellij multiplexer alongside the existing fzf/yazi/eza/bat/ripgrep stack; modern replacements for sed (sd), df (duf), ps (procs), and ping (gping); xh HTTP client, tealdeer command examples, and hyperfine benchmarking
- **Declarative Neovim** — fully configured via nixvim with LSP, treesitter, completion, telescope, and plugin ecosystem
- **Binary compatibility** — nix-ld provides a dynamic linker stub for unpatched executables; nix-alien wraps them in an auto-detected FHS environment when the stub isn't enough
- **Run-any-package** — comma + nix-index-database lets you run any nixpkgs program without installing it (`nix-index-database` provides a pre-built file-to-package index)

## Directory Structure

```
eiros/
├── flake.nix               # Flake definition and inputs
├── system/                 # System module schemas and defaults
│   ├── audio/              # PipeWire, pactl, playerctl, EasyEffects, Helvum
│   ├── boot/               # Bootloader, kernel package, kernel params, Plymouth
│   ├── default_applications/# Categorized into subfolders; auto-loaded recursively
│   │   ├── shells/         # zsh, ghostty, zellij, atuin, zoxide, fzf, pay_respects
│   │   ├── editors/        # neovim, nixvim, nix_tools
│   │   ├── version_control/# git, delta, lazygit
│   │   ├── file_management/# yazi, eza, fd, ripgrep, sd, bat, file, unzip, archive
│   │   ├── system_monitoring/ # btop, procs, ncdu, duf, gping, pciutils, usbutils
│   │   ├── media/          # mpv, imv, zathura, multimedia
│   │   ├── network/        # curl, wget, xh
│   │   ├── utilities/      # qalculate, tealdeer, hyperfine, wl_clipboard, flatpak
│   │   ├── gaming/         # gamemode, mangohud
│   │   └── browsers/       # vivaldi
│   ├── desktop_environment/# MangoWC, XDG portals, Wayland
│   │   └── dankmaterialshell/ # DMS options and plugins
│   │       └── plugins/    # One file per DMS plugin
│   ├── fonts/              # Font packages and fontconfig
│   ├── hardware/           # CPU, GPU, power, peripherals, earlyoom
│   ├── locale/             # Timezone, timesync, i18n locale
│   ├── logging/            # journald retention and rate limiting
│   ├── networking/         # NetworkManager, hostname, DNS
│   ├── nix/                # Flakes, GC, cache, direnv, nix-ld, nix-alien, man pages
│   ├── security/           # Firewall, SSH, GPG, polkit, sops, mutable accounts
│   └── virtualization/     # KVM, Docker, Distrobox, Virt Manager
├── users/
│   ├── default_settings/
│   │   ├── dms/            # System-wide DMS user setting defaults (one file per topic)
│   │   │   ├── theme.nix
│   │   │   ├── appearance.nix
│   │   │   ├── bar.nix
│   │   │   ├── control_center.nix
│   │   │   ├── media.nix
│   │   │   ├── notifications.nix
│   │   │   ├── lock_screen.nix
│   │   │   ├── power.nix
│   │   │   ├── app_theming.nix
│   │   │   ├── dock.nix
│   │   │   ├── launcher.nix
│   │   │   ├── greeter.nix
│   │   │   ├── display.nix
│   │   │   ├── widgets.nix
│   │   │   ├── misc.nix
│   │   │   └── settings_assembly.nix
│   │   └── mangowc/        # System-wide MangoWC user defaults
│   │       └── keybinds.nix
│   └── users.nix           # User module schema
└── resources/
    └── nix/
        ├── import_modules.nix      # Recursive module auto-loader
        └── mangowc_helpers.nix     # MangoWC keybind submodule and config helpers
```

## Usage

### Prerequisites

- NixOS with Nix flakes enabled
- Git
- A hardware config flake (provides `nixosModules.default` for `eiros.system.hardware.*` options)
- A users config flake (provides `nixosModules.default` for `eiros.users.*` options)

### Building

Point Eiros at your own hardware and user config repos using `--override-input`:

```bash
sudo nixos-rebuild boot --flake .#default \
  --override-input eiros_users github:yourname/eiros.users.yourconfig \
  --override-input eiros_hardware github:yourname/eiros.hardware.yourmachine
```

If you set `eiros.system.nix.nh.flake` to your config path in your hardware or users repo, you can use [nh](https://github.com/nix-community/nh) instead:

```bash
nh os boot
nh os switch
```

### Creating Your Own Config Repos

**Hardware repo** (`eiros.hardware.*`)

Create a flake that exports `nixosModules.default` and sets `eiros.system.hardware.*` options:

```nix
# flake.nix in your hardware repo
{
  outputs = { nixpkgs, ... }: {
    nixosModules.default = { ... }: {
      eiros.system.hardware.cpu.vendor = "amd";
      eiros.system.hardware.graphics.nvidia.enable = true;
      # ...
    };
  };
}
```

**Users repo** (`eiros.users.*`)

Create a flake that exports `nixosModules.default` and sets `eiros.users.*` options:

```nix
# flake.nix in your users repo
{
  outputs = { nixpkgs, ... }: {
    nixosModules.default = { ... }: {
      eiros.users.yourusername = {
        initial_password = "change_me";
        # DMS settings.json — omit to use system-wide defaults from
        # eiros.system.user_defaults.dms.*; override by merging in JSON keys
        dms.settings = config.eiros.system.user_defaults.dms._settings // {
          currentThemeName = "blue";
          cornerRadius = 12;
          use24HourClock = false;
        };
        mangowc = {
          settings = {
            # MangoWC key-value config
          };
          keybinds = {
            open_terminal = {
              modifier_keys = [ "SUPER" ];
              key_symbol = "Return";
              mangowc_command = "spawn";
              command_arguments = "ghostty";
            };
          };
          wallpaper = /path/to/wallpaper.png;
        };
      };
    };
  };
}
```

> **Warning:** The default `initial_password` is the username. Change it before deploying — a build warning will remind you if you forget.

## Available Options

All options are under the `eiros.*` namespace:

| Namespace | Description |
|---|---|
| `eiros.system.hardware.*` | CPU vendor, GPU, power, peripherals, printing, Bluetooth, earlyoom OOM killer, zram compressed swap (algorithm, memory %) |
| `eiros.system.boot.*` | Bootloader, kernel package, kernel params, sysctl tuning, Plymouth theme |
| `eiros.system.audio.*` | pactl/playerctl keybind tools, PipeWire (ALSA, JACK, PulseAudio compat, RTKit), low-latency quantum tuning (default 512 samples), EasyEffects audio EQ (off by default), Helvum patchbay GUI (off by default) |
| `eiros.system.locale.*` | Timezone, timesync, i18n locale and LC_ categories |
| `eiros.system.networking.*` | Hostname, DNS, NetworkManager, IWD, Avahi mDNS, TCP BBR congestion control + network buffer tuning, ICMP redirect blocking |
| `eiros.system.security.*` | Firewall, SSH, GPG, polkit, polkit authentication agent, sops-nix secrets, mutable user accounts, kernel/filesystem hardening sysctl, dbus-broker, sudo wheel restriction, kernel module blacklisting |
| `eiros.system.desktop_environment.*` | MangoWC, DMS, XDG portals, keyring, dconf, DMS wallpaperCarousel plugin, DMS dockerManager plugin (auto-enabled with Docker), DMS sshConnections launcher plugin; optional audio visualizer (`audio_wavelength`), CalDAV calendar sync (`calendar_events`), and VPN management widget (`vpn`) — all three disabled by default |
| `eiros.system.nix.*` | Build settings, GC, cache substituters, direnv, nix-ld, nix-alien FHS wrapper, nh helper, comma + nix-index-database (run any nixpkgs program without installing), man pages and NixOS documentation |
| `eiros.system.default_applications.shells.*` | Zsh (history, options, Oh My Zsh, autosuggestions, syntax highlighting), Ghostty terminal, Zellij multiplexer, atuin history search, zoxide smart cd, fzf fuzzy finder, pay-respects command corrector |
| `eiros.system.default_applications.editors.*` | Neovim (default editor, vi/vim aliases), nixvim declarative config (LSP, treesitter, telescope, completion, plugins), Nix LSP (nil) and formatter (nixfmt) |
| `eiros.system.default_applications.version_control.*` | Git, delta syntax-highlighted diffs, lazygit TUI |
| `eiros.system.default_applications.file_management.*` | yazi file manager, eza (ls), fd (find), ripgrep, sd (sed replacement), bat (cat), file type detection, unzip, archive tools (zip/p7zip) |
| `eiros.system.default_applications.system_monitoring.*` | btop, procs (ps replacement), ncdu disk usage, duf (df replacement), gping visual ping, pciutils (lspci), usbutils (lsusb) |
| `eiros.system.default_applications.media.*` | mpv default media player, imv image viewer, zathura PDF viewer, GStreamer multimedia codecs |
| `eiros.system.default_applications.network.*` | curl, wget, xh (HTTP client) |
| `eiros.system.default_applications.utilities.*` | qalculate GTK calculator, tealdeer (tldr), hyperfine benchmarking, wl-clipboard, Flatpak |
| `eiros.system.default_applications.gaming.*` | GameMode CPU performance profiles, MangoHUD in-game overlay |
| `eiros.system.default_applications.browsers.*` | Vivaldi (Wayland/Ozone flags, dark mode, GPU sandbox options) |
| `eiros.system.virtualization.*` | Docker daemon, KVM, Distrobox (NVIDIA CDI), Virt Manager, Windows 11 guest support (swtpm TPM 2.0, OVMFFull Secure Boot) |
| `eiros.system.fonts.*` | Font packages and fontconfig defaults |
| `eiros.system.logging.*` | journald retention, rate limiting, vacuum |
| `eiros.system.user_defaults.dms.<topic>.*` | System-wide defaults for all 200+ DMS user settings, namespaced by topic (`dms.bar.*`, `dms.dock.*`, `dms.appearance.*`, `dms.notifications.*`, `dms.lock_screen.*`, `dms.power.*`, `dms.launcher.*`, `dms.widgets.*`, etc.). Options use `.enable` style for feature toggles and include `example` fields showing full configuration paths. Assembled into `dms._settings` and written to `~/.config/DankMaterialShell/settings.json` |
| `eiros.system.user_defaults.mangowc.*` | System-wide defaults for the MangoWC keybind set (`mangowc.keybinds`) and launch commands (`mangowc.commands.terminal`, `mangowc.commands.file_browser`). Commands auto-derive from enabled packages; keybinds are merged with per-user overrides at build time |
| `eiros.users.*` | User accounts, MangoWC keybinds, wallpaper, per-user DMS settings override |

## Default Shell Aliases

All aliases are active only when `eiros.system.default_applications.shells.zsh.enable = true` (the default). Each alias has its own toggle — set the listed option to `false` to disable just the alias while keeping the tool installed.

### File Management

| Alias | Expands To | Disable Option |
|---|---|---|
| `cat` | `bat` | `eiros.system.default_applications.file_management.bat.override.enable` |
| `ls` | `eza --icons` | `eiros.system.default_applications.file_management.eza.override.enable` |
| `ll` | `eza -lh --icons --git` | `eiros.system.default_applications.file_management.eza.override.enable` |
| `la` | `eza -lah --icons --git` | `eiros.system.default_applications.file_management.eza.override.enable` |
| `tree` | `eza --tree --icons` | `eiros.system.default_applications.file_management.eza.override.enable` |
| `find` | `fd` | `eiros.system.default_applications.file_management.fd.override.enable` |
| `grep` | `rg` | `eiros.system.default_applications.file_management.ripgrep.override.enable` |

### System Monitoring

| Alias | Expands To | Disable Option |
|---|---|---|
| `ps` | `procs` | `eiros.system.default_applications.system_monitoring.procs.override.enable` |
| `df` | `duf` | `eiros.system.default_applications.system_monitoring.duf.override.enable` |
| `ping` | `gping` | `eiros.system.default_applications.system_monitoring.gping.override.enable` |

### Version Control

| Alias | Expands To | Disable Option |
|---|---|---|
| `lg` | `lazygit` | `eiros.system.default_applications.version_control.lazygit.alias.enable` |

### Editors

| Alias | Expands To | Disable Option |
|---|---|---|
| `vi` | `nvim` | `eiros.system.default_applications.editors.neovim.vi_alias.enable` |
| `vim` | `nvim` | `eiros.system.default_applications.editors.neovim.vim_alias.enable` |

## Default MangoWC Keybinds

Applied to all users when `mangowc.default_keybinds.enable = true` (the default). Per-user keybinds with matching names override these.

### Window Management

| Keybind | Action |
|---|---|
| `Super + Q` | Close focused window |
| `Super + Shift + Q` | Quit MangoWC |
| `Super + G` | Toggle floating |
| `Super + M` | Toggle maximize |
| `Super + Tab` | Toggle overview |
| `Super + Shift + R` | Reload config |

### Navigation

| Keybind | Action |
|---|---|
| `Super + H` | Focus left |
| `Super + L` | Focus right |
| `Super + K` | Focus up |
| `Super + J` | Focus down |
| `Super + Shift + H` | Swap window left |
| `Super + Shift + L` | Swap window right |
| `Super + Shift + K` | Swap window up |
| `Super + Shift + J` | Swap window down |
| `Ctrl + Shift + H` | Move window to monitor left |
| `Ctrl + Shift + L` | Move window to monitor right |
| `Ctrl + Shift + K` | Move window to monitor up |
| `Ctrl + Shift + J` | Move window to monitor down |

### Tags (Workspaces)

| Keybind | Action |
|---|---|
| `Super + 1–9` | Switch to tag 1–9 |
| `Super + Shift + 1–9` | Move window to tag 1–9 |

### Applications

| Keybind | Action |
|---|---|
| `Super + T` | Launch terminal |
| `Super + F` | Launch file browser |
| `Super + B` | Launch browser (when `vivaldi.enable = true`) |

The `terminal` and `file_browser` commands auto-derive from the enabled packages — when `ghostty.enable` and `yazi.enable` are true (the defaults), they resolve to the Nix store paths of those binaries. Override explicitly if needed:

```nix
eiros.system.user_defaults.mangowc.commands = {
  terminal     = "foot";
  file_browser = "foot -e yazi";
};
```

### Media and Brightness

| Keybind | Action |
|---|---|
| `XF86AudioRaiseVolume` | Volume up 5% |
| `XF86AudioLowerVolume` | Volume down 5% |
| `XF86AudioMute` | Toggle mute |
| `XF86AudioPlay` | Play / pause |
| `XF86AudioNext` | Next track |
| `XF86AudioPrev` | Previous track |
| `XF86MonBrightnessUp` | Brightness up 10% |
| `XF86MonBrightnessDown` | Brightness down 10% |

### DMS Integration

These keybinds are only active when `eiros.system.desktop_environment.dankmaterialshell.enable = true`.

| Keybind | Action |
|---|---|
| `Super + D` | Toggle DMS Spotlight |
| `Super + Escape` | Lock screen |
| `Super + N` | Toggle notification center |
| `Super + Shift + N` | Toggle night mode |
| `Super + Shift + S` | Screenshot (no file, copies to clipboard) |
| `Ctrl + Shift + V` | Paste from clipboard history |
| `Super + V` | Toggle clipboard history panel |
| `Super + ,` | Open DMS settings |
| `Super + W` | Toggle wallpaper carousel |

## Flake Inputs

| Input | Source | Purpose |
|---|---|---|
| `nixpkgs` | NixOS/nixpkgs | Package set (tracks nixos-unstable) |
| `dank_material_shell` | AvengeMedia | DMS desktop shell and greeter modules |
| `hjem` | feel-co | Home directory management |
| `mango` | DreamMaoMao | MangoWC compositor module |
| `nixvim` | nix-community/nixvim | Declarative Neovim configuration |
| `eiros_hardware` | lcleveland/eiros.hardware | Hardware configuration (override with your own) |
| `eiros_users` | lcleveland/eiros.users | User configuration (override with your own) |
| `sops-nix` | Mic92/sops-nix | Declarative secret management via SOPS + age/GPG |
| `wallpaper_carousel` | motor-dev/wallpaperCarousel | DMS plugin for interactive 3D wallpaper carousel selection |
| `dms_docker_manager` | LuckShiba/DmsDockerManager | DMS bar widget for Docker/Podman container management (auto-enabled with Docker) |
| `dms_ssh_connections` | merdely/dms-plugins | DMS Launcher plugin for SSH connections (trigger: `;`) |
| `nix-alien` | thiagokokada/nix-alien | Overlay providing nix-alien, which wraps unpatched binaries in an auto-detected FHS environment |
| `nix-index-database` | nix-community/nix-index-database | Pre-built nix-index file database; used by comma to resolve package names without a local index build |
