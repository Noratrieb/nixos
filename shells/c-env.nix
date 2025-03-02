{ pkgs }: pkgs.mkShell {
  buildInputs = with pkgs; [ openssl zlib libpq ];
  nativeBuildInputs = with pkgs; [ pkg-config cmake ];
}
