{ config, pkgs, ... }:

{
  # ---- 1. CPU Power Governor & Scaling ----
  # Disables power-profiles-daemon to prevent conflicts
  services.power-profiles-daemon.enable = false;

  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never"; # Turning off turbo on battery significantly lowers power spikes
      energy_performance_preference = "power";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
      energy_performance_preference = "performance";
    };
  };

  # ---- 2. Automated Hardware Power Savings ----
  # Enables Powertop's auto-tune feature at boot to flag down rogue PCI/USB idle draws
  powerManagement.powertop.enable = true;

  # ---- 3. AMD Ryzen SMU & TDP Capping ----
  # Enables the out-of-tree kernel driver to communicate with your Zen 4 SMU
  hardware.cpu.amd.ryzen-smu.enable = true;

  environment.systemPackages = with pkgs; [
    ryzenadj
    lact # Graphical/CLI tool for AMD GPU monitoring and control
  ];

  # The 7840HS defaults to a massive 35-54W budget, which will eat your battery.
  # This service enforces a cool, highly efficient cap on system initialization.
  systemd.services.ryzenadj-init = {
    description = "Apply RyzenAdj Conservative Power Limits";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      # Limits: STAPM to 18W, Fast limit to 18W, Slow limit to 15W, max temp to 80°C
      ExecStart = "${pkgs.ryzenadj}/bin/ryzenadj --stapm-limit=18000 --fast-limit=18000 --slow-limit=15000 --tctl-temp=80";
      RemainAfterExit = true;
    };
  };

  # ---- 4. Graphics & Hardware Video Acceleration (Radeon 780M) ----
  # Ensuring hardware decoding works means your CPU won't work overtime playing videos.
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  # Enable LACT daemon for GPU power profile modifications
  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];
}
