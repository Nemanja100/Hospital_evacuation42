function conex_s2b =staff2bed(staff, beds)
conex_s2b=zeros(2,size(staff,2));
dist=zeros(size(beds,2) ,size(staff,2));
for i=1:size(beds,2)
    for j=1:size(staff,2)
        dist(i,j)=sqrt((staff(1,j)-beds(2,i))^2+(staff(2,j)-beds(1,i))^2);
    end
end

for k=1:size(staff,2)
    min=1000;
    for i=1:size(dist,1)
        for j=1:size(dist,2)
            if(dist(i,j)<=min)
                min=dist(i,j);
                idx_staff=j;
                idx_bed=i;
            end
        end
    end
    dist(idx_bed,:)=1000;
    dist(:,idx_staff)=1000;
    conex_s2b(1,k)=idx_staff;
    conex_s2b(2,k)=idx_bed;
    
end