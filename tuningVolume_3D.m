% Working up to a 3D tuning volume calculation using principles from
% Georgopoulos et al 1988
%
% Needs some optimization, pretty slow at calculating all the means and ANOVA right now
%
%
% Written by eg, Apr 2018
%

movems = {'CO','OC'};

for i = 1:length(movems)
    if strcmp(movems(i),'CO')
        for j = 1:length(td)
            CT(j,:) = [td(j).idx_stHold td(j).idx_goCue];                  %control time
            RT(j,:) = [td(j).idx_goCue td(j).idx_stLeave];                 %reaction time
            MT(j,:) = [td(j).idx_stLeave td(j).idx_otHold];                %movement time
            TET(j,:)= [td(j).idx_goCue td(j).idx_otHold];                  %total experiment time
        end
        
    else for j = 1:length(td)
            CT(j,:) = [td(j).idx_otHold td(j).idx_goBackCue];
            RT(j,:) = [td(j).idx_goBackCue td(j).idx_otLeave];
            MT(j,:) = [td(j).idx_otLeave td(j).idx_endTime];
            TET(j,:)= [td(j).idx_goBackCue td(j).idx_endTime];
        end
    end
    
  
    for trial = 1:length(td)                                                   %for each trial
        
        for unit = 1:length(td(1).area2_unit_guide)                            %for each neuron
            
            CT_spikes(trial,unit) = 0;                                        
            for idx = CT(trial,1):CT(trial,2)                                  %between the indices of CT for that trial
                CT_spikes(trial,unit) = CT_spikes(trial,unit) +...
                    td(trial).area2_spikes(idx,unit);                          %add all spikes in the window
            end
            CT_bins(trial) = CT(trial,2) - CT(trial,1) + 1;                    %number of bins during the epoch
            CT_mean_spikes(trial,unit) = CT_spikes(trial,unit)./CT_bins(trial);%mean spikes during the epoch
            
            RT_spikes(trial,unit) = 0;
            for idx = RT(trial,1):RT(trial,2)
                RT_spikes(trial,unit) = RT_spikes(trial,unit) +...
                    td(trial).area2_spikes(idx,unit);
            end
            RT_bins(trial) = RT(trial,2) - RT(trial,1) +1;
            RT_mean_spikes(trial,unit) = RT_spikes(trial,unit)./RT_bins(trial);
            
            MT_spikes(trial,unit) = 0;
            for idx = MT(trial,1):MT(trial,2)
                MT_spikes(trial,unit) = MT_spikes(trial,unit) +...
                    td(trial).area2_spikes(idx,unit);
            end
            MT_bins(trial) = MT(trial,2) - MT(trial,1) +1;
            MT_mean_spikes(trial,unit) = MT_spikes(trial,unit) ./MT_bins(trial);
            
            TET_spikes(trial,unit) = RT_spikes(trial,unit) +...
                MT_spikes(trial,unit);
            TET_bins(trial) = RT_bins(trial) + MT_bins(trial);
            TET_mean_spikes(trial,unit) = TET_spikes(trial,unit) ./...
                TET_bins(trial);
            
            unit_epoch_means = cat(2,CT_mean_spikes(:,unit),...            %prep data for ANOVA...only between control
                TET_mean_spikes(:,unit));                                  %and total experiment for now
            
            
            epoch_spikes(unit).Electrode = td(1).area2_unit_guide(unit,1);
            epoch_spikes(unit).Unit = td(1).area2_unit_guide(unit,2);
            if strcmp(movems(i),'CO')
                epoch_spikes(unit).CT_mean_CO = sum(CT_spikes(:,unit)) / sum(CT_bins);%mean of all spikes over all bins during CT
                epoch_spikes(unit).RT_mean_CO = sum(RT_spikes(:,unit)) / sum(RT_bins);
                epoch_spikes(unit).MT_mean_CO = sum(MT_spikes(:,unit)) / sum(MT_bins);
                epoch_spikes(unit).TET_mean_CO = sum(TET_spikes(:,unit)) / sum(TET_bins);
                epoch_spikes(unit).p_CO = anova1(unit_epoch_means,[],'off');       %ANOVA
            else
                epoch_spikes(unit).CT_mean_OC = sum(CT_spikes(:,unit)) / sum(CT_bins);
                epoch_spikes(unit).RT_mean_OC = sum(RT_spikes(:,unit)) / sum(RT_bins);
                epoch_spikes(unit).MT_mean_OC = sum(MT_spikes(:,unit)) / sum(MT_bins);
                epoch_spikes(unit).TET_mean_OC = sum(TET_spikes(:,unit)) / sum(TET_bins);
                epoch_spikes(unit).p_OC = anova1(unit_epoch_means,[],'off');
            end
        end
        
    end
end