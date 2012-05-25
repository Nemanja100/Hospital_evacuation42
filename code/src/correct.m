function [ results ] = correct( results )
%correct A function which attempts to "correct" results from when simulation
%trapped people in walls, causing the total time to reach the maximum in
%all cases.

for i=1:size(results,2)
    end_nb=min(results(i).nb_patient_tot);
    last_val=0;
    t=1;
    while(last_val==0)
        if(results(i).nb_patient_tot(t)==end_nb)
            last_val=1;
            results(i).time=t;
        else
            t=t+1;
        end
        
    end
    
end

