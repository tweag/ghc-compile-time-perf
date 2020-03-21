let
  rev = "1ec2cf21681f0b8aa7f1b99138d31fd6015fb0ae";
  sha256 = "17v5jqlcqqbij0gxsxrijqdrjrzxrr8imblvrjczwrbrw4s93lif";
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    inherit sha256;
  };
  pkgs = import nixpkgs { config.allowUnfree = true; };
in pkgs
