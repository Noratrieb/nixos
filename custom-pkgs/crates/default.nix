pkgs:
let
  crates = import ./list.nix pkgs;
in
builtins.map
  (crate: pkgs.rustPlatform.buildRustPackage {
    pname = crate.pname;
    version = crate.version;
    src = pkgs.fetchCrate {
      pname = crate.pname;
      version = crate.version;
      hash = crate.downloadHash;
    };
    cargoHash = crate.cargoHash;

    meta = {
      description = "${crate.pname} crate from crates.io";
      homepage = "https://crates.io/crates/${crate.pname}";
    };
  }
  )
  crates

