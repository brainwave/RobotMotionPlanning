function [ path ] = relaxationRoutine( Graph, path, newVertex, minNode )
%RELAXATIONROUTINE Summary of this function goes here
%   Detailed explanation goes here
    d1 = path(2,path(1,:) == minNode) + distance(Graph, minNode, newVertex);
    d2 = path(2,path(1,:) == newVertex);
    
        if d1 <= d2
                    %update parent
                    path(3,path(1,:) == newVertex) = minNode;
                    path(2,path(1,:) == newVertex) = d1;
        end
end %endfunction