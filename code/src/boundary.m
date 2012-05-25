function [fx_bound fy_bound]=boundary(A)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function for computation of boundary forces.           %
%                                                        %
% INPUT arguments:                                       %
% A - input matrix (wall matrix obtained from getfile.m) %            
% OUTPUT arguments:                                      %
% fx_bound - boundary force in x-direction               %
% fy_bound - boundary force in y-direction               %
%                                                        %
% To obtain plots and visualize the boundary forces      %
% uncomment lines 51-56.                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Parameters of boundary potential%
u0_alphaB=100;                   %
R=0.4;                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Determination of boundary potential%%
[a b]=size(A);                       %
r=zeros(a,b);                        %
[y x]=find(A==0);                    %
for m=1:a                            %
    for n=1:b                        %
        if (A(m,n)~=0)               %
            rx=n-x;                  %
            ry=m-y;                  %
            rr=sqrt(rx.^2+ry.^2);    %
            r(m,n)=min(rr);          %
        end                          %
        if (A(m,n)==0)               %
            r(m,n)=0;                %
        end                          %
    end                              %
end                                  %
                                     %
r(r==0)=-inf; % Explanation:         % 
% value of r=0 is obtained for wall  % 
% point. By making value of r at the %
% wall r=-inf we'll get that bounda- %
% ry potential is equal to inf at    %
% this point and now gradient of bo- %
% undaru potential can be found      %
% using grad.m                       %
bound_pot=u0_alphaB.*exp(-r./R);     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[fx_bound fy_bound]=grad(bound_pot);

% figure
% quiver(fx_bound,fy_bound,2),hold on;
% [y_wall x_wall]=find(A==0);
%  for i=1:size(x_wall)
%      plot(x_wall(i),y_wall(i),'.k','LineWidth',1.5),hold on
%  end



