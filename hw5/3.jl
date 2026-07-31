using LinearAlgebra
A = [-1 1 -1 -1 0 0 0; 0 -1 0 0 -1 0 0; 0 0 0 1 1 -1 0; 0 0 1 0 0 1 -1]
s = [1 ; 4 ; 10 ; 10]
f_star = A' * inv(A * A') * (-s)
f_simple = [5; 4 ; 0 ; 0 ; 0 ; 10 ; 20]
println("f_star = ", f_star)
println("mean square traffic f_star = ", norm(f_star)^2/7)
println("mean square traffic f_simple = ", norm(f_simple)^2/7)