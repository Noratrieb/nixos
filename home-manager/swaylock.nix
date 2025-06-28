{ ... }: {
  programs.swaylock.enable = true;
  programs.swaylock.settings = {
    image = "/run/user/1000/lockscreen.png";
  };
}
