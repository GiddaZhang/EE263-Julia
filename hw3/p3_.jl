# Nominal values
n = 20
t0, r0 = 0.96, 0.02

# Compute S for a given set of coefficients (backward recursion from before)
function scattering(t, r, n)
    S = 1.0                       # S_n = 1 (reflective last interface)
    for i in n-1:-1:1
        S = r[i] + t[i]^2 * S / (1 - r[i] * S)
    end
    return S
end

# Try fault at each interface k = 1, ..., n-1
Smeas = 0.70
Sf = zeros(n-1)
for k in 1:n-1
    t = fill(t0, n-1); r = fill(r0, n-1)
    t[k], r[k] = 0.02, 0.96       # reversed coefficients at faulted interface
    Sf[k] = scattering(t, r, n)
end

# Pick k most consistent with the measurement
err = abs.(Sf .- Smeas)
kbest = argmin(err)

for k in 1:n-1
    println("k = $k:  S_fault = $(round(Sf[k], digits=4))")
end
println("\nMeasured S = $Smeas  →  most consistent fault: k = $kbest ",
        "(S_fault = $(round(Sf[kbest], digits=4)))")