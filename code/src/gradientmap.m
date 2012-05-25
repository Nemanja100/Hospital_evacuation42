function [e_x e_y]=gradientmap(wall, sink)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is used for formation of gradient map of desired   %
% direction. For the creation of potential filed appropriate tool- %
% box for FastMarchingAlgorithm (FMA) has been used.               %
%                                                                  %
% INPUT arguments:                                                 %
% wall - wall map obtained from getfile.m                          %
% sinn - exit coordinates obtained from getfile.m                  %
% OUTPUT arguments:                                                %
% e_x - desired x-direction (unnormalized!)                        %   
% e_y - desired y-direction (unnormalized!)                        %   
% Normalization is done in destination.f                           %
%                                                                  %
% Function perform_fast_marching().m can be founf in toolbox_fast_ %
% _marching folder.                                                %
%                                                                  %
% Note: For finding the gradients of potential field, MATLAB       %
% function gradient should not be used (see Report - FMA. For this %
% purpose a new function grad.f has been written.                  % 
%                                                                  %
% To obtain plots and visualize the destination force direction    %
% uncomment lines 33-45.                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

options.nb_iter_max=inf;

[D S]=perform_fast_marching(wall,sink,options);
%figure,imshow(D,[])

[e_x,e_y]=grad(D);

% [y_wall x_wall]=find(wall==0);
% 
%  figure
%  quiver(e_x,e_y,1),hold on
%  
%  for i=1:size(x_wall)
%      plot(x_wall(i),y_wall(i),'.k','LineWidth',1.5),hold on
%  end
%  
%  for i=1:size(sink,2)
%      plot(sink(2,i),sink(1,i),'.r','LineWidth',1.5),hold on
%      end
%  end





