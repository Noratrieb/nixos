pkgs: pkgs.rustPlatform.buildRustPackage {
  pname = "cargo-bisect-rustc";
  version = "0.6.11";

  src = pkgs.fetchFromGitHub {
    owner = "rust-lang";
    repo = "cargo-bisect-rustc";
    rev = "995147f7863377b3831f84911d21d1895437eee7";
    hash = "sha256-kQmQXMiZAh2zAXkxMoxlTfjrpXMIgXlJfwOsJPIVe94=";
  };

  cargoHash = "sha256-WSO5LvdJkAorSwsICz9NAWKNM7x4aeNvhGLhJSO6Vi8=";

  patches =
    let
      patchelfPatch = pkgs.runCommand "0001-patchelf.patch"
        {
          CC = pkgs.stdenv.cc;
          patchelf = pkgs.patchelf;
          libPath = "$ORIGIN/../lib:${pkgs.lib.makeLibraryPath [ pkgs.zlib ]}";
        }
        ''
          export dynamicLinker=$(cat $CC/nix-support/dynamic-linker)
          substitute ${./0001-patchelf.patch} $out \
            --subst-var patchelf \
            --subst-var dynamicLinker \
            --subst-var libPath
        '';
    in
    pkgs.lib.optionals pkgs.stdenv.isLinux [ patchelfPatch ];

  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [ openssl xz ];

  PKG_CONFIG_PATH = "${pkgs.openssl}/lib";

  # Tests access the network.
  doCheck = false;

  meta = with pkgs.lib; {
    description = "Bisects rustc, either nightlies or CI artifacts";
    homepage = "https://github.com/rust-lang/cargo-bisect-rustc";
    license = licenses.mit;
  };
}
