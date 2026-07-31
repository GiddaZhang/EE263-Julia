using LinearAlgebra
using Plots

J1s = []
J2s = []
for i = 1:50
    B = [9.5 8.5 7.5 6.5 5.5 4.5 3.5 2.5 1.5 0.5;
         1 1 1 1 1 1 1 1 1 1;]
    mu = 0.001 * 10^((i-1) / 10)
    B_ = [B ; mu * I(10)]
    c = [10 ; 1 ; zeros(10)]
    f_star = -inv(B_' * B_) * B_' * c
    J1 = norm(B * f_star + [10 ; 1])^2
    J2 = norm(f_star)^2
    push!(J1s, J1)
    push!(J2s, J2)     
end
plot(J1s, J2s)
xlims!(0, 100)
ylims!(0, .4)
savefig("J1_J2_plot.png")