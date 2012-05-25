function [ftaix,ftaiy] = force_tot_agent_interaction(rx_alpha,ry_alpha,rx_beta,ry_beta,ex_alpha,ey_alpha,A_physical,B_physical,A_social,B_social,lambda,l_alpha,l_beta)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Total of agents interaction forces between agent alpha and beta
% INPUT:
%     rx_alpha: position x of agent alpha
%     ry_alpha: position y of agent alpha
%     rx_beta: position x of agent beta
%     ry_beta: position y of agent beta
%     ex_alpha: x component of direction of motion of agent alpha
%     ey_alpha: y component of direction of motion of agent alpha
%     A_physical: interaction strength of physical force
%     B_physical: ragne of this repulsive force
%     A_social: interaction strength of social force
%     B_social: ragne of this repulsive force
%     lambda: parameter of the anisotropy of the interaction force
%     l_alpha: radii of agent alpha
%     l_beta: radii of agent beta
% OUTPUT:
%     ftaix: total agent interaction force in direction x
%     ftaiy: total agent interaction force in direction y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[fpx,fpy] = force_physical(rx_alpha,ry_alpha,rx_beta,ry_beta,A_physical,B_physical,l_alpha,l_beta); % Physical agent interaction force between agent alpha and beta
[fsx,fsy] = force_social(rx_alpha,ry_alpha,rx_beta,ry_beta,ex_alpha,ey_alpha,A_social,B_social,lambda,l_alpha,l_beta); % Social agent interaction force between agent alpha and beta

ftaix = fpx + fsx;
ftaiy = fpy + fsy;
end