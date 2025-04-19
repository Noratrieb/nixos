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
  dig
  fzf
  gcc
  gdb
  gh
  git-absorb
  git-crypt
  hollywood
  htop
  hyperfine
  llvmPackages_19.bintools-unwrapped
  inferno
  jq
  jujutsu
  p7zip
  python3
  rustup-toolchain-install-master
  samply
  tokei
  customPkgs.u
  uwuify
] ++ crates
