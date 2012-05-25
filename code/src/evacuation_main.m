%% HOSPITAL EVACUATION MATLAB SIMULATION

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INSTRUCTIONS:
% NOT TO BE USED WITH batch_image.bmp WHICH IS ONLY TO BE USED WITH driver_core.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clc;

%% INITIALIZATION
% Read the image and store informations
%[agent, raw_map, wall_map, exit_coords, bed_coords_initial] = getfile_rand_staff(num_staff,num_patients,num_beds, image_name);
[agent, raw_map, wall_map, exit_coords, bed_coords_initial] = getfile();


% Number of staffs
nb_staff = size(agent.staff,2);
% Number of patients (WALKING PATIENTS)
nb_patient = size(agent.patient,2);
% Number of people (agents)
nb_agent = nb_staff + nb_patient;
% Number of beds
nb_bed = size(bed_coords_initial,2);
% Number of exits
nb_exit = size(exit_coords,2);
% Number of total patients (walking and bedded)
nb_patient_tot = nb_patient+nb_bed;

% Look for the coordinates of the walls (just needed for visualization)
[wall_coord(:,1) wall_coord(:,2)]=find(wall_map==0);

% Compute the gradient map for the exit
[exit_e_x exit_e_y]=gradientmap(wall_map,exit_coords);

% Reorder beds so that the first one is the farthest away from the exit
[bed_coords]=sort_bed(bed_coords_initial,exit_coords);

% Attribuate bed to each staff member (closest bed to each staff) and create coordinates of bed which
% are not taken yet by a staff member
[staff_ordered_to_bed,residual_staff,init_bed_coords,bed_free_coords]=attribuate_bed(agent,bed_coords);
bed_coords=[init_bed_coords,bed_free_coords];
control1=nb_bed-nb_staff;

if (control1>size(bed_free_coords,2))
    control2=control1-size(bed_free_coords,2)
    bed_free_coords(:,1:control2)=[];
end

control1=size(bed_free_coords,2)-nb_staff;
if (control1 > 0)
    for i=1:control1
        bed_e_x_attribuated(1:size(wall_map,1),1:size(wall_map,2),nb_staff+i)=0;
        bed_e_y_attribuated(1:size(wall_map,1),1:size(wall_map,2),nb_staff+i)=0;
        temp1(1:size(wall_map,1),1:size(wall_map,2),nb_staff+i)=0;
        temp2(1:size(wall_map,1),1:size(wall_map,2),nb_staff+i)=0;
    end
end

% Compute the gradient map for the different beds
bed_e_x = zeros(size(raw_map,1),size(raw_map,2),nb_bed);
bed_e_y = zeros(size(raw_map,1),size(raw_map,2),nb_bed);
for i=1:size(init_bed_coords,2)
    [bed_e_x_temp bed_e_y_temp]=gradientmap(wall_map,init_bed_coords(:,i));
    bed_e_x(:,:,i)=bed_e_x_temp;
    bed_e_y(:,:,i)=bed_e_y_temp;
end

% Create a matrix containing both staff (ordered) and patients
agents=horzcat(staff_ordered_to_bed,residual_staff,agent.patient);
%staff_filter=1:size(temp,2);

% Initialization for the plotting
firstplot=1;

% The boudnary force on every agent is added after because it is not
% dependent on many agent, it is just dependent on the location of the
% agent
[fx_bound fy_bound]=boundary(wall_map);
Fx=zeros(nb_agent,1);
Fy=zeros(nb_agent,1);
for i=size(staff_ordered_to_bed,2)+1:nb_staff
    if (agents(6,i)==5) % is going to the exit
        [Fx(i) Fy(i)]=force_on_alpha(agents,i,exit_e_x,exit_e_y);
    end
    Fx(i) = Fx(i) + fx_bound(agents(2,i),agents(1,i));
    Fy(i) = Fy(i) + fy_bound(agents(2,i),agents(1,i));
end

