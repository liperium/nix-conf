# TODO

- [ ] Nextcloud auto-sync cmd? or client? Think cmd would be more seemless? But conflict resoltion: o
  (Force-Pull on start?)

  - [ X ] Discord Notifications not showing up - Use discord and not Webcord
  - [ X ] Polkit - GUI to enable sudo
  - [ X ] better libsecret (check how it works before) - gnome-keyring,
  stores
  secrets
- [ X ] keyring autounlock
- [ X ] NVChad - Locally - - HELIX IS JUST DEFAULT BETTER TY
- [ X ] Numlock startup - <https://www.reddit.com/r/NixOS/comments/u8vwz0/how_to_turn_on_numlock_on_boot/ >
- [ ] hblock system wide
- [ ] insert GF config?
- [ X ] frigate bluetooth
- [ X ] Make custom power white too
- [ X ] Change ls for lsd
- [ ] Waypipe to get into desktops?
- [ ] Make firefox vaapi ```hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };```
