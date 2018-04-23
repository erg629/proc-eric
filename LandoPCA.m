%% PCA of Neural, Joint, EMG space and More!

load('Lando_RW_hold_20170728_001_CDS_MotionTracking')
close all
clearvars -except cds
params.do_plot = true;                %makes the scree plot that will be needed when deciding number of PCs
params.include_ts = true;             %just in case, can take out later if unnecessary
params.trial_results = {'R','A'};     %including I and F shouldn't make a huge difference, but can later 
td = parseFileByTrial(cds, params);
td = binTD(td,5);
td = getRWMovements(td,params);       %separates multiple targets per trial in RW tasks - also seems to take out the unit guide?
td = removeNaNTD(td,'idx_idx_movement_on','idx_endTime');
td = trimTD(td, {'idx_idx_movement_on'}, {'idx_endTime'}); %why idx_idx? Problem for another time
clear cds;
%%
%if isfield(td,'opensim')
params.signals = {'opensim',1:7};     %only takes joint angles
params.do_standardize = true;
params.sqrt_transform = false;
td = getPCA(td,params);
jointAnglePCs = input('How many joint angle PCs? ');
%end

%if isfield(td,'RightCuneate_spikes')
%    td = RenameField(td,'RightCuneate_spikes','cuneate_spikes');
%end
%if isfield(td,'cuneate_spikes')
params.signals = 'cuneate_spikes';
params.do_standardize = false;
params.sqrt_transform = true;
td = getPCA(td,params);
cuneatePCs = input('How many cuneate PCs? ');
%end

% if isfield(td,'LeftS1_spikes')
%     td = RenameField(td,'LeftS1_spikes','area2_spikes');
% end
% if isfield(td,'area2_spikes')
params.signals = 'area2_spikes';
params.do_standardize = false;
params.sqrt_transform = true;
td = getPCA(td,params);
area2PCs = input('How many area2 PCs? ');
%end

%if isfield(td,'emg')
params.signals = 'emg';
params.do_standardize = true;
params.sqrt_transform = false;
td = getPCA(td,params);
emgPCs = input('How many emg PCs? ');
%end

close all

%% Concatenate and set up data
%Takes as many PCs as you indicate at the start from the complete set%

if isfield(td,'opensim_pca')
jointAnglePC = cat(1,td.opensim_pca);
for i = 1:jointAnglePCs
    jointAngle_PC(:,i) = jointAnglePC(:,i);
end
clear jointAnglePC;
end

if isfield(td,'cuneate_pca')
cuneatePC = cat(1,td.cuneate_pca);
for i = 1:cuneatePCs
    cuneate_PC(:,i) = cuneatePC(:,i);
end
clear cuneatePC;
end

if isfield(td,'area2_pca')
area2PC = cat(1,td.area2_pca);
for i = 1:area2PCs
    area2_PC(:,i) = area2PC(:,i);
end
clear area2PC;
end

if isfield(td,'emg_pca')
emgPC = cat(1,td.emg_pca);
for i = 1:emgPCs
    emg_PC(:,i) = emgPC(:,i);
end
clear emgPC;
end

pos = cat(1,td.pos);
vel = cat(1,td.vel);
acc = cat(1,td.acc);
force = cat(1,td.force);

PCstoanalyze = cat(2,jointAngle_PC,cuneate_PC,area2_PC,emg_PC,pos,vel,acc,force);

%% Covariance Matrix

cov_all = cov(PCstoanalyze);

%% Plot targets
%need to figure out how to eliminate overlapping areas

targets = cat(1,td.target_center);
% figure
% plot_RW_dir(targets)
% scatter(targets(:,1),targets(:,2),2,'k','filled')
% hold on
% scatter(0,0,15,'r','filled')
% xlim([-10,10]);
% ylim([-10,10]);

% td = getRWTargetDirection(td,targets); %updates td with directions

%% Label movement direction between trials

td = getRWReachDirection(td,targets);

%% Testing out some PCA stuff



params.space1 = 'cuneate';   %set which pcs to compare
params.space2 = 'cuneate';
comparePCs(td, 1,2,params);
