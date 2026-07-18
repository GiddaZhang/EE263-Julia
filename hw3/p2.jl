using LinearAlgebra
using JSON

data = JSON.parsefile("robot_coin_collector.json")

n = data["n"].data
x = Float64.(data["x"].data)

A = zeros(2*n, 2*n)
for i in 1:2*n
    j = 1
    while 2*(i + 1 - 2*j) > 0
        A[i, j] = 2*(i + 1 - 2*j)
        j += 1
    end
    if i % 2 == 1
        A[i, j] = 1/2
    end
end
if rank(A) != rank([A x])
    println("No solution")
else
    sol = A \ x
    println("Solution: ", sol)
end

for i = 1:2*n
    # remove one row at a time and check if the system is still consistent
    A_reduced = A[setdiff(1:2*n, i), :]
    x_reduced = x[setdiff(1:2*n, i)]
    if rank(A_reduced) == rank([A_reduced x_reduced])
        println("Row $i can be removed without affecting consistency")
    end
end

# ---- part e ----
using Plots

# find removable coin(s)
removable = Int[]
for i in 1:2*n
    idx = setdiff(1:2*n, i)
    A_r, x_r = A[idx, :], x[idx]
    if rank(A_r) == rank([A_r x_r])
        push!(removable, i)
    end
end
println("Coin(s) whose removal makes the system consistent: ", removable)

i_bad = removable[1]                 # the coin that cannot be collected
idx   = setdiff(1:2*n, i_bad)

# solve the consistent reduced system for the n forces
An = A[:, 1:n]
f  = An[idx, :] \ x[idx]
println("Uncollectable coin: $i_bad at (x, y) = ($(x[i_bad]), $i_bad)")
println("Input f = ", f)
println("max |residual| on remaining coins: ",
        maximum(abs.(An[idx, :]*f - x[idx])))   # should be ~1e-12

# robot x-position at integer times t = 1..2n  (row t of A is c(t)ᵀ)
t_int = 1:2*n
x_rob = An * f

# plot
scatter(x, 1:2*n, label="coins", ms=6)
scatter!([x[i_bad]], [i_bad], label="missed coin", marker=:xcross, ms=9, color=:red)
plot!(x_rob, t_int, label="robot", marker=:circle, ms=3, lw=2)
xlabel!("x"); ylabel!("y = t")
savefig("coin_collector.png")