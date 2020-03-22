{ pkgs ? (import ./nix/nixpkgs) }:

with pkgs;

pkgs.mkShell {
  buildInputs = [
    haskell.packages.ghc882.hs-speedscope
    numactl
  ];
}
