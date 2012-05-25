function [ftaiex,ftaiey] = force_tot_agent_interaction_elliptic(rx_alpha,ry_alpha,rx_beta,ry_beta,ex_alpha,ey_alpha,ex_beta,ey_beta,V0_alpha_beta,dt,vx_beta,vy_beta,sigma,phi_view,view_weight)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Total of agents interaction forces between agent alpha and beta by using
% the elliptic potential
% INPUT:
%     rx_alpha: position x of agent alpha
%     ry_alpha: position y of agent alpha
%     rx_beta: position x of agent beta
%     ry_beta: position y of agent beta
%     ex_beta: x component of direction of motion of agent beta
%     ey_beta: y component of direction of motion of agent beta
%     V0_alpha_beta: magnitude of the potential
%     dt: time step
%     vx_beta: velocity of agent beta in direction x
%     vy_beta: velocity of agent beta in direction y
%     sigma: range of interaction force
%     phi_view: half of the effective angle of sight
%     view_weight: weight of the force if beta out of view
% OUTPUT:
%     ftaiex: total agent interaction force in direction x
%     ftaiey: total agent interaction force in direction y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

v_beta = sqrt(vx_beta.^2+vy_beta.^2);

b = 0.5.*sqrt((distance_alpha_beta(rx_alpha,ry_alpha,rx_beta,ry_beta)+distance_alpha_beta(rx_alpha,ry_alpha,rx_beta+v_beta*dt.*ex_beta,ry_beta+v_beta*dt.*ey_beta)).^2-(v_beta.*dt).^2); % smiminor axis of the ellipse

V_alpha_beta = V0_alpha_beta.*exp(-b/sigma); % Interaction potential

[nx_alpha_beta,ny_alpha_beta] = n_alpha_beta(rx_alpha,ry_alpha,rx_beta,ry_beta); % Unity directional vector from beta to alpha

phi = phi_alpha_beta(rx_alpha,ry_alpha,rx_beta,ry_beta,ex_alpha,ey_alpha);

if (phi < phi_view) w = 1; % Is beta in the view field of alpha or not?
else w = view_weight;
end


ftaiex = w.*V_alpha_beta.*nx_alpha_beta;
ftaiey = w.*V_alpha_beta.*ny_alpha_beta;

end