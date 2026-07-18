using LinearAlgebra

G = [1 .2 .1;.1 2 .1; .3 .1 3]
G1 = [1 0 0; 0 2 0; 0 0 3]
G2 = [0 .2 .1;.1 0 .1; .3 .1 0]
sigma = .01
Pmax = .1
for St in 2:0.1:4
    A = G1-St*G2
    p_star = inv(A) * St * sigma * [1 ; 1 ; 1]
    if all(0 .<= p_star .<= Pmax)
	    println(St)
    end
end
