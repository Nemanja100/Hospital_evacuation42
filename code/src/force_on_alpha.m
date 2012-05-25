function [fx_tot_alpha,fy_tot_alpha] = force_on_alpha(agent,alpha,e_x,e_y)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% total force on agent alpha
% input:
%   agent: matrix of all the agent
%   alpha: agent on which we want to calculate the forces
%   e_x: x component of direction of the gradient
%   e_y: y component of direction of the gradient
% output:
%     fx_tot: total force in direction x
%     fy_tot: total force in direction y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% constants

% to be tuned:
if (agent(6,alpha)==0) % this patient is free to move
    influence_area = 3; % [m] area of influence for the interaction force between the agents
    a_physical = 3;
    b_physical = .3;
    a_social = 6;
    b_social = .6;
    lambda = 0.3;
    l_alpha = 0.4*1.5;
    l_beta = 0.3*1.5;
    v0_alpha_beta = 1;
    dt = 0.1;
    sigma = 0.3;
    phi_view = 30;
    view_weight = 0.5;
elseif (agent(6,alpha)==1||agent(6,alpha)==3||agent(6,alpha)==4||agent(6,alpha)==5)
    % this staff member is going to a bed or to a exit without bed (still free to move without bed)
    influence_area = 3; % [m] area of influence for the interaction force between the agents
    a_physical = 2;
    b_physical = 0.2;
    a_social = 5;
    b_social = 0.3;
    lambda = 0.3;
    l_alpha = 0.3*1.5;
    l_beta = 0.3*1.5;
    v0_alpha_beta = 2.1;
    dt = 0.1;
    sigma = 0.3;
    phi_view = 30;
    view_weight = 0.5;
elseif (agent(6,alpha)==2) % this staff memeber is going to the exit with a bed
    influence_area = 6; % [m] area of influence for the interaction force between the agents
    a_physical = 5;
    b_physical = 0.5;
    a_social = 5;
    b_social = 0.7;
    lambda = 0.3;
    l_alpha = 1*1.5;
    l_beta = 0.3*1.5;
    v0_alpha_beta = 2.1;
    dt = 0.1;
    sigma = 0.3;
    phi_view = 30;
    view_weight = 0.5;
end
%% initialization

% agenent alpha infos (rx,ry,vx,vy,v0)
agent_alpha = agent(:,alpha);

% distance between alpha and all the other agents (vector 1xnagent)
dist_alpha_beta = distance_alpha_beta(agent_alpha(1),agent_alpha(2),agent(1,:),agent(2,:));

% influent agents bool(into the influence region)
agent_influent_bool = dist_alpha_beta < influence_area;

% agent alpha does't influence himself
agent_influent_bool(alpha) = 0;
agent_influent_bool(dist_alpha_beta==0) = 0;

% influent agents infos
agent_influent = agent(:,agent_influent_bool);

% desired direction following gradient
ex_alpha=e_x(round(agent_alpha(2)),round(agent_alpha(1)));
ey_alpha=e_y(round(agent_alpha(2)),round(agent_alpha(1)));
%ex_agent_influent=e_x(agent_influent(1,:),agent_influent(2,:)); % only needed for
%elliptic potential
%ey_agent_influent=e_y(agent_influent(1,:),agent_influent(2,:));

%% destination force
[fx_dest,fy_dest]=destination(ex_alpha,ey_alpha,agent_alpha(3),agent_alpha(4));

%% boundary force
% not added here but in the main directly (is a static force component)

%% agent interaction forces
[ftaix,ftaiy] = force_tot_agent_interaction(agent_alpha(1),agent_alpha(2),...
    agent_influent(1,:),agent_influent(2,:),ex_alpha,ey_alpha,a_physical,...
    b_physical,a_social,b_social,lambda,l_alpha,l_beta);
%[ftaiex,ftaiey] = force_tot_agent_interaction_elliptic(agent_alpha(1),...
%agent_alpha(2),agent_influent(1,:),agent_influent(2,:),ex_alpha,ey_alpha,...
%ex_agent_influent,ey_agent_influent,v0_alpha_beta,dt,agent_influent(3,:),agent_influent(4,:),sigma,phi_view,view_weight);

ftaix_on_alpha = sum(ftaix);
ftaiy_on_alpha = sum(ftaiy);

%ftaiex_on_alpha = sum(ftaiex);
%ftaiey_on_alpha = sum(ftaiey);

%% total forces on agent alpha (without boundary forces)
fx_tot_alpha = fx_dest + ftaix_on_alpha;
fy_tot_alpha = fy_dest + ftaiy_on_alpha;

%fex_tot_alpha = fx_dest + ftaiex_on_alpha;
%fey_tot_alpha = fy_dest + ftaiey_on_alpha;

end