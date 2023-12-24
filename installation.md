# Installation

## Enable flakes in /etc/nixos/configuration.nix and add git/gh

```bash
sudoedit /etc/nixos/configuration.nix
```

```nix
# Add this to file
git gh
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

```bash
gh repo clone liperium/nix-conf
```

## Copy harware configuration file

```bash
cp /etc/nixos/hardware-configuration.nix /home/liperium/nix-conf/hosts/HOSTNAME/
git config --global user.email "mattysgervais@gmail.com" && git config --global user.name "Mattys Gervais"
git commit -m "init hw conf"
```

## Rebuild with conf

```sudo nixos-rebuild switch --flake /home/liperium/nix-conf#HOSTNAME```

# Cheat Sheets

## Set static ip if needed

## Export zfs

```bash
sudo zpool import zfs-data
sudo ranger
sudo zpool export zfs-data
```

## Mount nixos from recovery drive

```bash
mount /dev/[root partition] /mnt
mount /dev/[boot partition] /mnt/boot

nixos-enter

sudo nixos-rebuild --install-bootloader boot
```

## Nextcloud update files

```bash
./occ files:scan --all
```
