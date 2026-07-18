using Plots

# Parameters
n = 20
t = fill(0.96, n-1)
r = fill(0.02, n-1)

# Backward recursion for local reflectances S_i = y_i / x_i
S = zeros(n)
S[n] = 1.0                        # totally reflective last interface: y_n = x_n
for i in n-1:-1:1
    S[i] = r[i] + t[i]^2 * S[i+1] / (1 - r[i] * S[i+1])
end

# Forward pass to recover amplitudes
x = zeros(n)
y = zeros(n)
x[1] = 1.0
for i in 1:n-1
    x[i+1] = t[i] * x[i] / (1 - r[i] * S[i+1])
end
y .= S .* x

println("Scattering coefficient S = ", S[1])

# Plot
plot(1:n, x, marker=:circle, label="xᵢ (right-traveling)",
     xlabel="layer i", ylabel="amplitude", xticks=1:n, legend=:right)
plot!(1:n, y, marker=:square, label="yᵢ (left-traveling)")
# Save the plot to a file
savefig("amplitudes_plot.png")