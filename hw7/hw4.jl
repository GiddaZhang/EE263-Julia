using LinearAlgebra, Plots
include("readclassjson.jl")

data = readclassjson("digits.json")
X = data["X"]
n, N = size(X)
x_bar = sum(X, dims=2) / N
X_tilde = X .- x_bar

F = svd(X_tilde)
sigma = F.S
cumvar = cumsum(sigma.^2)
totalvar = sum(sigma.^2)
rho = cumvar / totalvar

plot(1:n, rho, xlabel="k", ylabel="rho_k",
     title="Fraction of variance captured by first k PCs",
     legend=false, lw=2, marker=:circle, markersize=2)
hline!([0.9], ls=:dash, color=:red, label="90%")
savefig("variance.png")
k90 = findfirst(rho .>= 0.9)
println("Components needed for 90% variance: $k90")

# ii
U = F.U
p_mean = heatmap(reshape(x_bar, 8, 8)', yflip=true, c=:grays,
    aspect_ratio=:equal, axis=false, title="Mean", cbar=false)
pc_plots = [heatmap(reshape(U[:,j], 8, 8)', yflip=true, c=:grays,
    aspect_ratio=:equal, axis=false, title="PC $j", cbar=false) for j in 1:4]
plot(p_mean, pc_plots..., layout=(1,5), size=(800,200))
savefig("principal_components.png")


examples = [1, 2, 3, 4, 5]
ks = [2, 6, 12, 24]

plots_grid = []
for idx in examples
    x_tilde_i = X_tilde[:, idx]
    # Original
    push!(plots_grid, heatmap(reshape(X[:, idx], 8, 8)', yflip=true,
        c=:grays, aspect_ratio=:equal, axis=false,
        title="Orig", cbar=false))
    for k in ks
        Q = U[:, 1:k]
        x_hat = x_bar .+ Q * (Q' * x_tilde_i)
        push!(plots_grid, heatmap(reshape(x_hat, 8, 8)', yflip=true,
            c=:grays, aspect_ratio=:equal, axis=false,
            title="k=$k", cbar=false))
    end
end
plot(plots_grid..., layout=(length(examples), length(ks)+1),
    size=(900, 200*length(examples)))
savefig("reconstructions.png")

# iii
k = 10
Q10 = U[:, 1:k]
err_direct = 0.0
for i in 1:N
    global err_direct
    x_hat_i = x_bar .+ Q10 * (Q10' * X_tilde[:, i])
    err_direct += norm(X[:, i] - x_hat_i)^2
end
err_direct /= N

err_svd = sum(sigma[k+1:end].^2) / N

println("MSE (direct computation):  $err_direct")
println("MSE (sum of discarded σ²): $err_svd")
println("Fraction of variance lost: $(err_svd / totalvar)")