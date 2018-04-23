function td = find3Dswitch(td,VtoH,HtoV)

%super crude way to find the trial when task orientation was switched if only one file was recorded.
%Need daily log to find R trials
%
%inputs are td struct and reward numbers when task was switched 2D - 3D and back

splittd = [];
for i = 1:length(td)
    splittd(i) = td(i).result == 'R';
end

sum = [];
sum(1)=splittd(1)+splittd(2);
for i = 2:length(splittd)-1
    sum(i)=sum(i-1) + splittd(i+1) ;
end

VtoH_trial = find(sum == VtoH);
HtoV_trial = find(sum == HtoV);

for i = VtoH_trial:HtoV_trial
    td(i).epoch = '3D';
end

end