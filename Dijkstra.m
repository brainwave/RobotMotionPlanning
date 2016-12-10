function [ spt ] = Dijkstra( source, goal, Graph )
%SERIALDIJKSTRA Summary of this function goes here
%   Detailed explanation goes here

%convert all exiting zeros (representing absence of edges) to NaN
    %this is done so we can re-use 0 as a valid vertex-vertex distance 
    %in graph

%get dimensions of graph
[rowMax, colMax] = size(Graph);

%convert all exiting zeros (representing absence of edges) to NaN
    %this is done so we can re-use 0 as a valid vertex-vertex distance 
    %in graph

Graph = graph(Graph, 'Upper','OmitSelfLoops');
axis('tight');
visual_plot = plot(Graph,'LineWidth',3.0);
hold on;

%silly variables
path    = [ (1:rowMax)*NaN; (1:rowMax)*Inf; (1:rowMax)*NaN; ones(1,rowMax)*1 ] ;

%define enumerations to use later, using caps to distinguish enums from
%variable names (camelCased)
VERTEX      = 1;
DISTANCE    = 2;
PARENT      = 3;
UNVISITED   = 4;

%assign value to source vertex
path ( [VERTEX PARENT], source ) = source;
path ( DISTANCE, source)         = 0;
path ( UNVISITED, source)        = true;
currentVertex                    = source;


%Algorithm
while (~isnan(currentVertex)) && (currentVertex ~= goal) && any(path(4,:))
    
    %update current pointers
    currentVertex = min(path(1,path(4,:) == true));
    if isnan(currentVertex)
        warning('No path form source leads to goal');
        break;
    end
    
    minNode = path(1,currentVertex);
    path(4,currentVertex) = false;
            
    %pull the nodes connected with nodes under consideration, store
    newVertex = Graph.Edges.EndNodes(Graph.Edges.EndNodes(:,1)==minNode,2)';
    
    if any(newVertex)
        %push neighbours into path, with parent 1, but don't update distances
        %cause its already infinity by initialization

        for i = 1:1:numel(newVertex)

            %Add newly found elements to the tree being traversed
            path( [VERTEX PARENT],newVertex(i) ) = [newVertex(i) minNode];

            %Update current distance estimates for all nodes in path
            path = relaxationRoutine(Graph, path, newVertex(i), minNode);

        end
      
    end
end

if currentVertex == goal

    currentVertex = goal;
    spt = [[];[];[]];

    while currentVertex ~= source
        spt = [spt, path([1 2 3],path(1,:)==currentVertex)];
        currentVertex = path(3,path(1,:)==currentVertex);
    end

    spt = [spt, [currentVertex;0; currentVertex]];

    %reconstruct graph to plot it
    
    Graph = graph(spt(1,:), spt(3,:), spt(2,:));
    highlight(visual_plot,spt(size(spt(1,:)):-1:1,:), 'EdgeColor', 'g')
  
else
    warning('No path found from source to goal, check graph connectivity and weights');
    spt = 0;
end
