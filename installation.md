# Installation

## Git and fetch repo

```nix-shell -p git```

```git pull https://github.com/liperium/nix-conf```

## Enable flakes in /etc/nixos/configuration.nix

```nix.settings.experimental-features = [ "nix-command" "flakes" ];```

## Copy harware configuration file

```cp /etc/nixos/hardware-configuration.nix /home/liperium/nix-conf/hosts/HOSTNAME/```

## Rebuild with conf

```sudo nixos-rebuild switch --flake /home/liperium/nix-conf#HOSTNAME;```

## Set static ip if needed

## Export zfs
sudo zpool import zfs-data
sudo ranger
sudo zpool export zfs-data

