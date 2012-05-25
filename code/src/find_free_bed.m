function bed_free_idx = find_free_bed(connex_s2b, nb_bed)
bed_free_idx=[];
free_bed_counter=1;
for i=1:nb_bed
    same =0;
    for j=1:size(connex_s2b,2)
        if(connex_s2b(2,j)==i)
            same=1;
        end
    end
    if(same==0)
        bed_free_idx(free_bed_counter)=i;
        free_bed_counter=free_bed_counter+1;
        same=0;
    end
end
