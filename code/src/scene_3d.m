function [] = scene_3d( result, wall_coord, time)
% Function which recieves a structure with agent groups, a image with the
% walls and the sinks, and displays them in an image.
num_staff=result.nb_staff(time);
history=result.history;
bed=result.bed_coord;
frame=time;

for i=1:num_staff
    staff(1,i)=history(1,i,frame);
    staff(2,i)=history(2,i,frame);
end
for i=num_staff+1:size(history,2)
    patient(1,i)=history(1,i,frame);
    patient(2,i)=history(2,i,frame);
end
screen_size = get(0, 'ScreenSize');

fig=figure
set(fig, 'Position', screen_size );

axis([0 max(wall_coord(:,2)) 0 max(wall_coord(:,1)) 0 120 0 1])
sizew=[1 1 0.5];
sizea=[1 1 2.5];
sizel=[0.75 0.75 2.5];
sizeb=[2 3 2];
sizep=[2 0.5 0.25];
sizeh=[0.5 0.5 0.75];

%plot walls
for i=1:size(wall_coord,1)
    plotcube( sizew, [wall_coord(i,2) wall_coord(i,1) 0], 1,[0 0 0]);
end
%plot staff
for i=1:size(staff,2)
    if((staff(1,i)~=0)&&(staff(2,i)~=0))
        plotcube( sizea, [staff(1,i) staff(2,i) sizel(3)], 1,[1 1 1]);%torso
        plotcube( sizel, [staff(1,i)+0.125 staff(2,i)+0.125 0], 1,[0 1 0]);%legs
        plotcube( sizeh, [staff(1,i)+0.25 staff(2,i)+0.25 sizea(3)+sizel(3)], 1,[1 0.5 1]);%head
    end
end
%plot patients
for i=1:size(patient,2)
    if((patient(1,i)~=0)&&(patient(2,i)~=0))
        plotcube( sizea, [patient(1,i) patient(2,i) sizel(3)], 1,[0.5 1 0]);
        plotcube( sizel, [patient(1,i)+0.125 patient(2,i)+0.125 0], 1,[0 1 0]);
        plotcube( sizeh, [patient(1,i)+0.25 patient(2,i)+0.25 sizea(3)+sizel(3)], 1,[1 0.5 1]);
    end
end
%plot beds
for i=1:size(bed,2)
    plotcube( sizeb, [bed(2,i) bed(1,i) 0], 1, [0 0.5 1]);
    plotcube( sizep, [bed(2,i) bed(1,i) sizeb(3)], 1, [1 1 1]);
end
axis([0 max(wall_coord(:,2)) 0 max(wall_coord(:,1)) 0 120 0 1])
axis off
% close all;




%scatter(wall_coord(:,2),wall_coord(:,1),5,[0 0 0], 'filled');
%scatter(agent(1,:), agent(2,:),5,[1 0.5 0],'filled');
%scatter(bed(2,:),bed(1,:),5,[0.25 1 0.5], 'filled');

%refreshdata
% drawnow
