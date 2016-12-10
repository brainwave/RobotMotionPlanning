function [ G ] = generateAdjMatrix( n )
%GENERATEADJMATRIX 
%Input - dimension of the matrix n
%Output - Adjacency Matrix G, nxn
%   Detailed explanation goes here
G = round(rand(n));
G = triu(G) + triu(G,1)';
G = G - diag(diag(G));

end

