# Memory headroom for shuttle-n150.
#
# This box had zero swap and let ZFS ARC grow to ~14.4 GiB of 15.5 GiB total,
# leaving nothing for the ~8 GiB of services running alongside the pool. ARC
# does not shrink fast enough under sudden allocation pressure, so the kernel's
# only move was the OOM killer: four global OOMs in August (Aug 1/8/11/14), the
# Aug 1 one firing 15 minutes into a zfs-scrub.
{ ... }:
{
  # Cap ARC at 4 GiB. This is not a dedicated NAS, and the pool is mostly
  # large sequential media reads that gain little from a huge cache.
  # Module parameter: only takes effect after a reboot.
  boot.extraModprobeConfig = ''
    options zfs zfs_arc_max=4294967296
  '';

  # Swap is zram only -- no disk swapfile. Backed by compressed RAM, so it
  # absorbs allocation spikes without touching the SSD.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50; # ~7.7 GiB of swap capacity, ~2.5 GiB of real RAM at 3:1
  };

  # Swapping to compressed RAM is cheap, so bias towards it heavily.
  boot.kernel.sysctl."vm.swappiness" = 100;
}
