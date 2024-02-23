pkgs: {
  cargo-bisect-rustc = import ./cargo-bisect-rustc/default.nix pkgs;
  jujutsu = pkgs.stdenv.mkDerivation {
    name = "jujutsu";
    src = pkgs.fetchurl {
      url = "https://github.com/martinvonz/jj/releases/download/v0.14.0/jj-v0.14.0-x86_64-unknown-linux-musl.tar.gz";
      hash = "sha256-/4HbDUk9g1tqYv0Y0n/tHLP80CKqlaLKXDWxUI6aRYc=";
    };
    # the unpacker is too stupid to accept archives that don't have subdiretories
    sourceRoot = ".";
    installPhase = ''
      mkdir -p $out/bin
      cp jj $out/bin/jj
    '';
    meta = {
      mainProgram = "jj";
    };
  };
  monaspace = import ./monaspace.nix pkgs;
  x = import ./x { inherit pkgs; };
}

