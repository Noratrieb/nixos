{ pkgs, config, ... }:


let
  pkg = (import
    (pkgs.fetchFromGitHub {
      owner = "Noratrieb";
      repo = "colouncher";
      rev = "cd0c16497756b758ee184063e119f1bec2127f18";
      hash = "sha256-PcbYBojWMzb855u8+sk6hfu1hpHwInEcNBGk0/qqYtw=";
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
    };

    Install.WantedBy = [
      config.wayland.systemd.target
    ];
  };
}
