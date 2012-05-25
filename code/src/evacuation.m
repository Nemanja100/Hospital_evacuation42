
function [agents_info bed_coords nb_patient_curr nb_bed_patient_curr nb_patient_tot_curr nb_staff_curr]=evacuation(num_agents,perc_staff, perc_beds, image_name, real_time_display)
%% HOSPITAL EVACUATION MATLAB SIMULATION

close all;
clc;

%% INITIALIZATION
num_staff=round(num_agents*(perc_staff/100));
num_beds =round((num_agents-num_staff)*(perc_beds/100));
num_patients=round(num_agents-num_staff-num_beds);

% Read the image and store informations
[agent, raw_map, wall_map, exit_coords, bed_coords] = getfile_rand_staff(num_staff,num_patients,num_beds, image_name);

% Create a matrix containing both staff and patients
agents=horzcat(agent.staff,agent.patient);

% Number of staffs
nb_staff = size(agent.staff,2);
% Number of patients (WALKING PATIENTS)
nb_patient = size(agent.patient,2);
% Number of people (agents)
nb_agent = nb_staff + nb_patient;
% Number of beds
nb_bed = size(bed_coords,2);
% Number of exits
nb_exit = size(exit_coords,2);
% Number of total patients (walking and bedded)
nb_patient_tot = nb_patient+nb_bed;

% Look for the coordinates of the walls (just needed for visualization)
[wall_coord(:,1) wall_coord(:,2)]=find(wall_map==0);

% Compute the gradient map for the exit
[exit_e_x exit_e_y]=gradientmap(wall_map,exit_coords);

% Connectity array between staff and bed
connex_s2b=staff2bed(agent.staff,bed_coords);

% Index of bed which is still free
bed_free_idx = find_free_bed(connex_s2b, nb_bed);

% Array containing initial index of agents
agent_idx = 1:nb_agent;

% Initialization of states
for i = 1:nb_agent
    flag_in_array=0;
    for j=1:size(connex_s2b,2)
        if(connex_s2b(1,j)==i)
            flag_in_array=1;
            
        else
            if(i<=nb_staff)
                agents(6,i)=5;
            else
                agents(6,i)=0;
            end
        end
        if(flag_in_array==1)
            agents(6,i)=1;
        end
    end
end

% Compute the gradient map for the different beds
bed_e_x = zeros(size(raw_map,1),size(raw_map,2),nb_bed);
bed_e_y = zeros(size(raw_map,1),size(raw_map,2),nb_bed);
for i=1:nb_bed
    [bed_e_x_temp bed_e_y_temp]=gradientmap(wall_map,bed_coords(:,i));
    bed_e_x(:,:,i)=bed_e_x_temp;
    bed_e_y(:,:,i)=bed_e_y_temp;
end

% Initialization for the plotting
firstplot=1;

% The boudnary force on every agent is added after because it is not
% dependent on many agent, it is just dependent on the location of the
% agent
[fx_bound fy_bound]=boundary(wall_map);
Fx=zeros(nb_agent,1);
Fy=zeros(nb_agent,1);

% Compute the direction field for the agents
e_x = zeros(size(raw_map,1),size(raw_map,2));
e_y = zeros(size(raw_map,1),size(raw_map,2));

for i=1:size(agent_idx,2);
    for j=1:size(connex_s2b,2)
        if((agent_idx(i)==connex_s2b(1,j))&&((agents(6,agent_idx(i))==1)||(agents(6,agent_idx(i))==4)))
            e_x=bed_e_x(:,:,connex_s2b(2,j));
            e_y=bed_e_y(:,:,connex_s2b(2,j));
            
        end
    end
    if((agents(6,agent_idx(i))==0)||(agents(6,agent_idx(i))==2)||((agents(6,agent_idx(i))==5)))
        e_x = exit_e_x;
        e_y = exit_e_y;
    end
    
    % Initialize the forces
    [Fx(agent_idx(i)) Fy(agent_idx(i))]=force_on_alpha(agents(:,agent_idx),i,e_x,e_y);
    
    Fx(agent_idx(i)) = Fx(agent_idx(i)) + fx_bound(agents(2,agent_idx(i)),agents(1,agent_idx(i)));
    Fy(agent_idx(i)) = Fy(agent_idx(i)) + fy_bound(agents(2,agent_idx(i)),agents(1,agent_idx(i)));
    
