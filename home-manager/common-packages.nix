{ pkgs, ... }:
let
  customPkgs = import ../custom-pkgs/default.nix pkgs;
in
with pkgs; [
  bacon
  bat
  cargo-expand
  cargo-nextest
  customPkgs.cargo-mommy
  dig
  fzf
  gcc
  gdb
  gh
  git-absorb
  git-crypt
  htop
  hyperfine
  inferno
  p7zip
  python3
  ripgrep
  rustup-toolchain-install-master
  samply
]
