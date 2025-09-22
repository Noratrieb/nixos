pkgs: {
  cargo-bisect-rustc = import ./cargo-bisect-rustc/default.nix pkgs;
  sl = import ./sl { inherit pkgs; };
  run = import ./run { inherit pkgs; };
  unpem = import ./unpem { inherit pkgs; };
  u = import ./u { inherit pkgs; };
  x = import ./x { inherit pkgs; };
}

