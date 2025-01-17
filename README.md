# OhMyThreads

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://JuliaFolds2.github.io/OhMyThreads.jl/dev

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://JuliaFolds2.github.io/OhMyThreads.jl/stable

[ci-img]: https://github.com/JuliaFolds2/OhMyThreads.jl/actions/workflows/ci.yml/badge.svg
[ci-url]: https://github.com/JuliaFolds2/OhMyThreads.jl/actions/workflows/ci.yml

[cov-img]: https://codecov.io/gh/JuliaFolds2/OhMyThreads.jl/branch/master/graph/badge.svg
[cov-url]: https://codecov.io/gh/JuliaFolds2/OhMyThreads.jl

[lifecycle-img]: https://img.shields.io/badge/lifecycle-experimental-red.svg

[code-style-img]: https://img.shields.io/badge/code%20style-blue-4495d1.svg
[code-style-url]: https://github.com/invenia/BlueStyle

<!--
![Lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-retired-orange.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-archived-red.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-dormant-blue.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)
-->

*Simple Multithreading in Julia*

| **Documentation**                                                               | **Build Status**                                                                                |  **Quality**                                                                                |
|:-------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] | [![][ci-img]][ci-url] [![][cov-img]][cov-url] | ![][lifecycle-img] |

[OhMyThreads.jl](https://github.com/JuliaFolds2/OhMyThreads.jl/) is meant to be a simple, unambitious package that provides user-friendly ways of doing task-parallel multithreaded calculations in Julia. Most importantly, it provides an API of higher-order functions, with a
focus on [data parallelism](https://en.wikipedia.org/wiki/Data_parallelism), that can be used without having to worry much about manual [Task](https://docs.julialang.org/en/v1/base/parallel/) creation.

Unlike most [JuliaFolds2](https://github.com/JuliaFolds2) packages, OhMyThreads.jl is not built off of [Transducers.jl](https://github.com/JuliaFolds2/Transducers.jl), nor is it a building block for Transducers.jl. Rather, it is meant to be a simpler, more maintainable, and more accessible alternative to high-level packages like, e.g., [ThreadsX.jl](https://github.com/tkf/ThreadsX.jl) or [Folds.jl](https://github.com/JuliaFolds2/Folds.jl).

## Example

```julia
using OhMyThreads

function mc_parallel(N; kw...)
    M = tmapreduce(+, 1:N; kw...) do i
        rand()^2 + rand()^2 < 1.0
    end
    pi = 4 * M / N
    return pi
end

N = 100_000_000
mc_parallel(N) # gives, e.g., 3.14159924

using BenchmarkTools

@show Threads.nthreads()          # 5 in this example

@btime mc_parallel($N; nchunks=1) # effectively running with a single Julia thread
@btime mc_parallel($N)            # running with all 5 Julia threads
```

Timings might be something like this:

```
438.394 ms (7 allocations: 624 bytes)
88.050 ms (37 allocations: 3.02 KiB)
```

(Check out the full [Parallel Monte Carlo](https://juliafolds2.github.io/OhMyThreads.jl/stable/examples/mc/mc/) example if you like.)

## Documentation

For more information, please check out the [documentation](https://JuliaFolds2.github.io/OhMyThreads.jl/stable) of the latest release (or the [development version](https://JuliaFolds2.github.io/OhMyThreads.jl/dev) if you're curious).

