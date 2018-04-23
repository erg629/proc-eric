                       %%% Lando Iso Analysis %%%
%  Looking for responses of firing rate in cuneate (and area2) during    %
%                        iso wrist movement task                         %
%      Can we learn something about GTO influence in neural activity?    %

load('Lando_RWIso_20170303_1_CDS.mat')
warning('Session contains %i aborted trials out of %i',sum(cds.trials.result == 'A'),height(cds.trials))
                                            %should introduce a pause here
                                            
params.do_onset = false;                    %part of the RWMovements fxn not needed for iso
params.include_ts = true;
params.extra_bins = [2,4];
td = parseFileByTrial(cds,params);
% td = getRWMovements(td,params);             %separates into both movements of the trial
td = binTD(td,5);
% clear cds                                  


%% Pre-processing to find windows before/after force on
for i = 1:length(td)
    bt_trial_time(i) = td(i).idx_endTime*0.05 + td(i).trial_start_time;     %finds the actual time of end of trial
end

for i = 1:length(td)-1
    bt_trial_time(i) = td(i+1).trial_start_time - bt_trial_time(i);         %time after trial i before the next starts
end
    
%% Polar plot with FRs by movement angle
targets = cat(1,td.target_center);  %doing this basically separates trials in a more useful way than getRWMovements
% td = getRWReachDirection(td,targets); %gets angles between targets, starts with row 2

force_angle = getIsoRWAngles(targets); %gets angles between targets

% right now there is an issue encountered if there are repeat angles. Tried
% to use unique, but not working atm

S1_spikes = zeros((length(td)),(size(td(1).LeftS1_spikes,2))); %sets up matrix for S1 units
for i = 1:length(td)
    for j = 1:size(S1_spikes,2)
        S1_spikes(i,j) = sum(td(i).LeftS1_spikes(:,j));        %firing of each unit during each trial
    end
end

cuneate_spikes = zeros((length(td)),(size(td(1).RightCuneate_spikes,2))); %sets up matrix for cuneate units
for i = 1:length(td)
    for j = 1:size(cuneate_spikes,2)
        cuneate_spikes(i,j) = sum(td(i).RightCuneate_spikes(:,j)); %firing of each unit during each trial
    end
end

PlotDirFiring(td,S1_spikes)
                                         %makes polar plots of firing rates vs reach angle                                    
PlotDirFiring(td,cuneate_spikes)


%% Fit LMs

force = cat(1,td.force);
s1Spiking = cat(1,td.LeftS1_spikes);
cuneateSpiking = cat(1,td.RightCuneate_spikes);

% histogram(force(:,1))
% figure                 %in case you're curious of where you should make the force flag
% histogram(force(:,2))

forceFlagx = abs(force(:,1)) > 1;      %flags forces over a certain
forceFlagy = abs(force(:,2)) > 1;      %threshold for use in lm calc

%make a table of units with reasonable Rsq
for unit = 1:size(s1Spiking,2)
    lmx = fitlm(force(forceFlagx), s1Spiking(forceFlagx,unit));
    if lmx.Rsquared.Ordinary > .1
        corrUnitS1(unit,1) = true;
    end
    
    lmy = fitlm(force(forceFlagy),s1Spiking(forceFlagy,unit));
    if lmy.Rsquared.Ordinary > .1
        corrUnitS1(unit,2) = true;
    end
end

for unit = 1:size(cuneateSpiking,2)
    lmx = fitlm(force(forceFlagx), cuneateSpiking(forceFlagx,unit));
    if lmx.Rsquared.Ordinary > .1
        corrUnitcuneate(unit,1) = true;
    end
    
    lmy = fitlm(force(forceFlagy), cuneateSpiking(forceFlagy,unit));
    if lmy.Rsquared.Ordinary > .1
        corrUnitcuneate(unit,2) = true;
    end
end