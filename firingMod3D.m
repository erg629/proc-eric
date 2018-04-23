function [modulation] = firingMod3D(td,params)
%calculate baseline firing rates and see if modulated during reach

%targ_dir = params.targ_dir;

Zero = td([td.target_direction] == 0);
Fortyfive = td([td.target_direction] == pi/4);
Ninety = td([td.target_direction] == pi/2);
Onethirtyfive = td([td.target_direction] == 3*pi/4);
Oneeighty = td([td.target_direction] == pi);
Twotwentyfive = td([td.target_direction] == -3*pi/4);
Threefifteen = td([td.target_direction] == -pi/4);

zeroSpikes = cat(1,Zero.area2_spikes);
fortyfiveSpikes = cat(1,Fortyfive.area2_spikes);
ninetySpikes = cat(1,Ninety.area2_spikes);
onethirtyfiveSpikes = cat(1,Onethirtyfive.area2_spikes);
oneeightySpikes = cat(1,Oneeighty.area2_spikes);
twotwentyfiveSpikes = cat(1,Twotwentyfive.area2_spikes);
threefifteenSpikes = cat(1,Threefifteen.area2_spikes);



% for i = 1:length(reach)    %you're on the right track here but it's late
%     for j = size(td(1).area2_spikes,2)
%         spikes(i,j) = cat(1,reach{i,1}(:).area2_spikes(:,j));
%     end
% end
%         for k = length(reach{i,1})
%          baseline(i,j) = sum(reach{i,1}(k).area2_spikes(reach{i,1}
% 

% for i = 1:length(td)
%     for j = 1:size(td(1).area2_spikes,2)
%     base_firing = td(i)