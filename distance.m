function [ dist ] = distance( Graph, vertex1, vertex2 )
%DISTANCE Summary of this function goes here
%   Detailed explanation goes here
    dist=Graph.Edges.Weight(Graph.Edges.EndNodes(Graph.Edges.EndNodes(:,1) == vertex1, 2) == vertex2);

end

