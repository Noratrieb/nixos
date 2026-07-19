{ pkgs, config, ... }:


let
  pkg = (import
    (pkgs.fetchFromGitHub {
      owner = "Noratrieb";
      repo = "colouncher";
      rev = "1bc9a2374770b9d43d81993398609656008862cb";
      hash = "sha256-6tuFzF/iaDwvAvi0LbFZjS7oYRXSQoao3902dpd9svU=";
    }))
    { inherit pkgs; };
in
{
  systemd.user.services.colouncher = {
    Unit = {
      Description = "Color-based program-launching wallpaper for Wayland";
      PartOf = [
        config.wayland.systemd.target
      ];
      After = [ config.wayland.systemd.target ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Service = {
      ExecStart = pkgs.lib.getExe pkg;
      Restart = "on-failure";
      Type = "notify";
      Environment = [
        "LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [pkgs.vulkan-loader]}"
      ];
    };

    Install.WantedBy = [
      config.wayland.systemd.target
    ];
  };
}
