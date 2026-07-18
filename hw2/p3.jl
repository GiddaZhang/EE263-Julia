using LinearAlgebra

A = [-1 0 0 -1 1; 0 1 1 0 0; 1 0 0 1 0]
B_a = [1 0 0.5; 0 0 0; 0 1 0; -1 0 0.5;1 0 1]
B_d = [0 0 0.5; 0 1/2 0; 0 1/2 0; 0 0 1/2;1 0 1]
B_f = [0 0 0; 0 1/2 0; 0 1/2 0; 0 0 1;1 0 1]
C_a = A * B_a
C_d = A * B_d
C_f = A * B_f
println("(a) A * B = ")
display(C_a)
println("(d) A * B = ")
display(C_d)
println("(f) A * B = ")
display(C_f)
