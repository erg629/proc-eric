%% Cuneate Firing During Delay Tasks
%%%%Plots movement kinematics, firing rates, and PDs before, during, and after delay%%%%
%%%%Set up to have five figures per unit now...trying to reduce to 2 per unit%%%%

load('Lando_CODelay_20170905_2_CDS')
close all
clearvars -except cds
params.event_list = {};
params.extra_time = [.4,.6];
params.include_ts = true;
td = parseFileByTrial(cds, params);
td = td(~isnan([td.target_direction]));
params.start_idx =  'idx_goCueTime';
params.end_idx = 'idx_endTime';
td = getMoveOnsetAndPeak(td, params);
td = binTD(td,5);
td = getSpeed(td); %will allow flagging when hand vel is below some threshold
clear cds; %unless using moveKinandFire

date = 09052017;

%% Data Preparation and sorting out trials

upMove = td([td.target_direction] ==pi/2); 
leftMove = td([td.target_direction] ==pi); 
downMove = td([td.target_direction] ==3*pi/2); 
rightMove = td([td.target_direction]==0); 

%% Kinematic and Firing Rate Plots, Spike Counts

close all
    
    moveDir = upMove;
    %moveKinandFire(moveDir,td,cds);
    upSpikeCount = delayBDA(moveDir,td);

    moveDir = leftMove;
    %moveKinandFire(moveDir,td,cds);
    leftSpikeCount = delayBDA(moveDir,td);
    
    moveDir = downMove;
    %moveKinandFire(moveDir,td,cds);
    downSpikeCount = delayBDA(moveDir,td);
    
    moveDir = rightMove;
    %moveKinandFire(moveDir,td,cds);
    rightSpikeCount = delayBDA(moveDir,td);
    
    firingPlots(upSpikeCount,leftSpikeCount,downSpikeCount,rightSpikeCount);