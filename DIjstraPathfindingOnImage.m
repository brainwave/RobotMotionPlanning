%clear variables
clear; clc;

%read a picture, in this case obstacle.bmp
img = imread('obstacle.bmp'); imshow(img); hold on;

%Get start and end points
[xscreen, yscreen]=ginput(2);

% inputs
StartPoint = [xscreen(1), yscreen(1)];
EndPoint   = [xscreen(2), yscreen(2)];  



%thicken wall to decrease number of options
%walls = imdilate(img < 128, ones(9,9));
%imshow(walls)
%title('Thickened walls')

[n, m] = size(img);

%Define cost matrix by dialating the walls (to account for robot dimension
% Calculate distance matrix
%In the distance matrix, (weighted adjacency matrix), the i indexes are the source the j indexs are the target
D = im2graph(double(imdilate(img < 128, ones (14,14)))*n*m+1);
%the above function is courtesy of MathWorks, Filexchange

% Find shortest , we use the inbuilt pathfinder for brevity
[~, path] = graphshortestpath(D, sub2ind([n m],...
    StartPoint(2), StartPoint(1)), sub2ind([n m], EndPoint(2),   EndPoint(1)));

[y, x] = ind2sub([n m], path);

%Plot our results
plot(StartPoint(1), StartPoint(2), 'black*');
plot(EndPoint(1), EndPoint(2), 'blue*');
hold on;

legend('Start point', 'End Point');
%imshow(img); colormap gray; axis image;
plot(x, y, '-g', 'Linewidth', 3)
title('Path found between user selected points using Dijkstra Algorithm')