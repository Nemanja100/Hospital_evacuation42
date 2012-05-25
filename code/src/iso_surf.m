function surfaces =iso_surf(results, axis_bed,axis_staff,axis_agents)

for i=1:size(results,2)
    
    for x=1:size(axis_bed,2)
        for y=1:size(axis_staff,2)
            for z=1:size(axis_agents,2)
                if((results(i).num_agents==axis_agents(z))&&(results(i).perc_staff==axis_staff(y))&&(results(i).perc_bed==axis_bed(x)))
                    surfaces(z,y,x)=size(results(i).history,3);
                end
            end
        end
    end
end