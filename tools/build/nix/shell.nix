{ pkgs ? import ./pkgs.nix { config = { }; overlays = [ (import ./overlays) ]; }, lib ? pkgs.lib, stdenv ? pkgs.stdenv}:

pkgs.mkShell {
  packages = [
    pkgs.bashInteractive
    pkgs.bazel
    pkgs.coreutils
    pkgs.direnv
    pkgs.docker
    pkgs.git
    pkgs.gnutar
    pkgs.jdk8
    pkgs.nodejs_18
    pkgs.python311
    pkgs.python311Packages.black
    pkgs.python311Packages.pip-tools
    pkgs.texlive.combined.scheme-small
    pkgs.xz
    pkgs.zsh
  ];
}
