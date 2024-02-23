pkgs: pkgs.rustPlatform.buildRustPackage {
  pname = "cargo-bisect-rustc";
  version = "0.6.7";

  src = pkgs.fetchFromGitHub {
    owner = "rust-lang";
    repo = "cargo-bisect-rustc";
    rev = "e61eb10bb7b5eacb1fe3244d18ccb059393d7fac";
    hash = "sha256-rr0fU1Y5k2ScT8zpBz4VhMaUlbW/ze00ORz8dUNFIpI=";
  };

  cargoHash = "sha256-9UijUaLcJwFxkkrd91K9r1vq2fNtsTQvc+ZWGaZQiNE=";

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
