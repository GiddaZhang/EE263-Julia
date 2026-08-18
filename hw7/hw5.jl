using LinearAlgebra, Plots
include("readclassjson.jl")

data = readclassjson("regl_data.json")
c = data["c"]
w = data["w"]
x = data["x"]
n = data["n"]

h = Int((length(c) - 1) / 2)

A = zeros(n, n)
for i in 1:n
    for j in 1:n
        if abs(i - j) <= h
            A[i, j] = c[h + 1 + (i - j)]
        end
    end
end
# a)
F = svd(A)
sigma = F.S
plot(1:n, sigma, xlabel="k", ylabel="sigma_k",
     title="Singular values of A", legend=false, lw=2, marker=:circle, markersize=2)
savefig("hw5_figs/singular_values.png")

# b)
V = F.V
for j in 1:6
    plot(1:n, V[:, j], xlabel="i", ylabel="v_$(j)_i",
         title="Singular vector v_$j", legend=false, lw=2, marker=:circle, markersize=2)
    savefig("hw5_figs/singular_vector_$j.png")
end

# c)
y_meas = A * x + w
U = F.U
x_ls = V * inv(Diagonal(F.S)) * U' * y_meas
plot(1:n, x_ls, xlabel="i", ylabel="x_ls[i]", title="Least-squares estimate of x", legend=false, lw=2, marker=:circle, markersize=2)
savefig("hw5_figs/least_squares_estimate.png")

# d)
for r in [5, 10, 15, 30, 50]
    A_est = V[:, 1:r] * inv(Diagonal(F.S[1:r])) * U[:, 1:r]'
    x_est = A_est * y_meas
    plot(1:n, x_est, xlabel="i", ylabel="x_est[i]", title="Estimate of x using rank-$r approximation", legend=false, lw=2, marker=:circle, markersize=2)
    savefig("hw5_figs/estimate_rank_$r.png")
end

# e)
errs = zeros(35)
for r in 1:35
    A_est = V[:, 1:r] * inv(Diagonal(F.S[1:r])) * U[:, 1:r]'
    x_est = A_est * y_meas
    err = norm(x - x_est)
    errs[r] = err
end
plot(1:35, errs, xlabel="r", ylabel="||x - x_est||_2", title="Error vs. rank of approximation", legend=false, lw=2, marker=:circle, markersize=2)
savefig("hw5_figs/error_vs_rank.png")

# f)
r_optimal = argmin(errs)
println("Optimal rank for approximation: $r_optimal")
A_est_optimal = V[:, 1:r_optimal] * inv(Diagonal(F.S[1:r_optimal])) * U[:, 1:r_optimal]'
x_est_optimal = A_est_optimal * y_meas
plot(1:n, x_est_optimal, xlabel="i", ylabel="x_est_optimal[i]", title="Estimate of x using optimal rank-$r_optimal approximation", legend=false, lw=2, marker=:circle, markersize=2)
savefig("hw5_figs/estimate_optimal_rank_$r_optimal.png")

# g)
# use Tychonov regularization, minimize ||Ax - y||^2 + mu||x||^2
mu = 0.1
x_reg = inv(A' * A + mu * I) * A' * y_meas
plot(1:n, x_reg, xlabel="i", ylabel="x_reg[i]", title="Tikhonov regularization estimate of x", legend=false, lw=2, marker=:circle, markersize=2)
savefig("hw5_figs/tikhonov_regularization_estimate.png")