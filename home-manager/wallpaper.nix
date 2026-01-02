{ pkgs, config, ... }:


let
  pkg = (import
    (pkgs.fetchFromGitHub {
      owner = "Noratrieb";
      repo = "colouncher";
      rev = "a68d0dff63c32f84354f97aed5ac52ce3e0fa284";
      hash = "sha256-NhZMBKxqHCQSvvj2NjXUlCQ5JvRPdGTnftTxdciLlPQ=";
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
