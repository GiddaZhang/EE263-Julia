using LinearAlgebra
using JSON

data = JSON.parsefile("sysid_data.json")
X = Float64.(reduce(hcat, data["X"]["data"])')
Y = Float64.(reduce(hcat, data["Y"]["data"])')

A = Y * X' * inv(X * X')  # least squares solution
println("Estimated system matrix A:")
display(A)

