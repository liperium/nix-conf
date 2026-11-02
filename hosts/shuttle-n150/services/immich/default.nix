{ pkgs, ... }:
{
  services.immich = {
    enable = true;
    package = pkgs.unstable.immich;
    port = 2283;
    host = "0.0.0.0";
    accelerationDevices = [ "/dev/dri/renderD128" ];
    mediaLocation = "/zfs-data/immich";
    settings.server.externalDomain = "https://immich.mattysgervais.com";
    settings.ffmpeg.accel = "qsv";
    settings.ffmpeg.accelDecode = true;

    # GPU-hang mitigation. The Alder Lake-N iGPU wedges during OpenVINO model
    # compilation and takes the whole box down with it (three hard freezes in
    # August, each with an OpenVINO compile as the last thing logged).
    #
    # immich picks OpenVINO over CPU automatically and has no env var to change
    # providers, so the levers are how *often* models get compiled and how
    # bounded their shapes are:
    #   - MODEL_TTL=0 keeps models resident instead of unloading them after 5
    #     minutes and recompiling to the GPU on the next request.
    #   - OCR runs a dynamic batch of 6, which matches the "dynamic shape
    #     without upper bound" error; pin it to 1. Facial recognition already
    #     pins to 1 under OpenVINO.
    machine-learning.environment = {
      MACHINE_LEARNING_MODEL_TTL = "0";
      MACHINE_LEARNING_MAX_BATCH_SIZE__OCR = "1";

      # Optional: preloading moves the one remaining compile to service start
      # rather than on-demand mid-transcode. Fill in the model names shown in
      # the immich admin UI (Settings -> Machine Learning) to enable.
      # MACHINE_LEARNING_PRELOAD__CLIP__VISUAL = "ViT-B-32__openai";
      # MACHINE_LEARNING_PRELOAD__CLIP__TEXTUAL = "ViT-B-32__openai";
      # MACHINE_LEARNING_PRELOAD__FACIAL_RECOGNITION__DETECTION = "buffalo_l";
      # MACHINE_LEARNING_PRELOAD__FACIAL_RECOGNITION__RECOGNITION = "buffalo_l";
    };
  };

  # Fallback if the freezes continue: hide /dev/dri from the ML unit only.
  # OpenVINO then reports no GPU and falls back to its CPU device, while
  # Jellyfin and immich *video* transcoding keep full GPU access.
  # systemd.services.immich-machine-learning.serviceConfig.PrivateDevices =
  #   lib.mkForce true;
  users.users.immich.extraGroups = [ "video" "render" ];
}
