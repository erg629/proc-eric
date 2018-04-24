%% Load data
clear all

meta.lab=6;
meta.ranBy='Eric';
meta.monkey='Han';
meta.date='20180413';
meta.task='COC3D'; % for the loading of cds
meta.taskAlias={'COC3D_001','COC3D_002','COC3D_003','COC3D_004'}; % for the filename (cell array list for files to load and save)
meta.array='LeftS1Area2'; % for the loading of cds
meta.arrayAlias='area2'; % for the filename
meta.project='COC3D'; % for the folder in data-preproc
meta.superfolder=fullfile('C:\Users\erg629\Documents\MATLAB\MonkeyData\RawData\',meta.monkey); % folder for data dump
meta.folder=fullfile(meta.superfolder,meta.date,'TD'); % compose subfolder and superfolder

filename = [meta.monkey '_' meta.date '_TD.mat'];
path = [meta.folder '\' filename];
load(path);

%% Parameters
clear params

params = struct( ...
    'array',        'area2',...
    'out_signals',  'area2_spikes',...
    'space',        '3D',...
    'targ_dir',     [-pi/4, 0, pi/4, pi/2, 3*pi/4, pi, -3*pi/4],...
    'targ_dir_all', [-3*pi/4, -pi/2, -pi/4, 0, pi/4, pi/2, 3*pi/4, pi],...
    'xBound',       [-0.3 1],...
    'num_bins',     8,...
    'trim_win',     [0, 1],...
    'bin_size',     trial_data(1).bin_size);

%% Unit Rasters

neuronsamp = [1:size(trial_data(1).area2_spikes,2)];

% params.align = 'stLeave';  %for CO stLeave, for OC otLeave
% params.sortt = 'ftHold';
% params.idx_raster = {'stLeave','otHold','otLeave','ftHold'};
% params.idx_raster_col = {'g','m','c','y'};
% params.idx_raster_bound = {'stLeave','otHold'};
% params.epoch = '3D';
% 
% td = removeBadTrials(trial_data);
% %td = find3Dswitch(td,160,252); %this changes some movements to 3D if the task was switched midway through one file. Need numbers from daily log as inputs
% params.movem = 'CO';
% td = removeSpontTrials(td,params);
% 
% for j = 1:length(neuronsamp) %removes trials where target was activated by arm covering both targets
%     params.neuron = neuronsamp(j);
%     [~,td] = getTDidx(td,'epoch',params.epoch);
% %     td(20) = td(19);
% %     td(20).target_direction = -3*pi/4;   %had to temporarily throw this in to fix error...don't get in the habit
% %     td(74).area2_spikes(:,:) = 0;
%     unitRaster3D(td,params);
%     %epochRaster(td,params);
% end


epochs = {'2D','3D'};
movems = {'CO'}%,'OC'};

params.idx_raster = {'stLeave','otHold','otLeave','ftHold'};
params.idx_raster_col = {'g','m','c','y'};
params.idx_raster_bound = {'stLeave','otHold'};

savefig = 0;

for i = 1:length(epochs)

    params.epoch = epochs{i};
    
    for j = 1:length(movems)
        if strcmp(movems{j},'CO')
            params.align = 'stLeave';
            params.sortt = 'otHold';
            params.xBound = [-0.3,1];
            params.idx_raster = {'stLeave','otHold','otLeave','ftHold'};
            params.idx_raster_col = {'g','r','b','m'};
        else
            params.align = 'otLeave';
            params.sortt = 'ftHold';
            params.xBound = [-0.3,1];
            params.idx_raster = {'otLeave','ftHold'};
            params.idx_raster_col = {'b','m'};
        end
        
        td = removeBadTrials(trial_data);
        params.movem = movems{j};
        td = removeSpontTrials(td,params);
        
        for k = 1:length(neuronsamp)
            params.neuron = neuronsamp(k);
            [~,td] = getTDidx(td,'epoch',params.epoch);
            unitRaster3D(td,params);
            %epochRaster(td,params);
            if savefig
                figname = [meta.monkey,'_',meta.date,'_n',num2str(neuronsamp(k)),'_',params.epoch,'_',params.movem,'_Raster.png'];
                if strcmp(computer,'MACI64')
                    saveas(gcf,['/Users/virginia/Documents/MATLAB/LIMBLAB/Data/Figs/',figname])
                else
                    saveas(gcf,['C:\Users\vct1641\Documents\Figs\',figname])
                end
            end
        end
    end 
end


%% Firing modulated?




%% Tuning curves
%Need to get ModDepth or CI of some sort
%also this just calls the direction with most firing the pd...hmm
epochs = {'2D','3D'};
movems = {'CO','OC'};
params.trim_win = [0, 0];
params.out_signals = 'area2_spikes'; %signal to get tuning from
params.move_corr = 'target_direction'; %correlate of firing to use

j = 0;

for k = 1:length(movems)
    for i = 1:length(epochs)
        params.epoch = epochs{i};
        
        td = removeBadTrials(trial_data);
        if params.epoch == '3D'
            td = find3Dswitch(td,160,252);
        end
        params.movem = movems{k};
        td = removeSpontTrials(td,params);
        
        [~,td] = getTDidx(td,'epoch',params.epoch);
        
%         if strcmp(params.movem,'CO')
%             td = trimTD(td,{'idx_stLeave',params.trim_win(1)/params.bin_size},{'idx_otHold',params.trim_win(2)/params.bin_size});
%         else
%             td = trimTD(td,{'idx_otLeave',params.trim_win(1)/params.bin_size},{'idx_ftHold',params.trim_win(2)/params.bin_size});
%         end
%         
        j = j+1;
        tuning(j).epoch = epochs{i};
        tuning(j).movem = params.movem;
        tuning(j).ntrials = size(td,2);
        
%         tuneResp = getTuningCurves(td,params);     %R's version
%         tuningR(j).bins = tuneResp.bins;
%         tuningR(j).mean_spikes = tuneResp.binnedResponse;
%         tuningR(j).std_err = tuneResp.binned_stderr;
%         tuningR(j).CIHigh = tuneResp.binned_CIhigh;
%         tuningR(j).CILow = tuneResp.binned_CIlow;
        
        tunResp = getTuning3D(td,params);     %V's version
        tuning(j).mean_spikes = tunResp.mean_spikes;
        tuning(j).std_err = tunResp.std_err;
        tuning(j).bins = tunResp.bins;
        tuning(j).PD = tunResp.PD;
    end
end

%% Cos fit
savefig = 0;
% neuronsamp = [5,16,17,25];

targ_dir = params.targ_dir;
targ_dir_all = params.targ_dir_all;

for k = 1:length(movems)
    
    tunmov = tuning(strcmp({tuning.movem},movems{k}));
    
    for i = 1:length(neuronsamp)
        figure
        cols = {'k','r'};
        
        for j = 1:size(tunmov,2)
            
            epoch = tunmov(j).epoch;
            movem = tunmov(j).movem;
            spikes_neu = tunmov(j).mean_spikes(neuronsamp(i),:);
            std_err_neu = tunmov(j).std_err(neuronsamp(i),:);
%             ci_low_neu = tunmov(j).CILow(neuronsamp(i),:);
%             ci_high_neu = tunmov(j).CIHigh(neuronsamp(i),:);
            bins = tunmov(j).bins;
            
            spikes_neu_dir = spikes_neu(ismember(bins,targ_dir))';
            std_err_neu_dir = std_err_neu(ismember(bins,targ_dir));
%             ci_low_neu_dir = ci_low_neu(ismember(bins,targ_dir));
%             ci_high_neu_dir = ci_high_neu(ismember(bins,targ_dir));
            bins_dir = rad2deg(bins(ismember(bins,targ_dir)));
            
            x0 = [1,1,1];
            tun_fun =  @(x) (x(1)+x(2)*cosd(bins_dir-x(3)))-spikes_neu_dir;  %i don't get this fxn at all
            [x,resnorm,residual,exitflag,output] = lsqnonlin(tun_fun,x0,[],[],optimset('Display','off'));
            
            bins_lin = rad2deg(linspace(min(targ_dir),max(targ_dir),1000));  %creates other points to smooth the curve
            fun = @(x) (x(1)+x(2)*cosd(bins_lin-x(3)));
            
            h(j) = plot(bins_lin,fun(x),cols{j},'linewidth',1.5); hold on;
            plot(bins_dir,spikes_neu_dir,[cols{j},'*'])
            errorbar(bins_dir,spikes_neu_dir,std_err_neu_dir,[cols{j},'.'])
            xlabel('Target Direction [deg]','fontsize',12);
            ylabel('Mean Firing Rate [Hz]','fontsize',12);
            title(['Tuning: Neuron ',num2str(neuronsamp(i)),', ',movem],'fontsize',14); 
            xlabel('Target Direction [deg]','fontsize',10);
            ylabel('Mean Firing Rate [Hz]','fontsize',10);
            electrode = td(1).area2_unit_guide(neuronsamp(i),1);
            unit = td(1).area2_unit_guide(neuronsamp(i),2);
            title(['Tuning: ',(sprintf('Electrode%i',electrode)),', ',(sprintf('Unit%i',unit)),', ',movem]); 
        end
        legend(h,epochs);
        ax = gca;
        ax.XTick = rad2deg(targ_dir_all);
        
        if savefig
            figname = [meta.monkey,'_',meta.date,'_n',num2str(neuronsamp(i)),'_',movem,'_Tuning.png'];
            if strcmp(computer,'MACI64')
                saveas(gcf,['/Users/virginia/Documents/MATLAB/LIMBLAB/Data/Figs/',figname])
            else
                saveas(gcf,['C:\Users\vct1641\Documents\Figs\',figname])
            end
        end
    end
end

%% Trial Average
%won't work if no time data. ie, need emg...
savefig = 0;
targ_dir = sort(params.targ_dir);
params.do_stretch = true;
params.num_samp = 60;

for k = 1:length(movems)
    
    td = removeBadTrials(trial_data);
    params.movem = movems{k};
    td = removeSpontTrials(td,params);
    
    if strcmp(params.movem,'CO')
        tdt = trimTD(td,{'idx_stLeave',0},{'idx_stLeave',60});
    else
        tdt = trimTD(td,{'idx_otLeave',0},{'idx_otLeave',60});
    end
    
    for i = 1:length(neuronsamp)
        figure
        cols = {'k','r'};
        
        for j = 1:length(epochs)
            params.epoch = epochs{j};
            [~,td] = getTDidx(tdt,'epoch',params.epoch);
            [avg_data,~] = trialAverage(td,{'target_direction'},params);
            
            PDs = tuning(strcmp({tuning.movem},movems{k})&strcmp({tuning.epoch},epochs{j})).PD;
            avg_data_dir = avg_data(targ_dir == PDs(neuronsamp(i)));
            avg_spikes = movmean(avg_data_dir.S1_spikes(:,neuronsamp(i))/(td(1).bin_size),4);
            time_spikes = linspace(0,length(avg_spikes),length(avg_spikes))*(td(1).bin_size);
            
            h(j) = plot(time_spikes,avg_spikes,cols{j}); hold on;
            xlabel('Time [s]','fontsize',12); 
            ylabel('Mean Firing Rate [Hz]','fontsize',12);
            title(['FR: Neuron ',num2str(neuronsamp(i)),', ',params.movem],'Fontsize',14)
            xlim([min(time_spikes),max(time_spikes)])
        end
        legend(h,epochs);
        
        if savefig
            figname = [meta.monkey,'_',meta.date,'_n',num2str(neuronsamp(i)),'_',params.movem,'_FR.png'];
            if strcmp(computer,'MACI64')
                saveas(gcf,['/Users/virginia/Documents/MATLAB/LIMBLAB/Data/Figs/',figname])
            else
                saveas(gcf,['C:\Users\vct1641\Documents\Figs\',figname])
            end
        end
    end
end