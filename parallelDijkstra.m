function globalMinD = parallelDijkstra ( source, distanceMatrix )
rowMax = size(distanceMatrix,2); vertexList(1) = source; vertexList(2:rowMax) = 0;
%Initialize the distances to what was obtained from distance Matrix
  globalMinD(1:rowMax) = distanceMatrix(1,1:rowMax);
  
  %start the parallel pools, and split nodes between number of processor
  %available
  spmd    
    p_nu = numlabs();
    startNode = floor(((labindex()-1)*rowMax)/p_nu)+1;
    endNode = floor ((labindex()*rowMax)/p_nu );
  end
  
  lab_count = p_nu{1};
  for step = 2 : rowMax
    
    spmd
      [localmind, localminv] = nearest (startNode, endNode, globalMinD, vertexList);
    end

    %initialize global minimum distance and vertex
    globalmin = Inf;
    globalv = -1;

    for i = 1 : lab_count
      if ( localmind{i} < globalmin )
        globalmin = localmind{i};
        globalv = localminv{i};
      end
    end
    
    %relaxation routine
    vertexList(globalv) = 1;
    globalMinD(globalv) = globalmin;

%  Each worker updates the minimum distance information for the nodes
%  it is responsible for.
%
    spmd
      localMinD = update ( startNode, endNode, globalv, vertexList, distanceMatrix, globalMinD );
    end
%
%  The client updates the global copy.
%
    globalMinD = [];
    for i = 1 : lab_count
      globalMinD = [ globalMinD localMinD{:} ];
    end

  end

  return
end

function [ distance,vertex ] = nearest ( my_s, my_e, mind, connected )

  distance = Inf;
  vertex = -1;
  for i = my_s : my_e
    if ( ~connected(i) && mind(i) < d )
      distance = mind(i);
      vertex = i;
    end
  end
  return;
end

function MinD = update ( startNode, endNode, globalv, vertexList, distanceMatrix, minglobalMinDd )
  for i = startNode : endNode
    if ( ~vertexList(i) )
      if ( distanceMatrix(globalv,i) < Inf )
        minglobalMinDd(i) = min ( minglobalMinDd(i), minglobalMinDd(globalv) + distanceMatrix(globalv,i) );
      end
    end
  end
  MinD = minglobalMinDd(startNode:endNode);

  return
end
