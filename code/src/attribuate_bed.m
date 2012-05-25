function [agent_staff,residual_staff,init_bed_coords,rest_bed_coords,final_position,d_staff_bed,d_staff_bed_backup1]=attribuate_bed(agent,bed_coords)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

agent_staff=agent.staff;
nb_staff=size(agent_staff,2);
nb_beds=size(bed_coords,2);
d_staff_bed=zeros(nb_staff,nb_beds);

for m=1:nb_staff
    for l=1:nb_beds 
        d_staff_bed(m,l)=sqrt((agent_staff(1,m)-bed_coords(2,l))^2 + (agent_staff(2,m)-bed_coords(1,l))^2);
    end
end

final_position=zeros(1,nb_staff);
d_staff_bed_backup=d_staff_bed;
d_staff_bed_backup1=d_staff_bed;

% %more primitive
% for m=1:nb_staff
%     [temp_min,temp_min_position]=min(d_staff_bed(m,:));
%     final_position(m)=temp_min_position;
%     d_staff_bed(:,temp_min_position)=inf;
% end

%more advanced
% for m=1:nb_staff
%     counter=0;
%     while (counter==0)
%     [temp_min,temp_min_position]=min(d_staff_bed(m,:));
%     validation=temp_min>d_staff_bed(:,temp_min_position);
%     validation=double(validation);
%        if (sum(validation)>0)
%           d_staff_bed(m,temp_min_position)=inf;
%        else
%           final_position(m)=temp_min_position;
%           counter=counter+1;
%        end
%        saturation=d_staff_bed(m,:)==inf;
%        if (sum(saturation)==nb_beds)
%            counter=counter+1;
%            final_position(m)=0;
%     end
%     end
% end
% 
% for m=1:nb_staff
%     if (d_staff_bed(m,1)~=inf)
%         d_staff_bed_backup(m,:)=inf;
%         d_staff_bed_backup(:,final_position(m))=inf;
%     end
% end

 counter=0;
 while (counter==0)
     kernel=min(min(d_staff_bed_backup));
     [staff bed]=find(d_staff_bed_backup==kernel);
     final_position(staff)=bed;
     d_staff_bed_backup(staff,:)=inf;
     d_staff_bed_backup(:,bed)=inf;
     if (min(d_staff_bed_backup)==inf)
         counter=counter+1;
     end
 end

residual=find(final_position==0);
rest_bed_coords=[];
residual_staff=[];
temp1=find(final_position==0);
if (temp1>0)
    agent_staff(:,temp1)=[];
    final_position(temp1)=[];
    
end

nb_staff=size(agent_staff,2);
for m=1:nb_staff
    init_bed_coords(:,m)=bed_coords(:,final_position(m));
end

if (residual>0)
residual_staff=agent.staff(:,residual);
residual_staff(6,:)=5;
end

bed_coords(:,final_position')=[];
rest_bed_coords=bed_coords;
    
