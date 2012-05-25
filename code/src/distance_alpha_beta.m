function d_alpha_beta = distance_alpha_beta(rx_alpha,ry_alpha,rx_beta,ry_beta)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Distance between agent beta and alpha
% INPUT:
%     rx_alpha: position x of agent alpha
%     ry_alpha: position y of agent alpha
%     rx_beta: position x of agent beta
%     ry_beta: position y of agent beta
% OUTPUT:
%     d_alpha_beta: norm of the vector r_alpha_beta:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[rx_alpha_beta,ry_alpha_beta] = r_alpha_beta(rx_alpha,ry_alpha,rx_beta,ry_beta);

d_alpha_beta = sqrt(rx_alpha_beta.^2+ry_alpha_beta.^2);


end