end


% Time iterations
tf = 20000;
% Time step
Dt=0.1;

% Storage of time position of all the agents and attribuated bed for each staff (x coord, y coord, x bed coord, y bed coord; ID; time)
agents_info=zeros(4,nb_agent,tf);
agents_info(1,:,1)=agents(1,:); % x coord
agents_info(2,:,1)=agents(2,:); % y coord

% Vector containing the number of staff in the building in time
nb_staff_curr = zeros(tf,1);
nb_staff_curr(1) = nb_staff;

% Vector containing the number of walking patient in the building in time
nb_patient_curr = zeros(tf,1);
nb_patient_curr(1) = nb_patient;

% Vector containing the number of bed patient in the building in time
nb_bed_patient_curr = zeros(tf,1);
nb_bed_patient_curr(1) = nb_bed;

% Vector containing the number of people in the building in time
nb_agent_curr = zeros(tf,1);
nb_agent_curr(1) = nb_agent;

% Vector containing the number of bed in the building in time
nb_bed_curr = zeros(tf,1);
nb_bed_curr(1) = nb_bed;

% Vector containing the number of staff in the building in time
nb_patient_tot_curr = zeros(tf,1);
nb_patient_tot_curr(1) = nb_patient_tot;


%% TIME STEPPING
% velocity time steped with simple Euler
% Once velocity calculated Displacement using S= V.dt (acceleration not
% included as for small times steps it has virtually no influence

mass=1; % ATTENTION: THIS SHOULD BE MAYBE A PROPERTY OF EVERY AGENT? OR JUST USE 1 AND CHANGE CHE DESIRED VELOCITY OF EVERY AGENT TYPE?

counter_display=1; % Counter for the display

time_history = zeros(tf,1);

stop(1:nb_staff_curr)=0;
% Iterating over time


for time=1:tf
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Initialization
    nb_staff_curr(time+1)=nb_staff_curr(time);
    
    nb_patient_curr(time) = size(agent_idx,2)-nb_staff_curr(time);
    nb_agent_curr(time) = size(agent_idx,2);
    nb_bed_curr(time) = size(bed_free_idx,2);
    nb_bed_patient_curr(time) = size(bed_free_idx,2)+nb_staff_curr(time);
    nb_patient_tot_curr(time) = nb_patient_curr(time)+nb_bed_patient_curr(time); % ATTENTION: THE NUMBER OF TOTAL PATIENT, AS THE NUMBER OF BED PATIENT IS NOT CORRECT YET!
    
    time_history(time)=time;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Iterating over each agent to calculate their new position by knowing
    % the force acting on them at this time
    for i=1:size(agent_idx,2)
        
        % Look for the old velocity of the agent
        if(time==1)
            oldUx=0;
            oldUy=0;
        else
            oldUx=agents(3,agent_idx(i));
            oldUy=agents(4,agent_idx(i));
        end
        
        % Update the velocity of each agent (old velocity plus
        % acceleration*Dt)
        %if (isfinite(Fx(i)) && isfinite(Fy(i)))
        agents(3,agent_idx(i))=Fx(agent_idx(i))*Dt/mass+oldUx;
        agents(4,agent_idx(i))=Fy(agent_idx(i))*Dt/mass+oldUy;
        %end
        
        % Calculate the norm of this new velocity
        vel_norm=sqrt(agents(3,agent_idx(i))^2+agents(4,agent_idx(i))^2);
        
        % Look that the agent are not going faster that what the are able
        % to
        if (vel_norm>agents(5,agent_idx(i)))
            agents(3,agent_idx(i))=agents(3,agent_idx(i))/vel_norm*agents(5,agent_idx(i));    %scale velocities
            agents(4,agent_idx(i))=agents(4,agent_idx(i))/vel_norm*agents(5,agent_idx(i));
        end
        
        % Update finally their position
        new_x_position = agents(1,agent_idx(i))+(agents(3,agent_idx(i))*Dt);
        new_y_position = agents(2,agent_idx(i))+(agents(4,agent_idx(i))*Dt);
        
        
        if(wall_map(round(new_y_position),round(new_x_position))==1)
            agents(1,agent_idx(i))=new_x_position;
            agents(2,agent_idx(i))=new_y_position;
        else
            [agents(1,agent_idx(i)) agents(2,agent_idx(i))] = in_wall(new_x_position,new_y_position,agents(3,agent_idx(i)),agents(4,agent_idx(i)),wall_map);
        end
        
        % Storing position in time matrix
        agents_info(1,agent_idx(i),time)=agents(1,agent_idx(i));
        agents_info(2,agent_idx(i),time)=agents(2,agent_idx(i));
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Iterating over time to calculate the new forces acting on the agent
    % at their new position
    
    distance_staff_exit = zeros(nb_exit,nb_staff_curr(time));
    
    counter_staff_useless = 0;
    index_staff_useless = [];
    counter_patient_outside = 0;
    index_patient_outside = [];
    
    % Loop over all the agents
    for i=1:size(agent_idx,2)
        
        if((agents(6,agent_idx(i))==1)||(agents(6,agent_idx(i))==4))
            % Look if the staff are close to a bed
            for s_conx=1:size(connex_s2b,2)
                if(agent_idx(i)==connex_s2b(1,s_conx))
                    array_idx=s_conx;
                end
            end
            distance_staff_bed= distance_alpha_beta(agents(1,agent_idx(i)),agents(2,agent_idx(i)),bed_coords(2,connex_s2b(2,array_idx)),bed_coords(1,connex_s2b(2,array_idx)));
            if (distance_staff_bed<=sqrt(2))
                agents(6,agent_idx(i))=2; % change the state of the state from 'free' to 'with a bed'
                for s_conx=1:size(connex_s2b,2)
                    if(agent_idx(i)==connex_s2b(1,s_conx))
                        array_idx=s_conx;
                    end
                end
                connex_s2b(1,array_idx)=0;
                agents(5,agent_idx(i))=(2/3)*agents(5,agent_idx(i));
            end
        end
        
        % Look if the staff are close to the exit
        for l=1:nb_exit
            distance_staff_exit(l,agent_idx(i))=distance_alpha_beta(agents(1,agent_idx(i)),agents(2,agent_idx(i)),exit_coords(2,l),exit_coords(1,l));
            if (distance_staff_exit(l,agent_idx(i))<=3.5 && ((agents(6,agent_idx(i))==2) || (agents(6,agent_idx(i))==5)))
                agents(6,agent_idx(i))=3; % change the state of the state to 'at the exit'
            elseif((agents(6,agent_idx(i))==0)&&distance_staff_exit(l,agent_idx(i))<=3.5)
                counter_patient_outside = counter_patient_outside+1;
                index_patient_outside(counter_patient_outside)=i; % saved patient
                nb_patient_curr(time+1)=nb_patient_curr(time)-1;
                nb_patient_tot_curr(time+1)=nb_patient_tot_curr(time)-1;
                nb_agent_curr(time+1)=nb_agent_curr(time)-1;
                
            end
        end
        
        
        for i=1:size(agent_idx,2);
            for j=1:size(connex_s2b,2)
                if((agent_idx(i)==connex_s2b(1,j))&&((agents(6,agent_idx(i))==1)||(agents(6,agent_idx(i))==4)))
                    e_x=bed_e_x(:,:,connex_s2b(2,j));
                    e_y=bed_e_y(:,:,connex_s2b(2,j));
                    
                end
            end
            if((agents(6,agent_idx(i))==0)||(agents(6,agent_idx(i))==2)||((agents(6,agent_idx(i))==5)))
                e_x = exit_e_x;
                e_y = exit_e_y;
            end
            
            [Fx(agent_idx(i)) Fy(agent_idx(i))]=force_on_alpha(agents(:,agent_idx),i,e_x,e_y);
            if ((agents(6,agent_idx(i))==2)&&(stop(agent_idx(i))<300))
                
                Fx(agent_idx(i))=0;
                Fy(agent_idx(i))=0;
                agents(3,agent_idx(i)) = 0;
                agents(4,agent_idx(i)) = 0;
                stop(agent_idx(i))=stop(agent_idx(i))+1;
            elseif(agents(6,agent_idx(i))==3)
                bed_free_idx = find_free_bed(connex_s2b, nb_bed);
                if(size(bed_free_idx,2)==0)
                    counter_staff_useless=counter_staff_useless+1;
                    index_staff_useless(counter_staff_useless)=i;
                    nb_bed_patient_curr(time+1)=nb_bed_patient_curr(time)-1;
                    nb_patient_tot_curr(time+1)=nb_patient_tot_curr(time)-1;
                    nb_staff_curr(time+1)=nb_staff_curr(time)-1;
                    nb_agent_curr(time+1)=nb_agent_curr(time)-1;
                elseif(size(bed_free_idx,2)>0)
                    link_s2b= staff2bed([agents(1,agent_idx(i)) agents(2,agent_idx(i))]',bed_coords(:,bed_free_idx));
                    link_s2b(1)=agent_idx(i);
                    link_s2b(2)=bed_free_idx(link_s2b(2));
                    connex_s2b=horzcat(link_s2b,connex_s2b);
                    if(size(bed_free_idx,2)>1)
                        bed_free_idx = find_free_bed(connex_s2b, nb_bed);
                    else
                        bed_free_idx=[];
                    end
                    agents(6,agent_idx(i))=4;
                    bed_free_idx = find_free_bed(connex_s2b, nb_bed);
                    nb_bed_patient_curr(time+1)=nb_bed_patient_curr(time)-1;
                    nb_patient_tot_curr(time+1)=nb_patient_tot_curr(time)-1;
                    stop(agent_idx(i))=0;
                    agents(5,agent_idx(i))=(3/2)*agents(5,agent_idx(i));
                    
                end
            else
                Fx(agent_idx(i)) = Fx(agent_idx(i)) + fx_bound(ceil(agents(2,agent_idx(i))),ceil(agents(1,agent_idx(i))));
                Fy(agent_idx(i)) = Fy(agent_idx(i)) + fy_bound(ceil(agents(2,agent_idx(i))),ceil(agents(1,agent_idx(i))));
                
            end
        end
        
    end
    
    % Updating of agents situation
    
    
    delete_idx=horzcat(index_staff_useless,index_patient_outside);
    
    agent_idx(delete_idx)=[];
    delete_idx=[];
    
    if(size(agent_idx,2)==0)
        break;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    counter_display=counter_display+1;
    if (counter_display==50)
        
        if (firstplot==1)
            %   figure
            firstplot=0;
        end
        if(real_time_display==1)
            Display_agents_on_map(agents(:,agent_idx),nb_staff_curr(time),wall_coord, bed_coords,firstplot);
        end
        counter_display=1;
    end
end

%% DELETE USELESS ENTRIES IN AGENT_INFO MATRIX

agents_info(:,:,time+2:tf)=[];
nb_bed_patient_curr(time+1:tf)=[];
nb_patient_curr(time+1:tf)=[];
nb_patient_tot_curr(time+1:tf)=[];
nb_staff_curr(time+1:tf)=[];
%% SOME STATISTICS

%figure,
%plot(1:time+1,nb_patient_curr(1:time+1),'r--',1:time+1,nb_bed_patient_curr(1:time+1),'r-.',1:time+1,nb_patient_tot_curr(1:time+1),'r-',1:time+1,nb_staff_curr(1:time+1),'b-');
%xlabel('Time iteration');
%ylabel('Unity of agent type inside the building');
%legend('Walking patient','Bed patient','Patient (bed+walking)','Staff');

test=1;