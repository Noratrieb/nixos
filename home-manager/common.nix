{ inputs
, lib
, config
, pkgs
, ...
}: {
  programs.neovim.enable = true;

  home.file.".cargo/config.toml" = {
    text = ''
      [target.x86_64-unknown-linux-gnu]
      linker = "${lib.getExe pkgs.llvmPackages_16.clang}"
      rustflags = ["-Clink-arg=-fuse-ld=${lib.getExe' pkgs.mold "mold"}", "-Ctarget-cpu=native"]
    '';
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
