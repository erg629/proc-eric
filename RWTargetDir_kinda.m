function [trial_data] = RWTargetDir_kinda(trial_data)

for i = 2:length(trial_data)
    if strcmp('right',trial_data(i).reach_dir(2))
        trial_data(i).target_direction = 0;
    elseif strcmp('left',trial_data(i).reach_dir(2))
        trial_data(i).target_direction = pi;
    elseif strcmp('up',trial_data(i).reach_dir(2))
        trial_data(i).target_direction = pi/2;
    elseif strcmp('down',trial_data(i).reach_dir(2))
        trial_data(i).target_direction = 3*pi/2;
    end
end
end
