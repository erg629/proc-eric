%% Creates Table of Unit Firing Before, During, and After Delay
%%%%currently configured to be called within CompareFiring script%%%%
%%%%likely will be abandoned, but would like to fix windows before that%%%%

function[spikeCount] = delayBDA(moveDir,td)

unitNames = 'RightCuneate';
unitGuide = [unitNames, '_unit_guide'];
unitSpikes = [unitNames, '_spikes'];
numCount = 1:length(td(1).(unitSpikes)(1,:)); %clever way to get into the td for the array you want
unitsToPlot = numCount; 
avgUnitFiring = {}; 

for u = numCount
    spikeCount(u).Electrode = num2str(td(1).(unitGuide)(u,1)); %set up the spikeCount table for each unit
    spikeCount(u).Unit = num2str(td(1).(unitGuide)(u,2));
    
    for i = 1:length(moveDir) %for all trials of the current direction
        start = (moveDir(i).idx_startTime)/100;
        beforestop = (moveDir(i).idx_tgtOnTime)/100; %set time cutoffs for that trial
        duringstop = (moveDir(i).idx_movement_on)/100;
        stop = ((moveDir(i).idx_movement_on)/100) + 0.3;
        
        if moveDir(1).target_direction == pi/2 %fill in spikeCount table with a sum of spikes for the current unit
            spikeCount(u).UpBefore(i) = sum(moveDir(i).RightCuneate_ts{u,1} > start & moveDir(i).RightCuneate_ts{u,1} <= beforestop); %adds number of entries in this timeframe
            spikeCount(u).UpDuring(i) = sum(moveDir(i).RightCuneate_ts{u,1} > beforestop & moveDir(i).RightCuneate_ts{u,1} <= duringstop); %after tgt on and before movement on
            spikeCount(u).UpAfter(i) = sum(moveDir(i).RightCuneate_ts{u,1} > duringstop & moveDir(i).RightCuneate_ts{u,1} <= stop); %up to 300ms after movement on
        elseif moveDir(1).target_direction == pi
            spikeCount(u).LeftBefore(i) = sum(moveDir(i).RightCuneate_ts{u,1} > start & moveDir(i).RightCuneate_ts{u,1} <= beforestop);
            spikeCount(u).LeftDuring(i) = sum(moveDir(i).RightCuneate_ts{u,1} > beforestop & moveDir(i).RightCuneate_ts{u,1} <= duringstop);
            spikeCount(u).LeftAfter(i) = sum(moveDir(i).RightCuneate_ts{u,1} > duringstop & moveDir(i).RightCuneate_ts{u,1} <= stop);
        elseif moveDir(1).target_direction == 3*pi/2   
            spikeCount(u).DownBefore(i) = sum(moveDir(i).RightCuneate_ts{u,1} > start & moveDir(i).RightCuneate_ts{u,1} <= beforestop);
            spikeCount(u).DownDuring(i) = sum(moveDir(i).RightCuneate_ts{u,1} > beforestop & moveDir(i).RightCuneate_ts{u,1} <= duringstop);
            spikeCount(u).DownAfter(i) = sum(moveDir(i).RightCuneate_ts{u,1} > duringstop & moveDir(i).RightCuneate_ts{u,1} <= stop);
        elseif moveDir(1).target_direction == 0
            spikeCount(u).RightBefore(i) = sum(moveDir(i).RightCuneate_ts{u,1} > start & moveDir(i).RightCuneate_ts{u,1} <= beforestop);
            spikeCount(u).RightDuring(i) = sum(moveDir(i).RightCuneate_ts{u,1} > beforestop & moveDir(i).RightCuneate_ts{u,1} <= duringstop);
            spikeCount(u).RightAfter(i) = sum(moveDir(i).RightCuneate_ts{u,1} > duringstop & moveDir(i).RightCuneate_ts{u,1} <= stop);
        end
    end
end

end