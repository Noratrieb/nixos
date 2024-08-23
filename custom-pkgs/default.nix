pkgs: {
  cargo-bisect-rustc = import ./cargo-bisect-rustc/default.nix pkgs;
  monaspace = import ./monaspace.nix pkgs;
  run = import ./run { inherit pkgs; };
  unpem = import ./unpem { inherit pkgs; };
  x = import ./x { inherit pkgs; };
}

