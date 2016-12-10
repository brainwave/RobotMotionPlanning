function graph = im2graph(im, varargin)

%This function is courtesy of Y Simson, at Mathworks.com.
%This function converts an image into a sparse matrix, thereby rendering it
%useful for graph search technique
 


%% Argument Check
if ( nargin == 2 )
    conn = varargin{1};
elseif ( nargin == 1 )
    conn = 4;
end

if ( conn ~= 4 && conn ~= 8 )
    error('2nd argument is the type of neighborhood connection. Must be either 4 or 8');
end

%% image dimensions
[M, N] = size(im);
MxN = M*N;

%% Calculate distance matrix
%In the distance matrix, (weighted adjancy matrix), the i indexes are the source the j indexs are the target

CostVec = reshape(im, MxN, 1);%stack columns

%Create sparse matrix to represent the graph
if ( conn == 4 )
    %%%%%%%%%%%%
    % *  -1  * %
    %-M   *  M %
    % *   1  * %
    %%%%%%%%%%%%
    graph = spdiags(repmat(CostVec,1,4), [-M -1 1 M], MxN, MxN);
elseif( conn == 8 )
    %%%%%%%%%%%%%%%
    %-M-1 -1  M-1 %
    %-M    *  M   %
    %-M+1  1  M+1 %
    %%%%%%%%%%%%%%%

    graph = spdiags(repmat(CostVec,1,8), [-M-1, -M, -M+1, -1, 1, M-1, M, M+1], MxN, MxN);
    %set to inf to disconect top from bottom rows
    graph(sub2ind([MxN, MxN], (2:N-1)*M+1,(2:N-1)*M - M))   = inf;%top->bottom westwards(-M-1)
    graph(sub2ind([MxN, MxN], (1:N)*M,    (1:N)*M - M + 1)) = inf;%bottom->top westwards(-M+1)
    
    graph(sub2ind([MxN, MxN], (0:N-1)*M+1,(0:N-1)*M + M))     = inf;%top->bottom eastwards(M-1)
    graph(sub2ind([MxN, MxN], (1:N-2)*M,  (1:N-2)*M + M + 1)) = inf;%bottom->top eastwards(M+1)
end

%set to inf to disconect top from bottom rows
graph(sub2ind([MxN, MxN], (1:N-1)*M+1, (1:N-1)*M))     = inf;%top->bottom
graph(sub2ind([MxN, MxN], (1:N-1)*M,   (1:N-1)*M + 1)) = inf;%bottom->top
