let
  nixpkgs = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/4ecab3273592f27479a583fb6d975d4aba3486fe.tar.gz";
    # Hash from `nix-prefetch-url --unpack <url>`.
    sha256 = "10wn0l08j9lgqcw8177nh2ljrnxdrpri7bp0g7nvrsn9rkawvlbf";
  };
in
  import nixpkgs