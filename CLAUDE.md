# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Deployment Commands

```bash
# Build and switch to new configuration (replace HOSTNAME with: frigate, battleship, or shuttle-n150)
sudo nixos-rebuild switch --flake /home/liperium/nix-conf#HOSTNAME

# Test build without activating
sudo nixos-rebuild test --flake /home/liperium/nix-conf#HOSTNAME

# Build only (no activation)
sudo nixos-rebuild build --flake /home/liperium/nix-conf#HOSTNAME
```

## Secrets Management (SOPS)

```bash
# Encrypt a new secret file (INPUT_TYPE: binary, json, yaml, dotenv)
sops --config ./.sops.yaml encrypt --input-type INPUT_TYPE --in-place ./modules/secrets/MY_FILE

# Edit existing encrypted file
sops ./modules/secrets/MY_FILE
```

## Development Environment Setup

```bash
# Enable direnv for a project (uses flake.nix devShell)
echo "use flake" >> .envrc && direnv allow
```

## Architecture Overview

This is a modular, multi-host NixOS Flakes configuration. The design philosophy is "drop-in" modules that work on any host without modification.

### Directory Structure

- **flake.nix** - Entry point defining all hosts, inputs, and outputs
- **hosts/** - Host-specific configurations (one subdirectory per machine)
  - Each host has: `default.nix` (main config), `hardware-configuration.nix` (auto-generated), `modules.nix` (module imports)
  - Server hosts have a `services/` subdirectory with one service per folder
- **modules/** - Reusable system modules (drop-in features)
  - `default.nix` - Global base config applied to ALL hosts (Nix settings, networking, locale, shell, git)
  - `desktop/` - Desktop environment modules (Hyprland, GNOME, Plasma), dev tools, gaming
  - `hardware/` - Hardware-specific configs (SSD, Btrfs, dual-boot)
  - `secrets/` - SOPS-encrypted secrets
- **home/** - Home Manager user configurations (shell, editors, WM configs)
  - Subdirectories contain app-specific configs (helix/, zsh/, hyprland/, firefox/, etc.)
- **templates/** - Development environment templates (rust/, python/, java/)

### Active Hosts

| Host | Type | Architecture | Desktop |
|------|------|--------------|---------|
| frigate | Framework laptop | x86_64 | Hyprland + GNOME |
| battleship | Gaming desktop | x86_64 | Hyprland |
| shuttle-n150 | Intel N150 server | x86_64 | Headless |

### Package Channels

The flake provides two Nixpkgs overlays accessible in configs:
- `pkgs.stable.*` - Nixpkgs 25.11 stable
- `pkgs.unstable.*` - Nixpkgs unstable

### Key Patterns

1. **Module Composition**: Each host's `modules.nix` imports the required modules via relative paths
2. **Home Manager Integration**: Configured per-host in flake.nix with `home-manager-liperium-root` function
3. **Monitor Configuration**: Hyprland monitor settings passed via `specialArgs.hyprMonitor`
4. **Secrets**: SOPS with age encryption, secrets accessible at `/run/secrets/...`
5. **Theming**: Catppuccin (mocha, mauve accent) applied system-wide via catppuccin.homeModules

### Server Services (shuttle-n150)

Services are containerized or native NixOS modules. Key services:
- Caddy (reverse proxy with Cloudflare DNS)
- Authelia (SSO)
- Jellyfin, Immich, Stash (media)
- Sonarr, Radarr, Prowlarr, qBittorrent (downloads, VPN-confined)
- AdGuardHome, Home Assistant
- Nextcloud, Samba, WireGuard
