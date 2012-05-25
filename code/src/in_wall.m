function [x_coord y_coord] = in_wall(x_coord,y_coord,x_vel,y_vel,wall_map)
% function which verifies that the position of an agent is not in the wall
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT:
%   x_coord: x coordinate to be tested
%   y_coord: y coordinate to be tested
%   x_vel: velocity in direction x
%   y_vel: velocity in direction y
%   wall_map: map of the situation (0==wall, 1==empty space)
% OUTPUT:
%   x_coord: corrected x coordinate
%   y_coord: corrected y coordinate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[y_size_map x_size_map] = size(wall_map);

x_coord_new = x_coord;
y_coord_new = y_coord;

if (x_vel>0)
    for i = 1:round(x_coord)-1
        if(wall_map(round(y_coord),round(x_coord)-i)==1)
            x_coord_new = round(x_coord)-i;
            break;
        end
    end
end

if (x_vel<0)
    for i = 1:(x_size_map-round(x_coord)-1)
        if(wall_map(round(y_coord),round(x_coord)+i)==1)
            x_coord_new = round(x_coord)+i;
            break;
        end
    end
end

if (x_vel==0)
    x_coord_new = round(x_coord);
end

if (y_vel>0)
    for j = 1:round(y_coord)-1
        if(wall_map(round(y_coord)-j,round(x_coord))==1)
            y_coord_new = round(y_coord)-j;
            break;
        end
    end
end

if (y_vel<0)
    for j = 1:(y_size_map-round(y_coord)-1)
        if(wall_map(round(y_coord)+j,round(x_coord))==1)
            y_coord_new = round(y_coord)+j;
            break;
        end
    end
end


if (y_vel==0)
    y_coord_new = round(y_coord);
end

if(abs(round(x_coord)-x_coord_new)~=0)
    x_coord = x_coord_new;
    y_coord = round(y_coord);
elseif(abs(round(y_coord)-y_coord_new)~=0)
    x_coord = round(x_coord);
    y_coord = y_coord_new;
elseif((abs(round(x_coord)-x_coord_new)~=0)&&(abs(round(y_coord)-y_coord_new)~=0))
    if(abs(round(x_coord)-x_coord_new)<abs(round(y_coord)-y_coord_new))
        x_coord = x_coord_new;
        y_coord = round(y_coord);
    else
        x_coord = round(x_coord);
        y_coord = y_coord_new;
    end
end
end
