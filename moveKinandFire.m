%% Plots Movement Kinematics and Firing Rates
%%%%currently configured to be called within CompareFiring script%%%%

function[Fig] = moveKinandFire(moveDir,td,cds)

plotRasters = 1;
savePlots = 0;
beforeMove = .3;
afterMove = .3;
unitNames = 'RightCuneate';
unitGuide = [unitNames, '_unit_guide'];
unitSpikes = [unitNames, '_spikes'];
w = gausswin(5); 
w = w/sum(w);
numCount = 1:length(td(1).(unitSpikes)(1,:)); %clever way to get into the td for the array you want
unitsToPlot = numCount; %right now these are just numbered 1-24
% numCount = unitsToPlot;
avgUnitFiring = {}; 

for num1 = numCount
    
title1 = ['Lando', unitNames, ' Electrode' num2str(td(1).(unitGuide)(num1,1)), ' Unit ', num2str(td(1).(unitGuide)(num1,2))];
title2 = char.empty;
    if moveDir(1).target_direction == pi/2
        title2 = 'Up';
    elseif moveDir(1).target_direction == pi
        title2 = 'Left';
    elseif moveDir(1).target_direction == 3*pi/2
        title2 = 'Down';
    elseif moveDir(1).target_direction == 0
        title2 = 'Right';
    end
%     
moveKin = zeros(length(moveDir), length(moveDir(1).idx_movement_on-(beforeMove*100):moveDir(1).idx_movement_on+(afterMove*100)), 2);
    % Generate Movement Kinematics
    for  i = 1:length(moveDir)
        moveKin(i,:,:) = moveDir(i).vel(moveDir(i).idx_movement_on-(beforeMove*100):moveDir(i).idx_movement_on+(afterMove*100),:);
        moveForce(i,:,:) = moveDir(i).force(moveDir(i).idx_movement_on- (beforeMove*100):moveDir(i).idx_movement_on+(afterMove*100),:);
%         moveEMG(i,:,:) = moveDir(i).emg(moveDir(i).idx_movement_on- (beforeMove*100):moveDir(i).idx_movement_on+(afterMove*100),:);
    end
    meanMoveKin = squeeze(mean(moveKin));
    speedMoveKin = sqrt(meanMoveKin(:,1).^2 + meanMoveKin(:,2).^2);
    meanMoveForce = squeeze(mean(moveForce));
%     meanMoveEMG = squeeze(mean(moveEMG));
    
    moveDirFiring = zeros(length(moveDir), length(speedMoveKin));
    Fig = figure();
    suptitle([title1, title2])
    subplot(2,1,1);
    plot(linspace(-1*beforeMove, afterMove, length(speedMoveKin(:,1))), speedMoveKin(:,1), 'k')
    hold on
    %plot([0,0],[0,40], 'b--') %since i changed window maybe isnt centered?
    ylim([0,40])
    xlim([-1*beforeMove, afterMove])
    set(gca,'TickDir','out','box', 'off') 
    set(gca,'xtick',[],'ytick',[])

    if moveDir(1).target_direction == pi/2
        trialTable = cds.trials([cds.trials.result] =='R' & [cds.trials.tgtDir] == 90,:);
    elseif moveDir(1).target_direction == pi
         trialTable = cds.trials([cds.trials.result] =='R' & [cds.trials.tgtDir] == 180,:);
    elseif moveDir(1).target_direction == 3*pi/2
         trialTable = cds.trials([cds.trials.result] =='R' & [cds.trials.tgtDir] == 270,:);
    elseif moveDir(1).target_direction == 0
         trialTable = cds.trials([cds.trials.result] =='R' & [cds.trials.tgtDir] == 0,:);
    end
   
    window = [[trialTable.startTime] + .01* [moveDir.idx_movement_on]' - .01*[moveDir.idx_startTime]'-beforeMove, [trialTable.startTime]+ .01*[moveDir.idx_movement_on]'- .01*[moveDir.idx_startTime]'+afterMove];
    cuneateUnits= cds.units(strcmp({cds.units.array}, unitNames) & [cds.units.ID] >0 & [cds.units.ID]<255);
    unit = cuneateUnits(num1);
    spikeList = [unit.spikes.ts];
    if plotRasters
        for  i = 1:length(moveDir)
            moveDirTotal(i) = sum(moveDir(i).(unitSpikes)(moveDir(i).idx_movement_on:moveDir(i).idx_movement_on+(afterMove*100),num1));
        end
        [~,sortMat] = sort(moveDirTotal);
        for trialNum = 1:height(trialTable)
            trialWindow = [window(sortMat(trialNum),1), window(sortMat(trialNum),2)];
            first = find(spikeList>trialWindow(1),1);
            last = find(spikeList >trialWindow(2),1)-1;
            for spike = first:last
                x = [spikeList(spike)-trialWindow(1)-beforeMove, spikeList(spike)-trialWindow(1)-beforeMove];
                y = [trialNum*40/height(trialTable), trialNum*40/height(trialTable)+.5*40/height(trialTable)];
                plot(x,y,'k')
                hold on
            end
            
        end
    end
    
        %Firing
    subplot(2,1,2)
    xlim([-1*beforeMove, afterMove])
    for  i = 1:length(moveDir)
        moveDirFiring(i,:) = moveDir(i).(unitSpikes)(moveDir(i).idx_movement_on-(beforeMove*100):moveDir(i).idx_movement_on+(afterMove*100),num1);
    end                                                                                                        

    meanMoveDirFiring = 100*mean(moveDirFiring);
    bar(linspace(-1*beforeMove, afterMove, length(meanMoveDirFiring)), conv(meanMoveDirFiring, w, 'same'), 'edgecolor', 'none', 'BarWidth', 1)
    set(gca,'TickDir','out', 'box', 'off')
    set(gca,'xtick',[],'ytick',[])
    xlim([-1*beforeMove, afterMove])
    meanMoveFiring = mean(meanMoveDirFiring);
    
end
end