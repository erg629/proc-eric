%%%%%%% Full 360^ Polarplots of unit firing %%%%%%%%%%%%%%
    %%%%  should be good for both iso and  %%%%
         %%%%  standard RW tasks  %%%%     

function [fh] = PlotDirFiring(trial_data,spikes)

rads = degtorad(cell2mat({trial_data.reach_dir})); %have to convert to radians
for u = 1:size(spikes,2) %will make a plot for each unit
    
    figure
    
    if size(spikes,2) == length(trial_data(2).RightCuneate_unit_guide) %dynamically changing the title based on which unit's spikes
        title1 = ['Lando', 'RightCuneate', ' Electrode' num2str(trial_data(2).RightCuneate_unit_guide(u,1)), ' Unit ', num2str(trial_data(2).RightCuneate_unit_guide(u,2))];
    elseif size(spikes,2) == length(trial_data(2).LeftS1_unit_guide)
        title1 = ['Lando', 'LeftS1', ' Electrode' num2str(trial_data(2).LeftS1_unit_guide(u,1)), ' Unit ', num2str(trial_data(2).LeftS1_unit_guide(u,2))];
    end
    
    
    for i = 1:length(rads)           %note that rads is 1 shorter than td
    theta = rads(i);                 %trial reach angle
    rho = spikes(i+1,u);             %trial,unit
    
    polarplot(theta,rho,'Marker','.')
    hold on
    end
    
    title(title1)
end
end
