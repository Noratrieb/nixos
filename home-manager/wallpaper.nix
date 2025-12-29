{ pkgs, config, ... }:


let
  pkg = (import
    (pkgs.fetchFromGitHub {
      owner = "Noratrieb";
      repo = "colouncher";
      rev = "bee16cced1e03419f31534d2811233f7aadd0043";
      hash = "sha256-Aoyc2kk1xO4wfdi5+NT7Mhei2rvzaxP3Y9WifWqRN18=";
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
    };

    Install.WantedBy = [
      config.wayland.systemd.target
    ];
  };
}
