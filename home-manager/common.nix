{ lib
, pkgs
, ...
}:
let
  customPkgs = import ../custom-pkgs/default.nix pkgs;
in
{
  programs.neovim.enable = true;

  # mold-wrapped has the cursed nix linker shenanigans that make it produce properly rpathed binaries.
  home.file.".cargo/config.toml" = {
    text = ''
      [target.x86_64-unknown-linux-gnu]
      linker = "${lib.getExe pkgs.llvmPackages_16.clang}"
      rustflags = ["-Clink-arg=-fuse-ld=${lib.getExe' pkgs.mold-wrapped "mold"}", "-Ctarget-cpu=native"]
    '';
  };

  home.file.".config/gdb/gdbinit" = {
    text = ''
      set disassembly-flavor intel
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
      c = "cargo";
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
