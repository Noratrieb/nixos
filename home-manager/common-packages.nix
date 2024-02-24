{ pkgs, inputs, ... }:
let
  customPkgs = import ../custom-pkgs pkgs;
  crates = import ../custom-pkgs/crates pkgs;
in
with pkgs; [
  bacon
  bat
  cargo-cross
  cargo-expand
  cargo-mommy
  cargo-nextest
  inputs.jujutsu.packages.${pkgs.system}.jujutsu
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
  jq
  p7zip
  python3
  ripgrep
  rustup-toolchain-install-master
  samply
  tokei
  uwuify
] ++ crates
