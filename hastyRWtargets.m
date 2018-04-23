function [trial_data] =  hastyRWtargets(trial_data)

for i = 2:length(trial_data)
    if strcmp(trial_data(i).reach_dir(2), 'right')
            trial_data(i).target_direction = 0;
    elseif strcmp(trial_data(i).reach_dir(2), 'up')
            trial_data(i).target_direction = num2str(pi/2);
    elseif strcmp(trial_data(i).reach_dir(2), 'left')
            trial_data(i).target_direction = num2str(pi);
    elseif strcmp(trial_data(i).reach_dir(2), 'down')
            trial_data(i).target_direction = num2str(3*pi/2);
    end
end
end

            