using LinearAlgebra
using JSON

data = JSON.parsefile("rational_interpolation_data.json")

N = data["N"].data
x = Float64.(data["x"].data)
y = Float64.(data["y"].data)

function find_min_degree(x, y, N)
    m = 2
    while true
        A = ones(N, 2*m + 1)
        for i in 1:N
            for j in 1:m
                A[i, j+1] = x[i]^j
                A[i, j+m+1] = -y[i]*x[i]^j
            end
        end
        if rank(A) == rank([A y])
            return m, A
        end
        m += 1
    end
end

m, A = find_min_degree(x, y, N)
theta = A \ y
println("Minimum degree m: ", m)
println("Coefficients theta: ", round.(theta, digits=3))
a = theta[1:m+1]
b = theta[m+2:2*m+1]
err = y - [sum(a[j+1]*x[i]^j for j in 0:m) / (1 + sum(b[j]*x[i]^j for j in 1:m)) for i in 1:length(x)]
println("Coefficients theta: ", round.(err, digits=3))
x_plot = range(minimum(x), stop=maximum(x), length=100)
y_plot = [sum(a[j+1]*x_plot[i]^j for j in 0:m) / (1 + sum(b[j]*x_plot[i]^j for j in 1:m)) for i in 1:length(x_plot)]
# Plotting the results
using Plots
scatter(x, y, label="Data Points", legend=:topleft)
plot!(x_plot, y_plot, label="Rational Interpolation", color=:red)
savefig("p8_plot.png")