{ pkgs }: pkgs.mkShell {
  buildInputs = with pkgs; [ openssl zlib ];
  nativeBuildInputs = with pkgs; [ pkg-config cmake ];
}
