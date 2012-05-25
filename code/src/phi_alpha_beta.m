function phi_alpha_beta = phi_alpha_beta(rx_alpha,ry_alpha,rx_beta,ry_beta,ex_alpha,ey_alpha)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Angle between direction of motion e and direction of force -n
% INPUT:
%     rx_alpha: position x of agent alpha
%     ry_alpha: position y of agent alpha
%     rx_beta: position x of agent beta
%     ry_beta: position y of agent beta
%     ex_alpha: x component of direction of motion of agent alpha
%     ey_alpha: y component of direction of motion of agent alpha
% OUTPUT:
%     phi_alpha_beta: norm of the vector r_alpha_beta: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[nx_alpha_beta,ny_alpha_beta] = n_alpha_beta(rx_alpha,ry_alpha,rx_beta,ry_beta);% Unity directional vector from beta to alpha

%phi_alpha_beta = acosd(dot(-[nx_alpha_beta,ny_alpha_beta],[ex_alpha,ey_alpha]));
phi_alpha_beta = acosd(-(nx_alpha_beta.*ex_alpha+ny_alpha_beta.*ey_alpha));

end