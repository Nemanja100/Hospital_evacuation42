function [fsx,fsy] = force_social(rx_alpha,ry_alpha,rx_beta,ry_beta,ex_alpha,ey_alpha,A_social,B_social,lambda,l_alpha,l_beta)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Social force between agent alpha and beta
% INPUT:
%     rx_alpha: position x of agent alpha
%     ry_alpha: position y of agent alpha
%     rx_beta: position x of agent beta
%     ry_beta: position y of agent beta
%     ex_alpha: x component of direction of motion of agent alpha
%     ey_alpha: y component of direction of motion of agent alpha
%     A_social: interaction strength of social force
%     B_social: ragne of this repulsive force
%     lambda: parameter of the anisotropy of the interaction force
%     l_alpha: radii of agent alpha
%     l_beta: radii of agent beta
% OUTPUT:
%     fsx: social force in direction x
%     fsy: social force in direction y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

l_alpha_beta = l_alpha + l_beta; % Total size of agent alpha and beta (sum of their raiis)

d_alpha_beta = distance_alpha_beta(rx_alpha,ry_alpha,rx_beta,ry_beta); % Distance between alpha and beta

[nx_alpha_beta,ny_alpha_beta] = n_alpha_beta(rx_alpha,ry_alpha,rx_beta,ry_beta); % Unity directional vector from beta to alpha

phi = phi_alpha_beta(rx_alpha,ry_alpha,rx_beta,ry_beta,ex_alpha,ey_alpha); % Angle between direction of motion e and direction of force -n

fs = A_social.*(lambda+(1-lambda).*0.5.*(1+cosd(phi))).*exp((l_alpha_beta-d_alpha_beta)./B_social); % Magnitude of the social force
fsx = fs.*nx_alpha_beta; % x component of social force
fsy = fs.*ny_alpha_beta; % y component of social force

end