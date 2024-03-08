{ lib
, pkgs
, ...
}:
let
  customPkgs = import ../custom-pkgs/default.nix pkgs;
in
{
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

  programs.direnv = {
    enable = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    shellAbbrs = {
      flamegraph = "perf script | inferno-collapse-perf | inferno-flamegraph > out.svg && firefox out.svg";
      g = "git";
    };
    shellAliases = {
      x = "CARGO_MOMMYS_ACTUAL=${lib.getExe customPkgs.x} ${lib.getExe' pkgs.cargo-mommy "cargo-mommy"}";
    };
  };

  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
