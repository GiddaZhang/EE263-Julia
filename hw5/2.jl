using LinearAlgebra
B = [2 1 0 1 -1 ; 3 0 4 1 2 ; -3 -1 2 -1 1; -1 0 -3 -3 2]
h1 = B \ [1;0;1;0]
h2 = B \ [0;1;0;1]
println("Solution for h1:")
display(h1)
println("Solution for h2:")
display(h2)