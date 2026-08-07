using LinearAlgebra
using Statistics
using JSON

data = JSON.parsefile("ellip_bdry_data.json")
X = Float64.(reduce(hcat, data["X"]["data"])')
function estimate_A(X)
    n = size(X, 1)
    N = size(X, 2)
    C = zeros(N, n * (n + 1) ÷ 2)

    for m = 1:N
        i = 1
        j = 1
        for k = 1:(n * (n + 1) ÷ 2)
            if i == j
                C[m, k] = X[i, m] * X[j, m]
            else
                C[m, k] = 2 * X[i, m] * X[j, m]
            end
            j += 1
            if j > n
                i += 1
                j = i
            end
        end
    end

    a = C \ ones(N)

    A = zeros(n, n)
    i = 1
    j = 1
    for k = 1:(n * (n + 1) ÷ 2)
        A[i, j] = a[k]
        A[j, i] = a[k]
        j += 1
        if j > n
            i += 1
            j = i
        end
    end
    error = mean(abs.(C * a - ones(N)))
    return A, error
end

A, error = estimate_A(X)
eigenvalues, eigenvectors = eigen(A)
println("Mean absolute error: ", error)
display(eigenvalues)