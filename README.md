# GHC compile time performance comparison

This repository contains a Nix derivation that allows us to obtain a
comparison between two given GHC executables using perf tests from the GHC
test suite.

GHC must be compiled from sources using the `build.mk` file from this
repository. The file selects `prof` build flavour and makes sure that the
[eventlog][eventlog] feature is enabled.

Once GHC is compiled, copy `inplace/bin/ghc-stage2` to this directory as
`compliers/ghc-master` or `compilers/ghc-linear` according to the repo you
used.

To obtain the [speedscope][speedscope] graphs run:

```shell
$ make-graphs.sh
```

To view the flamegraphs, go to the [Speedscope][speedscope] site and click
“browse”. Locate the graphs in the `result` directory that should have
appeared after the build.

NOTE: the entire process could be just a `nix-build` but for that both GHCs
would need to be compiled via `nix-build` as well. Since in development it
is often not the case (even when `nix-shell` is used to provide
dependencies), we would either have to copy entire trees of compiled GHC to
nix store every time or implement generation of the graphs as a simple shell
script (which is what I've chosen).

[eventlog]: https://gitlab.haskell.org/ghc/ghc/wikis/event-log
[speedscope]: https://www.speedscope.app/

https://gitlab.haskell.org/tweag/ghc/-/jobs/253665
