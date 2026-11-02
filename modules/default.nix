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
  # Keep flake input sources (incl. nested ones) alive across GC, otherwise the
  # next rebuild re-downloads every nixpkgs tarball (~1 min).
  # Private git+ssh inputs are skipped: hosts that don't use them may lack access.
  system.extraDependencies =
    let
      lock = (builtins.fromJSON (builtins.readFile "${inputs.self}/flake.lock")).nodes;
      isGit = n: (lock.${lock.root.inputs.${n}}.locked.type or "") == "git";
      public = lib.filterAttrs (n: _: !isGit n) (removeAttrs inputs [ "self" ]);
      collect = i: [ i.outPath ] ++ lib.concatMap collect (lib.attrValues (i.inputs or { }));
    in
    lib.unique (lib.concatMap collect (lib.attrValues public));
  nix.settings.auto-optimise-store = true;
  nix.settings.download-buffer-size = 524288000;
  nix.settings.accept-flake-config = true;

  # Enable networking
  networking = {
    firewall.enable = lib.mkDefault false;
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Montreal";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";
  i18n.extraLocales = [ "fr_CA.UTF-8/UTF-8" ];
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
  nix.settings.trusted-users = [ "root" "liperium" ];

  users.users.liperium = {
    isNormalUser = true;
    description = "Mattys Gervais";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPaXteVeooXltzsHdBDfjwBzqLV+NGcNJ3O25ZbmIKdL liperium@battleship"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPaXteVeooXltzsHdBDfjwBzqLV+NGcNJ3O25ZbmIKdL liperium@frigate"
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
    jq
    yq-go
    ripgrep
    fd
    bat
    eza
    delta
    xh
    fx
    dust
    duf
    procs
    tealdeer
    hyperfine
    choose
    sd
    watchexec
    lnav
    mtr
    doggo

    # Networking - Basics
    wget
    curl
    dig

    # Helix
    helix

    lsd # Better ls
    sops # Secret encryption/decryption

    #Terminal
    any-nix-shell

    # Fish plugins
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

  # fish is the login shell; bash stays installed, so `bash script.sh` / shebang scripts still work.
  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
    set fish_greeting # Disables shell greeting
  '';
  programs.fish.shellAliases = {
    ll = "lsd -l";
    ls = "lsd";
  };

  users.defaultUserShell = pkgs.fish;

  # Key-only SSH everywhere (keys: users.users.liperium.openssh.authorizedKeys above).
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  nixpkgs.overlays = [
    (final: _: {
      # this allows you to access `pkgs.unstable` anywhere in your config
      unstable = import inputs.nixpkgs-unstable {
        inherit (final.stdenv.hostPlatform) system;
        inherit (final) config;
      };
    })
  ];

  # SOPS
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/liperium/.config/sops/age/keys.txt";
  #sops.secrets.example-key = { };

}
