function [bed_coords1]=sort_bed(bed_coords,exit_coords)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a=size(bed_coords,2);
for m=1:a
    distance(m)=sqrt((exit_coords(1,1)-bed_coords(1,m)).^2+(exit_coords(2,1)-bed_coords(2,m))^2);
end
%distance=distance';
bed=[bed_coords;distance];
bed(:,(a+1):(a+100))=-1000;

for m=1:a
   for n=1:a
     if (bed(3,m+n)>bed(3,m))
         q=bed(:,m+n);
         p=bed(:,m);
         bed(:,m+n)=p;
         bed(:,m)=q;
    end
   end
end

bed(:,(a+1):(a+100))=[];
bed(3,:)=[];
bed_coords1=bed;


                