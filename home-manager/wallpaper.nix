{ pkgs, config, ... }:


let
  pkg = (import
    (pkgs.fetchFromGitHub {
      owner = "Noratrieb";
      repo = "wallpapersc";
      rev = "1943eec7c55a6ac9e9b143493d90f9870b31f23a";
      hash = "sha256-AI2tnRz/NVyn+LyljMSUbxanqHzpduV2ex3yvbX/GR0=";
    }))
    { inherit pkgs; };
in
{
  systemd.user.services.wallpapersc = {
    Unit = {
      Description = "wallpaper daemon";
      PartOf = [
        config.wayland.systemd.target
      ];
      After = [ config.wayland.systemd.target ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Service = {
      ExecStart = "${pkg}/bin/wallpapersc";
      Restart = "on-failure";
    };

    Install.WantedBy = [
      config.wayland.systemd.target
    ];
  };
}
