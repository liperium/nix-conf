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
  nix.settings.download-buffer-size = 524288000;

  # Enable networking
  networking = {
    firewall.enable = lib.mkDefault false;
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_CA.UTF-8";
    LC_IDENTIFICATION = "en_CA.UTF-8";
    LC_MEASUREMENT = "en_CA.UTF-8";
    LC_MONETARY = "en_CA.UTF-8";
    LC_NAME = "en_CA.UTF-8";
    LC_NUMERIC = "en_CA.UTF-8";
    LC_PAPER = "en_CA.UTF-8";
    LC_TELEPHONE = "en_CA.UTF-8";
    LC_TIME = "en_CA.UTF-8";
  };

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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPv3sbgsPrzqGKPAQXSCcHfa85ya8DeY6gJ08Zqu9Mzf liperium@battleship"
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
    #ranger
    yazi # more features, preview, etc
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

    # Fish plugins
    fish
    fishPlugins.z
    fishPlugins.tide
    fishPlugins.done
    fishPlugins.forgit
    fishPlugins.fzf
    fzf
  ];
  programs.git = {
    enable = true;
    lfs.enable = true;
    config = {
      init = {
        defaultBranch = "main";
      };
      user.email = "mattysgervais@gmail.com";
      user.name = "Mattys Gervais";

      fetch = {
        prune = "true";
        auto = 1;
      };
      url = {
        "git@github.com:liperium/" = {
          insteadOf = "https://github.com/liperium/";
        };
      };

    };
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
    shellInit = ''
      eval "$(oh-my-posh init zsh --config $HOME/.config/omp/zen.toml)"
      eval "$(zoxide init zsh)"
      if command -v direnv >/dev/null 2>&1
      then
        eval "$(direnv hook zsh)"
      fi
    '';
  };

  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
    set fish_greeting # Disables shell greeting
  '';

  users.defaultUserShell = pkgs.zsh;
  users.users.liperium.shell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh fish ];

  # SOPS
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/liperium/.config/sops/age/keys.txt";
  #sops.secrets.example-key = { };

}
