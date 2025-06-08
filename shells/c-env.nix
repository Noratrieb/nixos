{ pkgs }: pkgs.mkShell {
  buildInputs = with pkgs; [ openssl zlib libpq sqlite ];
  nativeBuildInputs = with pkgs; [
    pkg-config
    cmake
    ninja
    llvmPackages_19.clang
    llvmPackages_19.lld
    llvmPackages_19.bintools-unwrapped
  ];
}
