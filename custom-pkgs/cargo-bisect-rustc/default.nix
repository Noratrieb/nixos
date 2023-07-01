pkgs: pkgs.rustPlatform.buildRustPackage rec {
  pname = "cargo-bisect-rustc";
  version = "0.6.6";

  src = pkgs.fetchFromGitHub {
    owner = "rust-lang";
    repo = "cargo-bisect-rustc";
    rev = "v${version}";
    hash = "sha256-i/MZslGbv72MZmd31SQFc2QdDRigs8edyN2/T5V5r4k=";
  };

  cargoHash = "sha256-dnR0V2MvW4Z3jtsjXSboCRFNb22fDGu01fC40N2Deho=";

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
