{ config
, pkgs
, lib
, inputs
, ...
}:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;

  system.stateVersion = "24.11";

  # Enable networking
  networking = {
    firewall.enable = lib.mkDefault false;
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enables microcode updates
  hardware.enableRedistributableFirmware = true;

  users.users.liperium = {
    isNormalUser = true;
    description = "Mattys Gervais";
    extraGroups = [
      "networkmanager"
      "wheel"
      "adm" # system76 stuff? https://www.reddit.com/r/System76/comments/1dnfhj4/system76power_on_nixos/
      "video"
      "audio"
      "input" # fingerprint reader GDM https://wiki.archlinux.org/title/Fprint
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    util-linux
    #lshw # Debugging nvidia prime
    #libva-utils # Debugging vaapi
    gcc
    tree

    # Utils
    nh # Better nixos manager
    btop
    ranger
    zoxide

    # Networking - Basics
    wget
    curl
    dig

    # Helix
    helix

    lsd # Better ls
    sops # Secret encryption/decryption

    #Terminal
    zsh
    any-nix-shell
  ];
  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  environment.variables.EDITOR = "hx";

  # zsh default
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
    };
    shellAliases = {
      ls = "lsd";
    };
    promptInit = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin
    '';
  };
  programs.fish.interactiveShellInit = ''
    ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
  '';

  users.defaultUserShell = pkgs.zsh;
  users.users.liperium.shell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  # SOPS
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/liperium/.config/sops/age/keys.txt";
  #sops.secrets.example-key = { };

}
