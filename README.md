# Eiros

A modular, declarative NixOS system configuration built with Nix flakes. Eiros manages both system-level and user-level settings around the MangoWC Wayland compositor and Dank Material Shell (DMS) desktop environment.

The core repo defines the module schemas and defaults. Personal hardware and user configuration lives in separate flake repos that are injected at build time via `--override-input`.

## Features

- **Modular architecture** — `.nix` files in subdirectories are auto-loaded; no manual imports needed
- **MangoWC integration** — declarative keybinds, settings, and wallpaper per user
- **Dank Material Shell** — audio visualizer, clipboard history, dynamic theming, calendar, system monitoring, and search
- **Home directory management** via [hjem](https://github.com/feel-co/hjem)
- **Hardware support** — NVIDIA PRIME (offload/sync), Intel/AMD CPU microcode, Bluetooth, printing, fingerprint
- **Security-first defaults** — UFW firewall enabled, SSH disabled, no password auth over SSH, optional sops-nix secret management
- **Virtualization** — KVM/QEMU, Libvirt, Podman, Distrobox, Virt Manager
- **Shell toolchain** — zoxide, atuin, delta, lazygit, pay-respects, and optional Zellij multiplexer alongside the existing fzf/yazi/eza/bat/ripgrep stack

## Directory Structure

```
eiros/
├── flake.nix               # Flake definition and inputs
├── system/                 # System module schemas and defaults
│   ├── boot/               # Bootloader, kernel, Plymouth
│   ├── hardware/           # CPU, GPU, power, peripherals
│   ├── desktop_environment/# MangoWC, DMS, XDG portals, Wayland
│   ├── default_applications/# Neovim, Git, Zsh, Ghostty, Vivaldi
│   ├── networking/         # NetworkManager, hostname, DNS
│   ├── security/           # Firewall, SSH, GPG, PAM
│   ├── nix/                # Flakes, GC, direnv, nix-ld
│   ├── virtualization/     # KVM, Podman, Distrobox
│   ├── fonts/              # Font packages and fontconfig
│   └── ...                 # Audio, locale, time, logging, accounts
├── users/
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
| `eiros.system.hardware.*` | CPU vendor, GPU, power, peripherals, printing, Bluetooth |
| `eiros.system.boot.*` | Bootloader, kernel params, sysctl tuning, Plymouth theme |
| `eiros.system.networking.*` | Hostname, DNS, NetworkManager, IWD, Avahi mDNS |
| `eiros.system.security.*` | Firewall, SSH, GPG, polkit, PAM, sops-nix secrets |
| `eiros.system.desktop_environment.*` | MangoWC, DMS, XDG portals, keyring, keybind commands |
| `eiros.system.nix.*` | Build settings, GC, cache substituters, direnv, nix-ld |
| `eiros.system.default_applications.*` | Neovim/nixvim opts and plugins, Zsh history and options, Vivaldi flags, fzf defaults, zoxide smart cd, atuin history, delta git diffs, lazygit TUI, pay-respects command corrector, Zellij multiplexer, Flatpak, mpv, imv, zathura, btop, ncdu, archive tools (zip/p7zip), Nix LSP and formatter |
| `eiros.system.virtualization.*` | KVM, Podman (DNS, Docker compat), Distrobox |
| `eiros.system.fonts.*` | Font packages and fontconfig defaults |
| `eiros.system.logging.*` | journald retention, rate limiting, vacuum |
| `eiros.system.time.*` | Timezone, timesync |
| `eiros.system.language.*` | Locale |
| `eiros.system.pipewire.*` | PipeWire, ALSA, JACK, PulseAudio compat, RTKit |
| `eiros.system.easyeffects.*` | PipeWire audio effects and EQ (off by default) |
| `eiros.system.helvum.*` | PipeWire patchbay GUI (off by default) |
| `eiros.system.earlyoom.*` | Early OOM killer thresholds and process preferences |
| `eiros.users.*` | User accounts, MangoWC keybinds, wallpaper |

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
| `Super + T` | Launch terminal (default: `ghostty`) |
| `Super + F` | Launch file browser (default: `ghostty -e yazi`) |

The commands behind these binds are configurable:

```nix
eiros.system.desktop_environment.mangowc.default_keybinds.commands = {
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

These keybinds are only active when `eiros.system.desktop_environment.dank_material_shell.enable = true`.

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
| `Super + Y` | Next wallpaper |

## Flake Inputs

| Input | Source | Purpose |
|---|---|---|
| `nixpkgs` | NixOS/nixpkgs | Package set (tracks master) |
| `dank_material_shell` | AvengeMedia | DMS desktop shell and greeter modules |
| `hjem` | feel-co | Home directory management |
| `mango` | DreamMaoMao | MangoWC compositor module |
| `eiros_hardware` | lcleveland/eiros.hardware | Hardware configuration (override with your own) |
| `eiros_users` | lcleveland/eiros.users | User configuration (override with your own) |
| `sops-nix` | Mic92/sops-nix | Declarative secret management via SOPS + age/GPG |
