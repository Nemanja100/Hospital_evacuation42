agents=[20 30 40 50 60 70 80 90 100];% total nunmber of agents in simulation
staff2pat =[20 25 30 35 40 45 50]; %percentage of staff from all agents
bed2pat = [10 20 30 40 50 60 70 80 90]; %percentage of all pateints who are bedbound
count=36;
real_time_display=1; % to visualize the simulation
%parellisation

matlabpool

for c=1:size(bed2pat,2)
   for b=1:size(staff2pat,2)
      parfor a=1:size(agents,2)
          
      [results(a,b,c).history results(a,b,c).bed_coord results(a,b,c).nb_patient...
          results(a,b,c).nb_bed_patient results(a,b,c).nb_patient_tot results(a,b,c).nb_staff]=...
          evacuation(agents(a),staff2pat(b),bed2pat(c),'batch_image.bmp',real_time_display);
       results(a,b,c).num_agents=agents(a);
       results(a,b,c).perc_staff=staff2pat(b);
       results(a,b,c).perc_bed=bed2pat(c);
          
      end
   end
end

matlabpool close