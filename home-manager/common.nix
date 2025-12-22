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
      linker = "${lib.getExe pkgs.llvmPackages_21.clang}"
      rustflags = ["-Clink-arg=-fuse-ld=${lib.getExe' pkgs.mold "mold"}", "-Ctarget-cpu=native"]
    '';
  };

  home.file.".config/gdb/gdbinit" = {
    text = ''
      set disassembly-flavor intel
    '';
  };
  home.file.".config/gdb/gdbearlyinit" = {
    text = ''
      set startup-quietly on
    '';
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
  };

  programs.eza = {
    enable = true;
  };

  programs.ripgrep.enable = true;

  programs.fd.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    shellAbbrs = {
      flamegraph = "perf script | inferno-collapse-perf | inferno-flamegraph > out.svg && firefox out.svg";
      c = "cargo";
      g = "git";
      sc = "scratch";
    };
    shellAliases = {
      x = "CARGO_MOMMYS_ACTUAL=${lib.getExe customPkgs.x} ${lib.getExe' pkgs.cargo-mommy "cargo-mommy"}";
    };
    functions = {
      "scratch" = {
        description = "Makes a temporary directory and moves into it";
        body = ''
          cd "$(mktemp --tmpdir -d scratchXXXXXXXXX)"
        '';
      };
    };
  };

  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "transgender";
      mode = "rgb";
      light_dark = "dark";
      lightness = 0.65;
      color_align = {
        mode = "horizontal";
        custom_colors = [ ];
        fore_back = null;
      };
      backend = "fastfetch";
      args = null;
      distro = null;
      pride_month_shown = [ ];
      pride_month_disable = false;
    };
  };

  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
