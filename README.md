# nix-conf

My nixos configurations.I am still pretty new to NixOs, and I've mostly tried to keep an architecture that makes sense for me, I do love my modularity and the portability of my files, so it can feel quite hard to grasp at a glance without being familiar with Nix.

Running *unstable* branch, I like the newest packages, and NixOs has never bricked a package, or a behavior for me as of now. (Which can always be reverted by changing back to previous state)

Currently running Hyprland, never configured a DE from scratch, still learning a lot.

NixOs is what makes sense to me configuration wise for the Linux systems, I love being able to sync everything with a single *git pull* and then updating the system with all of my new configurations just there and ready to go without further configuration. If it works on one pc, it has worked on all my pc's for now.

Still need to transfer my server to NixOs, but not ready to do so *YET*, thinking about what programs I would need, and how portable would I like to make everything. Probably going to go with Dockge and push all my dockerfiles to a github repo and sync them with NixOs if possible, thus still requiring some manual stuff (running Dockge) but after that it'll all be automated (unless I can run containers in Nix config files :o )

## Folder structure

- home : contains all of my userspace configurations (hyprland + configs, kitty, etc)
- hosts : contains host specific configuration, may it be certain packages, or hardware-configuration files. Each host contains a "modules.nix" which grabs them from *modules*
- modules : contains nix files with specific packages and configurations, these are made to be *drop-in* to work as-is on any host. Thus containing sometimes only packages, and sometimes additionnal configuration. They try to fit a certain purpose, so they can be moved in/out of specific hosts based on the needs.
- pkgs : contains specific packages that I would make. For now none, but protonup-rs and godot4-mono should be there.
- templates : contains templates that I want to keep across all of my systems. Dev environments for python, rust-Bevy, etc. Stuff that took a while to figure out, and I want to have on the fly.

## Updates

I update whenever, cause I've never had any problem with upgrades. Mostly every ~2 weeks.

## Cheat sheet for Nix stuff

commit hash : ```git rev-parse HEAD```

### Direnv

echo "use flake" >> .envrc && direnv allow

## Deving for nixpkgs

[Running and building from local nixpkgs](https://nixos.wiki/wiki/Nixpkgs/Create_and_debug_packages)

Get hashes while debugging : ```lib.fakeHash```

## Public key is invalid

1. get key from [here](https://github.com/NixOS/nixpkgs/blob/1f949558617ebb18bbf7005c1c4dc3407d391e93/nixos/modules/services/misc/nix-daemon.nix#L806)
2. add ```--option trusted-public-keys 'YOUR KEY HERE'```

## Nix cache
Attach ```--option eval-cache false``` to the command or remove the cached runs ```rm -rf ~/.cache/nix```.

## Keychron
From [here](https://bbs.archlinux.org/viewtopic.php?id=285709)
Use ```sudo chmod a+rw /dev/hidraw*``` to make hid devices writeable/readable.
Open Keychron Launcher, should work!
