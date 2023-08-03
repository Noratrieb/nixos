pkgs: pkgs.rustPlatform.buildRustPackage rec {
  pname = "cargo-bisect-rustc";
  version = "0.6.7";

  src = pkgs.fetchFromGitHub {
    owner = "rust-lang";
    repo = "cargo-bisect-rustc";
    rev = "7884b4120561d17e10ffabf6490d51b4e0ac3fd3"; # contains an unrelease fix for perf builds
    hash = "sha256-BiqsDs/HTuQEjqRLnoYQzJADllqqiVL3m2AzamHd7IM=";
  };

  cargoHash = "sha256-GzoJufms7ud3ZJxNHrrdmfYT7TSoTeAQNwBjptO59SA=";

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
