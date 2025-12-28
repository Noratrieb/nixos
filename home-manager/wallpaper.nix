{ pkgs, config, ... }:


let
  pkg = (import
    (pkgs.fetchFromGitHub {
      owner = "Noratrieb";
      repo = "wallpapersc";
      rev = "ce0def46fd0ae8d36b65ede91e068c4bca2cf9a6";
      hash = "sha256-GSBFoAElnkh0+adIqSPKwJlyYiwp4NDhsOpT+SoZv5I=";
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