for i=1:size(staff_ordered_to_bed,2)
    if (agents(6,i)==1) % is going to his assigned bed (ONLY FOR THE BEGINNING, THEN IT IS CHANGED)
        [Fx(i) Fy(i)]=force_on_alpha(agents,i,bed_e_x(:,:,i),bed_e_y(:,:,i));
    end
    Fx(i) = Fx(i) + fx_bound(agents(2,i),agents(1,i));
    Fy(i) = Fy(i) + fy_bound(agents(2,i),agents(1,i));
end

for i=nb_staff+1:nb_agent
    if (agents(6,i)==0) % is going to the exit
        [Fx(i) Fy(i)]=force_on_alpha(agents,i,exit_e_x,exit_e_y);
    end
    Fx(i) = Fx(i) + fx_bound(agents(2,i),agents(1,i));
    Fy(i) = Fy(i) + fy_bound(agents(2,i),agents(1,i));
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

% State variable to see if the staff already rescued the first time when
% they reach the exit
not_first_time=zeros(1,nb_staff);


%% TIME STEPPING
% velocity time steped with simple Euler
% Once velocity calculated Displacement using S= V.dt (acceleration not
% included as for small times steps it has virtually no influence

mass=1;

counter_display=1; % Conter for the display

time_history = zeros(tf,1);

stop(1:nb_staff_curr)=0;
nb_total=nb_staff+nb_patient;

% Iterating over time
for time=1:tf
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Initialization
    
    nb_staff_curr(time) = size(staff_ordered_to_bed,2);
    nb_patient_curr(time) = size(agents,2)-nb_staff_curr(time);
    nb_agent_curr(time) = size(agents,2);
    nb_bed_curr(time) = size(bed_free_coords,2);
    nb_bed_patient_curr(time) = size(bed_free_coords,2)+nb_staff_curr(time);
    nb_patient_tot_curr(time) = nb_patient_curr(time)+nb_bed_patient_curr(time);
    
    time_history(time)=time;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Iterating over each agent to calculate their new position by knowing
    % the force acting on them at this time
    for i=1:size(agents,2)
        
        % Look for the old velocity of the agent
        if(time==1)
            oldUx=0;
            oldUy=0;
        else
            oldUx=agents(3,i);
            oldUy=agents(4,i);
        end
        
        % Update the velocity of each agent (old velocity plus
        % acceleration*Dt)
        if (isfinite(Fx(i)) && isfinite(Fy(i)))
            agents(3,i)=Fx(i)*Dt/mass+oldUx;
            agents(4,i)=Fy(i)*Dt/mass+oldUy;
        end
        
        % Calculate the norm of this new velocity
        vel_norm=sqrt(agents(3,i)^2+agents(4,i)^2);
        
        % Look that the agent are not going faster that what the are able
        % to
        if (vel_norm>agents(5,i))
            agents(3,i)=agents(3,i)/vel_norm*agents(5,i);    %scale velocities
            agents(4,i)=agents(4,i)/vel_norm*agents(5,i);
        end
        
        % Update finally their position
        new_x_position = agents(1,i)+(agents(3,i)*Dt);
        new_y_position = agents(2,i)+(agents(4,i)*Dt);
        
        if(wall_map(round(new_y_position),round(new_x_position))==1)
            agents(1,i)=new_x_position;
            agents(2,i)=new_y_position;
        else
            [agents(1,i) agents(2,i)] = in_wall(new_x_position,new_y_position,agents(3,i),agents(4,i),wall_map);
        end
        
        % Storing position in time matrix
        agents_info(1,i,time)=agents(1,i);
        agents_info(2,i,time)=agents(2,i);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Iterating over time to calculate the new forces acting on the agent
    % at their new position
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % FOR THE STAFF MEMBERS
    
    distance_staff_bed = zeros(nb_bed,nb_staff_curr(time));
    distance_staff_exit = zeros(nb_exit,nb_staff_curr(time));
    
    counter=0;
    %   bed_counter=0;
    
    % Loop over all the staff
    for i=1:nb_staff;
        
        % Look if the staff are close to a bed
        for k=1:nb_bed
            distance_staff_bed(k,i)=distance_alpha_beta(agents(1,i),agents(2,i),bed_coords(2,k),bed_coords(1,k));
            if (distance_staff_bed(k,i)<=sqrt(2))
                agents(6,i)=2; % change the state of the state from 'free' to 'with a bed'
                %                agents(5,i) = agents(5,i)*(2/3);
            end
        end
        
        distance_staff_exit(i)=distance_alpha_beta(agents(1,i),agents(2,i),exit_coords(2,5),exit_coords(1,5));
        % Distance between staff member and exit, exit position has
        % been presented with its midpoint, i.e. exit_coords(:,10)
        
        %Conditions over staff states
        
        if (distance_staff_exit(i)<3 && agents(6,i)==2 && size(bed_free_coords,2)==0 )
            % For a staff to change state from 2 to 3, three conditions must be satisfied
            % 1) staff is at the exit
            % 2) staff is with a bed
            % 3) there are no beds to be rescued
            agents(6,i)=3;
            bed_e_x_attribuated(1:size(wall_map,1),1:size(wall_map,2),i)=0;
            bed_e_y_attribuated(1:size(wall_map,1),1:size(wall_map,2),i)=0;
            stop(i)=0;
            % stop is a variable used for visualization purposes when staff
            % member reaches the bed
            nb_bed_patient_curr(time)=nb_bed_patient_curr(time)-1;
            nb_patient_tot_curr(time)=nb_patient_tot_curr(time)-1;
        end
        
        if (distance_staff_exit(i)<3 && agents(6,i)==2 && size(bed_free_coords,2)~=0 )
            % For a staff to change state from 2 to 4, three conditions must be satisfied
            % 1) staff is at the exit
            % 2) staff is with a bed
            % 3) there are still beds to be rescued
            agents(6,i)=4;
            [temp1(:,:,i) temp2(:,:,i)]=gradientmap(wall_map,bed_free_coords(:,1));
            %temp1 & temp2 - temporary values for position vectors
            bed_e_x_attribuated(1:size(wall_map,1),1:size(wall_map,2),i)=temp1(:,:,i);
            bed_e_y_attribuated(1:size(wall_map,1),1:size(wall_map,2),i)=temp2(:,:,i);
            %bed_counter=bed_counter+1;
            nb_bed_curr(time)=nb_bed_curr(time)-1; % one bed less in the building
            nb_bed_patient_curr(time)=nb_bed_patient_curr(time)-1;
            stop(i)=0;
            bed_free_coords(:,1)=[];
            % after the first free bed coordinates have been used for
            % computation of gradient map now they are being deleted
        end
        
        if (distance_staff_exit(i)<3 && agents(6,i)==5)
            % For a staff to change state from 5 to 3, three conditions must be satisfied
            % 1) staff is at the exit
            % 2) staff has no bed
            % 3) staff has been residual at the very beginnig of time steping
            agents(6,i)=3;
            bed_e_x_attribuated(1:size(wall_map,1),1:size(wall_map,2),i)=0;
            bed_e_y_attribuated(1:size(wall_map,1),1:size(wall_map,2),i)=0;
            bed_e_x(:,:,i)=0;
            bed_e_y(:,:,i)=0;
            stop(i)=0;
        end
        
        % Calculate the forces
        
        if (agents(6,i)==1) % staff is going to the attribued bed
            [Fx(i) Fy(i)]=force_on_alpha(agents,i,bed_e_x(:,:,i),bed_e_y(:,:,i));
            Fx(i) = Fx(i) + fx_bound(round(agents(2,i)),round(agents(1,i)));
            Fy(i) = Fy(i) + fy_bound(round(agents(2,i)),round(agents(1,i)));
        end
        
        if (agents(6,i)==2) % staff has a bed and is going to the exit
            [Fx(i) Fy(i)]=force_on_alpha(agents,i,exit_e_x(:,:),exit_e_y(:,:));
            Fx(i) = Fx(i) + fx_bound(round(agents(2,i)),round(agents(1,i)));
            Fy(i) = Fy(i) + fy_bound(round(agents(2,i)),round(agents(1,i)));
            stop(i)=stop(i)+1;
            if (stop(i)<90)
                Fx(i)=0;
                Fy(i)=0;
                agents(3,i) = 0;
                agents(4,i) = 0;
            end
        end
        
        if (agents(6,i)==4) % staff is going back to the attribuated bed
            [Fx(i) Fy(i)]=force_on_alpha(agents,i,bed_e_x_attribuated(:,:,i),bed_e_y_attribuated(:,:,i));
            Fx(i) = Fx(i) + fx_bound(round(agents(2,i)),round(agents(1,i)));
            Fy(i) = Fy(i) + fy_bound(round(agents(2,i)),round(agents(1,i)));
            %            agents(5,i) = agents(5,i)*(3/2);
        end
        
        if (agents(6,i)==5) % residual staff is going to the exit
            [Fx(i) Fy(i)]=force_on_alpha(agents,i,exit_e_x(:,:),exit_e_y(:,:));
            Fx(i) = Fx(i) + fx_bound(round(agents(2,i)),round(agents(1,i)));
            Fy(i) = Fy(i) + fy_bound(round(agents(2,i)),round(agents(1,i)));
        end
    end
    
    % Deleting staff members that have reached with the corresponding data
    % so that the adequate switch between indices is achieved
    
    for i=1:size(agents,2)
        if (agents(6,i)==3)
            counter=counter+1;
            index(counter)=i;
        end
    end
    
    deleted = 0;
    for i=1:counter
        agents(:,index(counter)-deleted)=[];
        bed_e_x(:,:,index(counter))=[];
        bed_e_y(:,:,index(counter))=[];
        bed_e_x_attribuated(:,:,index(counter))=[];
        bed_e_y_attribuated(:,:,index(counter))=[];
        stop(index(counter))=[];
        deleted = deleted + 1;
    end
    
    %Updating the number of staff
    nb_staff=nb_staff-counter;
    nb_staff_curr(time)=nb_staff_curr(time)-counter;
    nb_agent_curr(time)=nb_agent_curr(time)-counter;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % FOR THE PATIENTS
    
    
    distance_patient_exit = zeros(1,size(agents,2)-nb_staff);
    counter_patient_outside = 0;
    index_patient_outside = [];
    
    % Look if the patient are close to the exit
    for i= nb_staff+1:size(agents,2)
        distance_patient_exit(i)=distance_alpha_beta(agents(1,i),agents(2,i),exit_coords(2,5),exit_coords(1,5));
        if (distance_patient_exit(i)< 3)
            counter_patient_outside = counter_patient_outside+1;
            index_patient_outside(counter_patient_outside)=i; % saved patient
        end
    end
    
    distance_patient_exit=[];
    
    delete2 = 0;
    % Updating the patient situation
    if (counter_patient_outside~=0)
        for i=1:counter_patient_outside
            agents(:,index_patient_outside(i)-delete2)=[];
            agents_info(:,i,time)=0;
            nb_patient_curr(time)=nb_patient_curr(time)-1;
            nb_patient_tot_curr(time)=nb_patient_tot_curr(time)-1;
            nb_agent_curr(time)=nb_agent_curr(time)-1;
            delete2 = delete2 + 1;
        end
    end
    
    % Calculate the forces
    for i=nb_staff+1:size(agents,2)
        [Fx(i) Fy(i)]=force_on_alpha(agents,i,exit_e_x(:,:),exit_e_y(:,:));
        Fx(i) = Fx(i) + fx_bound(round(agents(2,i)),round(agents(1,i)));
        Fy(i) = Fy(i) + fy_bound(round(agents(2,i)),round(agents(1,i)));
    end
    
    nb_patient=nb_patient_curr(time);
    nb_total=nb_staff+nb_patient_curr(time);
    if(nb_agent_curr(time)==0)
        break;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    counter_display=counter_display+1;
    if (counter_display==5)
        
        if (firstplot==1)
            %   figure
            firstplot=0;
        end
        %      if(real_time_display==1)
        Display_agents_on_map(agents,nb_staff,wall_coord, bed_coords,firstplot);
        %     end
        counter_display=1;
    end
end


%% DELETE USELESS ENTRIES IN AGENT_INFO MATRIX

agents_info(:,:,time+1:tf)=[];

%% SOME STATISTICS

figure,
plot(time_history(1:time),nb_patient_tot_curr(1:time),'r');
set(gca, 'FontSize', 18);
xlabel('Time iteration');
ylabel('Number of patients inside the building');