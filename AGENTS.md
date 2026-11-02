# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Deployment Commands

**IMPORTANT: Never run `nixos-rebuild` yourself. The user always rebuilds their system manually.** After making config changes, stop and let the user run the rebuild.

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
  - `desktop/` - Desktop modules: niri environment, dev tools (mapgears, universidad), gaming, printer, kdeconnect
  - `hardware/` - Hardware-specific configs (SSD, Btrfs, dual-boot)
  - `secrets/` - SOPS-encrypted secrets
- **home/** - Home Manager user configurations (shell, editors, WM configs)
  - Subdirectories contain app-specific configs (helix/, niri/, zellij/, hypridle/, etc.); `console.nix` = every host, `desktop.nix` = GUI hosts
- **templates/** - Development environment templates (rust/, python/, java/)

### Active Hosts

| Host | Type | Architecture | Desktop |
|------|------|--------------|---------|
| frigate | Framework laptop | x86_64 | Niri |
| battleship | Gaming desktop | x86_64 | Niri |
| shuttle-n150 | Intel N150 server | x86_64 | Headless |

### Package Channels

The flake pins Nixpkgs 26.05; `pkgs.unstable.*` (nixos-unstable) is available via an overlay in `modules/default.nix`.

### Key Patterns

1. **Module Composition**: Each host's `modules.nix` imports the required modules via relative paths
2. **Hosts**: `mkHost` in flake.nix wires each host with Home Manager (`hmImports`) + sops
3. **Self-describing modules**: each feature module (e.g. `dev/mapgears.nix`, `environment/niri`) declares everything it needs, even if another module also enables it. Only dedupe boilerplate repeated across host files.
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
