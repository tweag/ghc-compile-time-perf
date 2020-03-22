#!/usr/bin/env nix-shell
#!nix-shell -i bash --pure

set -euo pipefail

ghc_master="$(pwd)/compilers/ghc-master"
ghc_linear="$(pwd)/compilers/ghc-linear"

cd tests

for test_dir_raw in $(find . -maxdepth 1 -mindepth 1 -type d)
do
  test_dir=$(echo "$test_dir_raw" | cut -c 3-)

  echo "Doing $test_dir"

  pushd "$test_dir" > /dev/null

  SCRATCH=$(mktemp -d --tmpdir ghc-compile-time-perf.XXXX)
  cp Main.hs "$SCRATCH/Main.hs"
  pushd "$SCRATCH" > /dev/null
  $ghc_master -ddump-timings "$SCRATCH/Main.hs" +RTS -p -l-au > /dev/null
  # The name here is somewhat unreliable, because seem to depend on the name
  # of the executable, in this case ghc-stage2, but I suspect it can as well
  # be something different.
  hs-speedscope "$SCRATCH/ghc-stage2.eventlog"
  popd > /dev/null
  mv "$SCRATCH/ghc-stage2.eventlog.json" ./with-master.eventlog.json
  rm -rf "$SCRATCH"

  SCRATCH=$(mktemp -d --tmpdir ghc-compile-time-perf.XXXX)
  cp Main.hs "$SCRATCH/Main.hs"
  pushd "$SCRATCH" > /dev/null
  $ghc_linear -ddump-timings "$SCRATCH/Main.hs" +RTS -p -l-au > /dev/null
  hs-speedscope "$SCRATCH/ghc-stage2.eventlog"
  popd > /dev/null
  mv "$SCRATCH/ghc-stage2.eventlog.json" ./with-linear.eventlog.json
  rm -rf "$SCRATCH"

  popd > /dev/null
done
