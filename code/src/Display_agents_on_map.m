function [] = Display_agents_on_map( agent,num_staff,  wall_coord, bed, firstplot )
% Function which recieves a structure with agent groups, a image with the
% walls and the sinks, and displays them in an image.
cla
axis equal
hold on
h =plot(wall_coord(:,2),wall_coord(:,1),'.k');
h = scatter(bed(2,:),bed(1,:),9,[0.25 1 0.5], 'filled');
%h=plot(bed(2,:),bed(1,:),'.y');
if(size(agent,2)>0)
    h= plot(agent(1,1:num_staff), agent(2,1:num_staff),'.b');
end
if(num_staff<size(agent,2))
    h= plot(agent(1,num_staff+1:size(agent,2)), agent(2,num_staff+1:size(agent,2)),'.r');
end
% scatter(wall_coord(:,2),wall_coord(:,1),4,[0 0 0], 'filled');
% scatter(agent(1,1:num_staff), agent(2,1:num_staff),5,[1 1 0],'filled');
% scatter(agent(1,num_staff:size(agent,2)), agent(2,num_staff:size(agent,2)),5,[0.5 0 1],'filled');
% scatter(bed(2,:),bed(1,:),9,[0.25 1 0.5], 'filled');
%hold off
%hfig = imgcf;
%refreshdata(h)

%drawnow;
pause(.1)


end

