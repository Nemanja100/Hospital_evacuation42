function max_in_area=find_groups(results, radii, step)
radii=radii.^2;

max_in_area.size=zeros(size(radii));


for idx=1:size(results,2)
    max_in_area(idx).size=zeros(size(radii));
    for time =1:step:size(results(idx).history,3)
        counter=zeros(size(radii));
        for a=1:size(results(idx).history,2)
            for b=1:size(results(idx).history,2)
                if((a~=b)&&(results(idx).history(1,a,time)~=0)&&(results(idx).history(1,b,time)~=0))
                    distsq=(results(idx).history(1,a,time)-results(idx).history(1,b,time))^2+(results(idx).history(2,a,time)-results(idx).history(2,b,time))^2;
                    for(r=1:size(radii,2))
                        if(distsq<radii(r))
                            counter(r)=counter(r)+1;
                        end
                    end
                end
            end
        end
        for r=1:size(radii,2)
            if(counter(r)>max_in_area(idx).size(r))
                max_in_area(idx).size(r)=counter(r);
                max_in_area(idx).time(r)=time;
            end
        end
    end
end

