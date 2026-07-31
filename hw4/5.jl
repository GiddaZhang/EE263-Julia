using LinearAlgebra
using JSON
using Statistics

data = JSON.parsefile("inductor_data.json")

N = data["N"].data
D = Float64.(data["D"].data)
L = Float64.(data["L"].data)
d = Float64.(data["d"].data)
n = Float64.(data["n"].data)
w = Float64.(data["w"].data)

A = ones(N, 5)
for i in 1:N
    A[i, 2] = log(n[i])
    A[i, 3] = log(w[i])
    A[i, 4] = log(d[i])
    A[i, 5] = log(D[i])
end
b = log.(L)
x = inv(A' * A) * A' * b
alpha, beta1, beta2, beta3, beta4 = x
alpha = exp(alpha)
L_hat = alpha * n.^beta1 .* w.^beta2 .* d.^beta3 .* D.^beta4
e_mean = mean(abs.(L - L_hat)./L) * 100
println("alpha = $alpha")
println("beta1 = $beta1")
println("beta2 = $beta2")
println("beta3 = $beta3")
println("beta4 = $beta4")
println("Mean relative error = $e_mean %")