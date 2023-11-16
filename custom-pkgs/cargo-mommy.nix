# copied from https://github.com/NixOS/nixpkgs/blob/d4b5a67bbe9ef750bd2fdffd4cad400dd5553af8/pkgs/development/tools/rust/cargo-mommy/default.nix#L15
{ lib, rustPlatform, fetchFromGitHub, ... }:

rustPlatform.buildRustPackage {
  pname = "cargo-mommy";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "Gankra";
    repo = "cargo-mommy";
    rev = "6feb98f10ede68c82d99f70aa79cb3a53530dc88";
    hash = "sha256-DuPDF594KgItrDzjFxP2xHNuzziZCmq5bCrhCh71Y1U=";

  };

  cargoSha256 = "sha256-YkKHlLv6w3PHjv9Z94QUUO41v0W1FJ7zAUoTsKfaQG0=";

  meta = with lib; {
    description = "Cargo wrapper that encourages you after running commands";
    homepage = "https://github.com/Gankra/cargo-mommy";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ GoldsteinE ];
    mainProgram = "cargo-mommy";
  };
}
