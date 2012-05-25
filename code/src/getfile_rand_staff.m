

function [agent, I, wall, exits, beds] = getfile_rand_staff(n_staff,n_patients,n_beds,FileName)
% This function converts a bmp file to a matrix.
% Initialization of the agents as output

%clear all
%clc
av_staff_vel=1.25;
stdev_staff_vel=0.05;

av_patient_vel=1;
stdev_patient_vel=0.05;

exit=0;
while exit==0
    %[FileName,PathName]=uigetfile('*.bmp', 'Select a Bitmap File');
    I=imread(FileName);
    
    % if (find(I>6))
    % exit=0;
    % uiwait(msgbox('Wrong file'));
    % end
    
    space=find(I==4);
    [floor_x floor_y]=ind2sub(size(I),space);
    floor=[floor_x'; floor_y'];
    [exits]=find(I==3);
    [exit_x exit_y]=ind2sub(size(I),exits);
    exits=[exit_x';exit_y'];
    patient=find(I==0);
    %beds=find(I==6);
    %[bed_x bed_y]=ind2sub(size(I),beds);
    %beds = [bed_x';bed_y'];
    staff=find(I==1);
    wall=abs((I==5)-1);
    
    %imshow(I,[])
    %Create staff member and patients "matrix"
    n=1;
    m=1;
    %Is im(x,y) a staff member?
    for x=1:size(I,2)
        for y=1:size(I,1)
            if (I(y,x)==1)
                agent.staff(1,n)=x;
                agent.staff(2,n)=y;
                agent.staff(3,n)=0;
                agent.staff(4,n)=0;
                agent.staff(5,n)=normrnd(av_staff_vel,stdev_staff_vel); % desired velocity
                agent.staff(6,n)=1; % 1 = free (going to a patient); 2 = with a bed (going to the exit); at the beginning all the staff are going to their patient; 3 = at the exit; 4 = to a bed again
                n=n+1;
            end
            %Is im(x,y) a patient?
            if (I(y,x)==0)
                vect_patient(1,m)= x;
                vect_patient(2,m)=y;
                %             agent.patient(3,m)=0;
                %             agent.patient(4,m)=0;
                %             agent.patient(5,m)=normrnd(av_patient_vel,stdev_patient_vel);
                %             agent.patient(6,m)=0; % going to a exit (patient is free, it will always be the case, he is always going to the exit only)
                m=m+1;
            end
        end
    end
    
    patient_idx=randi(size(vect_patient,2),1,n_patients);
    agent.patient(1,:)= vect_patient(1,patient_idx);
    agent.patient(2,:)= vect_patient(2,patient_idx);
    agent.patient(3,:)=zeros(1,n_patients);
    agent.patient(4,:)=zeros(1,n_patients);
    agent.patient(5,:)=normrnd(av_patient_vel,stdev_patient_vel,1,n_patients);
    agent.patient(6,:)=zeros(1,n_patients);
    
    vect_patient(:,patient_idx)=[];
    
    bed_idx=randi(size(vect_patient,2),1,n_beds);
    bed_y = vect_patient(1,bed_idx);
    bed_x = vect_patient(2,bed_idx);
    beds = [bed_x;bed_y];
    
    if (n_patients==0)
        agent.patient(1,m)=0;
        agent.patient(2,m)=0;
        agent.patient(3,m)=0;
        agent.patient(4,m)=0;
        agent.patient(5,m)=0;
        agent.patient(6,m)=0; % going to a exit (patient is free, it will always be the case, he is always going to the exit only)
    end
      
    
    while(n_staff>size(agent.staff,2))
        P=randi(size(floor,2),1);
        agent.staff(1,n)=floor(2,P);
        agent.staff(2,n)=floor(1,P);
        agent.staff(3,n)=0;
        agent.staff(4,n)=0;
        agent.staff(5,n)=normrnd(av_staff_vel,stdev_staff_vel); % desired velocity
        agent.staff(6,n)=1;
        n=n+1;
        
    end
    
    
    exit=1;
end