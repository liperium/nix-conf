{ pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./modules.nix
    inputs.vscode-server.nixosModules.default
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.hostName = "battleship";

  environment.systemPackages = with pkgs; [
    nvtopPackages.amd
    gparted
    rkdeveloptool
    minicom
    # unstable.llmfit
    # unstable.vllm
    # unstable.jan
    # unstable.ollama-rocm
  ];
  #virtualisation.waydroid.enable = true;
  #virtualisation.waydroid.package = pkgs.waydroid-nftables;

  services.vscode-server.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  boot.loader = {
    timeout = 5;
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = false;

    limine = {
      enable = true;
      efiSupport = true;
      # Editing entries at boot allows passing init=/bin/sh, i.e. free root.
      enableEditor = false;
      # The ESP is only 600M and each generation copies its kernel + initrd
      # into /boot/limine/kernels, so cap how many are kept.
      maxGenerations = 5;

      style.interface.branding = "battleship";

      # Windows sits on its own ESP (nvme0n1p1), which Limine does not
      # auto-discover, so chainload its boot manager by partition GUID.
      extraEntries = ''
        /Windows
            protocol: efi
            path: guid(b8aa925c-1c9a-4512-9e80-879b8a2aef72):/EFI/Microsoft/Boot/bootmgfw.efi
      '';
    };
  };

  # ROCM
  # nixpkgs.config.rocmSupport = true;
  # systemd.tmpfiles.rules =
  #   let
  #     rocmEnv = pkgs.symlinkJoin {
  #       name = "rocm-combined";
  #       paths = with pkgs.rocmPackages; [
  #         rocblas
  #         hipblas
  #         clr
  #       ];
  #     };
  #   in
  #   [
  #     "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
  #   ];

  system.stateVersion = "24.11";
}
