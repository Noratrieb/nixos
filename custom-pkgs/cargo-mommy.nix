# copied from https://github.com/NixOS/nixpkgs/blob/d4b5a67bbe9ef750bd2fdffd4cad400dd5553af8/pkgs/development/tools/rust/cargo-mommy/default.nix#L15
{ lib, rustPlatform, fetchFromGitHub, ... }:

rustPlatform.buildRustPackage {
  pname = "cargo-mommy";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Gankra";
    repo = "cargo-mommy";
    rev = "0ec17361d8b0573d0155984403e576b788abeb60";
    hash = "sha256-Mf0VGxQ90PjNhFA2OnDIFkNZjYDCuMqPsexqy5+gRdI=";
  };

  cargoSha256 = "sha256-iQt6eTCcpzhFnrDkUmT4x7JX+Z7fWdW5ovbB/9Ui7Sw=";

  meta = with lib; {
    description = "Cargo wrapper that encourages you after running commands";
    homepage = "https://github.com/Gankra/cargo-mommy";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ GoldsteinE ];
    mainProgram = "cargo-mommy";
  };
}
