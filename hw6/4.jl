using Plots
using LinearAlgebra

function plot_ellipse(A)
    theta = range(0, 2pi, length=1000)
    a11, a12, a22 = A[1,1], A[1,2], A[2,2]
    r = 1 ./ sqrt.(a11 .* cos.(theta).^2 .+ 2a12 .* cos.(theta) .* sin.(theta) .+ a22 .* sin.(theta).^2)
    x = r .* cos.(theta)
    y = r .* sin.(theta)
    return x, y
end

A_2 = [1 0 ; 0 2]
x, y = plot_ellipse(A_2)
plot(x, y, aspect_ratio=:equal)
savefig("ellipse_plot_2.png")

A_3 = [0.2 -0.1 ; -0.1 0.4]
x, y = plot_ellipse(A_3)
eigenvalues, eigenvectors = eigen(A_3)
e_1 = eigenvectors[:,1]
e_2 = eigenvectors[:,2]
plot(x, y, aspect_ratio=:equal)
plot!([0, e_1[1]], [0, e_1[2]], lw=2, label="axis 1")
plot!([0, e_2[1]], [0, e_2[2]], lw=2, label="axis 2")
savefig("ellipse_plot_3.png")

b_1 = [0.89 ; 0.45]
b_2 = [0.45 ; 0.89]
b_3 = [-0.71 ; 0.71]
B = b_1 * b_1' + b_2 * b_2' + b_3 * b_3'
x, y = plot_ellipse(B)
plot(x, y, aspect_ratio=:equal)
plot!([0, b_1[1]], [0, b_1[2]], lw=2, label="b_1")
plot!([0, b_2[1]], [0, b_2[2]], lw=2, label="b_2")
plot!([0, b_3[1]], [0, b_3[2]], lw=2, label="b_3")
savefig("ellipse_plot_B.png")