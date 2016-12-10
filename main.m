%cleanup
clear; clc;

source = 1;

%generate adjacency matrix
graph_dim = 100;
goal = 100;

%Graph = generateAdjMatrix ( graph_dim );
Graph = random_graph(graph_dim,0.1);
%Graph(source,source) = 0;
parallelDijkstra(source, Graph);

%assign random weights

%spt = Dijkstra(source, goal, Graph)
