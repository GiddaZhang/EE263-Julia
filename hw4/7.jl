using LinearAlgebra
using JSON
using Statistics
using Plots

function calc_g(n, f, mu)
    A = zeros(n, n)
    for i = 3:n-2
        A[i, i-2] = 2
        A[i, i-1] = -8
        A[i, i] = 12
        A[i, i+1] = -8
        A[i, i+2] = 2
    end
    A[1, 1] = 2
    A[1, 2] = -4
    A[1, 3] = 2
    A[2, 1] = -4
    A[2, 2] = 10
    A[2, 3] = -8
    A[2, 4] = 2
    A[n-1, n-3] = 2
    A[n-1, n-2] = -8
    A[n-1, n-1] = 10
    A[n-1, n] = -4
    A[n, n-2] = 2
    A[n, n-1] = -4
    A[n, n] = 2
    B = 2/n*I + mu * n^4/(n-2)*A
    g = B \ (2/n*f)
    return g
end

data = JSON.parsefile("curve_smoothing.json")
n = data["n"].data
f = Float64.(data["f"].data)
mu = .000001
g = calc_g(n, f, mu)
# plot g and f (dashed), with legend and labels, and save the plot as "smoothed_curve.png"
plot(g, label="g", color=:blue)
plot!(f, label="f", color=:red, linestyle=:dash)
xlabel!("Index")
ylabel!("Value")
title!("Curve Smoothing, mu=" * string(mu))
savefig("smoothed_curve.png")
