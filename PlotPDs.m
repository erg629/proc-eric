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

%%Eliminate units with >5% CI
% CIbound = 0.025.*pd;
% for i = 1:height(ex.bin.pdData);
% lowbound(i) = pd(i) - CIbound(i);
% hibound(i) = pd(i) + CIbound;
% end

%%allowing a 90deg range for CIs, just so there are some left...
% for i = 1:length(CIlow)
%     CIlow(i) = CIlow(i) + 2*pi;
%     CIhi(i) = CIhi(i) + 2*pi;
% 
% if CIhi(i) - CIlow(i) < pi/2 & CIhi(i) - CIlow(i) > 0;
%     smallCI(i) = true;
% end
% 
% end

%%Graph PDs for all active units, showing proper orientation of CIs
close all
for i = 1:height(ex.bin.pdData);
   figure;
   polarplot([pd(i),pd(i)],[0,Moddepth(i)],'Linewidth',3) ;
   hold on
   polarplot([CIlow(i),CIlow(i)],[0,Moddepth(i)],'b');
   polarplot([CIhi(i), CIhi(i)],[0,Moddepth(i)],'b');
   for j = 1:10;
   polarplot([units{i,j},units{i,j}],[0,Moddepth(i)],'r');
   end 
  %  if lowbound(i) > CIbound(i)| hibound(i) > CIbound(i);  %in 20170903 there are no units within a 5% CI...wahp
   %     close
   % end
%    if smallCI(i) == 0;
%        close
%    end
   title1 = [(ex.bin.pdData.array(i)),'Electrode' num2str(ex.bin.pdData.chan(i)), 'Unit' num2str(ex.bin.pdData.ID(i))];
   title(title1)
end