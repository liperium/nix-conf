# Installation

## Enable flakes in /etc/nixos/configuration.nix and add git/gh

```sudoedit /etc/nixos/configuration.nix```

```git gh```

```nix.settings.experimental-features = [ "nix-command" "flakes" ];```

```gh repo clone liperium/nix-conf```

## Copy harware configuration file

```cp /etc/nixos/hardware-configuration.nix /home/liperium/nix-conf/hosts/HOSTNAME/```

```git config --global user.email "mattysgervais@gmail.com" && git config --global user.name "Mattys Gervais"```

```git commit -m "init hw conf"```

## Rebuild with conf

```sudo nixos-rebuild switch --flake /home/liperium/nix-conf#HOSTNAME```

## Set static ip if needed

## Export zfs

sudo zpool import zfs-data
sudo ranger
sudo zpool export zfs-data
