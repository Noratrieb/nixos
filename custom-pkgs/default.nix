pkgs: {
  cargo-bisect-rustc = import ./cargo-bisect-rustc/default.nix pkgs;
  cargo-mommy = import ./cargo-mommy.nix pkgs;
  monaspace = import ./monaspace.nix pkgs;
  x = import ./x pkgs;
}
