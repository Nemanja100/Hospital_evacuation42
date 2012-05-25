function [] = scene_2d(result, wall_coord, time)
% Function for creating avi files from simulation history files.
%hisory is an array containing the time history of agent possitions and
%speeds.
%wall_coord is a vector of wall coordinates
%bed is a vector of bed coordinates
%t_total is the length of the video
num_staff=result.nb_staff(time);
history=result.history;
bed=result.bed_coord;
frame=time;
num_bed_pat=result.nb_bed_patient;
extreme=max(wall_coord);
loc_free_staff= extreme(1)+5;
loc_free_patients = extreme(1)+10;
loc_free_beds = extreme(1)+15;
total_beds=max(num_bed_pat);
fig=figure;
set(fig, 'Position', [0 0 640 480] ); %fix figure size
axis equal %make scale uniform in image

staff=[];
patient=[];
staff_out=[];
pat_out=[];
counter=1;
out_counter=1;
for i=1:num_staff
    if((history(1,i,frame)==0)&&(history(2,i,frame)==0))
        staff_out(2,out_counter)=loc_free_staff;
        staff_out(1,out_counter)=40+2*out_counter;
        out_counter=out_counter+1;
    else
        staff(1,counter)=history(1,i,frame);
        staff(2,counter)=history(2,i,frame);
        counter=counter+1;
    end
end
if(size(staff_out,2)>0)
    staff = horzcat(staff,staff_out);
end
counter=1;
out_counter=1;
for i=num_staff+1:size(history,2)
    if((history(1,i,frame)==0)&&(history(2,i,frame)==0))
        pat_out(2,out_counter)=loc_free_patients;
        pat_out(1,out_counter)=40+2*out_counter;
        out_counter=out_counter+1;
    else
        patient(1,counter)=history(1,i,frame);
        patient(2,counter)=history(2,i,frame);
        counter=counter+1;
    end
end
if(size(pat_out,2)>0)
    patient=horzcat(patient,pat_out);
end
hold on

if(num_bed_pat(frame)<total_beds)
    
    for i=1:(total_beds-num_bed_pat(frame))
        h=scatter(40+2*i,loc_free_beds,9,[0 1 0],'filled');
    end
end


h = scatter(wall_coord(:,2),wall_coord(:,1),1,[0 0 0], 'filled');
% h =plot(wall_coord(:,2),wall_coord(:,1),'.k');
h = scatter(bed(2,:),bed(1,:),9,[0 1 0], 'filled');
%h=plot(bed(2,:),bed(1,:),'.y');
if(size(staff,2)>0)
    h= scatter(staff(1,:), staff(2,:),10,[0 0 1],'filled');
    %h= plot(agent(1,1:num_staff), agent(2,1:num_staff),'.b');
end
if(size(patient,2)>0)
    h= scatter(patient(1,:), patient(2,:),10,[1 0 0],'filled');
    %h= plot(patient(1,:), patient(2,:),'.r');
end




%scatter(wall_coord(:,2),wall_coord(:,1),5,[0 0 0], 'filled');
%scatter(agent(1,:), agent(2,:),5,[1 0.5 0],'filled');
%scatter(bed(2,:),bed(1,:),5,[0.25 1 0.5], 'filled');

%refreshdata
% drawnow
