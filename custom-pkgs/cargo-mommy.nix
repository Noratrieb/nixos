# copied from https://github.com/NixOS/nixpkgs/blob/d4b5a67bbe9ef750bd2fdffd4cad400dd5553af8/pkgs/development/tools/rust/cargo-mommy/default.nix#L15
{ lib, rustPlatform, fetchFromGitHub, ... }:

rustPlatform.buildRustPackage {
  pname = "cargo-mommy";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "Gankra";
    repo = "cargo-mommy";
    rev = "0d96506db241003166e32deb22ad0ab0fc52c16c";
    hash = "sha256-SIL7ExSRVBXr7Z+ye+rjjUpK6WS/fytvfhj3WPPdenc=";
  };

  cargoSha256 = "sha256-hdWYvWNOko6wlffv2Vb3xTYfh9mQgLlON8EVKVkWUV0=";

  meta = with lib; {
    description = "Cargo wrapper that encourages you after running commands";
    homepage = "https://github.com/Gankra/cargo-mommy";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ GoldsteinE ];
    mainProgram = "cargo-mommy";
  };
}
