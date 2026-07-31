using LinearAlgebra
using Plots

A = zeros(3, 10)
for i in 1:10
    A[1, i] = (-2 * i + 21) / 2
    A[2, i] = 1
    A[3, i] = max((-2 * i + 11) / 2, 0)
end
f_star = A' * inv(A * A') * [1; 0; 0]

P_mat = zeros(10, 10)
P_dot_mat = zeros(10, 10)
for i in 1:10
    for j in 1:10
        P_mat[i, j] = max(0, (-2 * j + 2 * i + 1) / 2)
        if j <= i
            P_dot_mat[i, j] = 1
        end
    end
end

P_dot = P_dot_mat * f_star
P = P_mat * f_star

# plot P and P_dot and f in three figures
plot(1:10, P, label="P", xlabel="i", ylabel="Value", title="Plot of P and P_dot")
savefig("P_plot.png")
plot(1:10, P_dot, label="P_dot", xlabel="i", ylabel="Value", title="Plot of P_dot")
savefig("P_dot_plot.png")
plot(1:10, f_star, label="f_star", xlabel="i", ylabel="Value", title="Plot of f_star")
savefig("f_star_plot.png")