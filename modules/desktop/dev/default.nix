{ config, pkgs, lib, ... }:

{
  users.users.liperium = { packages = with pkgs; [ 
    vscode 
    nixfmt 
    cargo 
    rust-analyzer 
    rustfmt 
    pkg-config 
    udev

    #udev alsa-lib vulkan-loader
    #xorg.libX11 xorg.libXcursor xorg.libXi xorg.libXrandr # To use the x11 feature
    #libxkbcommon wayland
    ]; 
    };
  environment.systemPackages = with pkgs; [
    vulkan-tools
  ];
}
