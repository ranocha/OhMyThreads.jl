```@meta
EditURL = "mc.jl"
```

# Parallel Monte Carlo

Calculate the value of $\pi$ through parallel direct Monte Carlo.

A unit circle is inscribed inside a unit square with side length 2 (from -1 to 1).
The area of the circle is $\pi$, the area of the square is 4, and the ratio is $\pi/4$.
This means that, if you throw $N$ darts randomly at the square, approximately $M=N\pi/4$
of those darts will land inside the unit circle.

Throw darts randomly at a unit square and count how many of them ($M$) landed inside of
a unit circle. Approximate $\pi \approx 4M/N$.

## Sequential implementation:

````julia
function mc(N)
    M = 0 # number of darts that landed in the circle
    for i in 1:N
        if rand()^2 + rand()^2 < 1.0
            M += 1
        end
    end
    pi = 4 * M / N
    return pi
end

N = 100_000_000

mc(N)
````

````
3.141517
````

## Parallelization with `tmapreduce`

To parallelize the Monte Carlo simulation, we use [`tmapreduce`](@ref) with `+` as the reduction
operator. For the map part, we take `1:N` as our input collection and "throw one dart" per
element.

````julia
using OhMyThreads

function mc_parallel(N)
    M = tmapreduce(+, 1:N) do i
        rand()^2 + rand()^2 < 1.0
    end
    pi = 4 * M / N
    return pi
end

mc_parallel(N)
````

````
3.14159924
````

Let's run a quick benchmark.

````julia
using BenchmarkTools
using Base.Threads: nthreads

@assert nthreads() > 1 # make sure we have multiple Julia threads
@show nthreads()       # print out the number of threads

@btime mc($N) samples=10 evals=3;
@btime mc_parallel($N) samples=10 evals=3;
````

````
nthreads() = 5
  318.467 ms (0 allocations: 0 bytes)
  88.553 ms (37 allocations: 3.02 KiB)

````

## Manual parallelization

First, using the `chunks` function, we divide the iteration interval `1:N` into
`nthreads()` parts. Then, we apply a regular (sequential) `map` to spawn a Julia task
per chunk. Each task will locally and independently perform a sequential Monte Carlo
simulation. Finally, we fetch the results and compute the average estimate for $\pi$.

````julia
using OhMyThreads: @spawn

function mc_parallel_manual(N; nchunks = nthreads())
    tasks = map(chunks(1:N; n = nchunks)) do idcs # TODO: replace by `tmap` once ready
        @spawn mc(length(idcs))
    end
    pi = sum(fetch, tasks) / nchunks
    return pi
end

mc_parallel_manual(N)
````

````
3.1415844
````

And this is the performance:

````julia
@btime mc_parallel_manual($N) samples=10 evals=3;
````

````
  63.825 ms (31 allocations: 2.80 KiB)

````

It is faster than `mc_parallel` above because the task-local computation
`mc(length(idcs))` is faster than the implicit task-local computation within
`tmapreduce` (which itself is a `mapreduce`).

````julia
idcs = first(chunks(1:N; n = nthreads()))

@btime mapreduce($+, $idcs) do i
    rand()^2 + rand()^2 < 1.0
end samples=10 evals=3;

@btime mc($(length(idcs))) samples=10 evals=3;
````

````
  87.617 ms (0 allocations: 0 bytes)
  63.398 ms (0 allocations: 0 bytes)

````

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

