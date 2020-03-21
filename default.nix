{ pkgs ? (import ./nix/nixpkgs) }:

with pkgs;

stdenv.mkDerivation {
  name = "ghc-compile-time-perf";
  src = lib.sourceByRegex ./. [
    "^compilers.*$"
    "^tests.*$"
  ];
  buildInputs = [
    haskell.packages.ghc882.hs-speedscope
    numactl
  ];
  buildPhase = ''
    pushd tests > /dev/null
    for test_dir_raw in $(find . -maxdepth 1 -mindepth 1 -type d)
    do
      export test_dir=$(echo "$test_dir_raw" | cut -c 3-)

      pushd $test_dir > /dev/null

      # ../../compilers/ghc-master -ddump-timings Main.hs +RTS -p -l-au
      # hs-speedscope ghc-stage2.eventlog
      # mv ghc-stage2.eventlog.json with-master.eventlog.json
      #
      # ../../compilers/ghc-linear -ddump-timings Main.hs +RTS -p -l-au
      # hs-speedscope ghc-stage2.eventlog
      # mv ghc-stage2.eventlog.json with-linear.eventlog.json

      touch with-master.eventlog.json
      touch with-linear.eventlog.json

      popd > /dev/null
    done
    popd > /dev/null
  '';
  installPhase = ''
    mkdir -p $out
    pushd tests > /dev/null

    for test_dir_raw in $(find . -maxdepth 1 -mindepth 1 -type d)
    do
      export test_dir=$(echo "$test_dir_raw" | cut -c 3-)

      mkdir -p $out/$test_dir
      cp $test_dir/with-master.eventlog.json $out/$test_dir
      cp $test_dir/with-linear.eventlog.json $out/$test_dir
    done

    popd > /dev/null
  '';
}
