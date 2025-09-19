{ pkgs }: pkgs.mkShell {
  buildInputs = with pkgs; [ openssl zlib libpq sqlite ];
  nativeBuildInputs = with pkgs; [
    pkg-config
    cmake
    ninja
    llvmPackages_21.clang
    llvmPackages_21.lld
    llvmPackages_21.bintools-unwrapped
  ];
}
