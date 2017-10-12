%%Get PDs from experiment made in LandoAnalysis
for i = 1:height(ex.bin.pdData);
    pd(i) = ex.bin.pdData.velDir(i);
    CIlow(i) = ex.bin.pdData.velDirCI(i,1);
    CIhi(i) = ex.bin.pdData.velDirCI(i,2);
    Moddepth(i) = ex.bin.pdData.velModdepth(i);
end

for i = 1:height(ex.bin.pdData);
    units(i,:) = num2cell(linspace(CIlow(i),CIhi(i),10));
end

%%Graph PDs for all active units, showing proper orientation of CIs
close all

for i = 1:height(ex.bin.pdData);
   figure;
   polarplot([pd(i),pd(i)],[0,Moddepth(i)],'Linewidth',3) ;
   hold on
   polarplot([CIlow(i),CIlow(i)],[0,Moddepth(i)],'b');
   polarplot([CIhi(i), CIhi(i)],[0,Moddepth(i)],'b');
   polarplot([units{i,1},units{i,1}],[0,Moddepth(i)],'y');
   polarplot([units{i,2},units{i,2}],[0,Moddepth(i)],'y');
   polarplot([units{i,3},units{i,3}],[0,Moddepth(i)],'y');
   polarplot([units{i,4},units{i,4}],[0,Moddepth(i)],'y');
   polarplot([units{i,5},units{i,5}],[0,Moddepth(i)],'y');
   polarplot([units{i,6},units{i,6}],[0,Moddepth(i)],'y');
   polarplot([units{i,7},units{i,7}],[0,Moddepth(i)],'y');
   polarplot([units{i,8},units{i,8}],[0,Moddepth(i)],'y');
   polarplot([units{i,9},units{i,9}],[0,Moddepth(i)],'y');
   polarplot([units{i,10},units{i,10}],[0,Moddepth(i)],'y');
   title1 = ['Electrode' num2str(ex.bin.pdData.chan(i)), 'Unit' num2str(ex.bin.pdData.ID(i))];
   title(title1)
end