pkgs: pkgs.rustPlatform.buildRustPackage {
  pname = "x";
  version = "1.0.1";

  src = ./.;

  cargoLock.lockFile = ./Cargo.lock;

  meta = with pkgs.lib; {
    description = "Helper for rust-lang/rust x.py";
    homepage = "https://github.com/rust-lang/rust/blob/master/src/tools/x";
    license = licenses.mit;
    mainProgram = "x";
  };
}
