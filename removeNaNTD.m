function trial_data = removeNaNTD(trial_data,idx_start, idx_end)
%Replace NaNs with 1s from start and end before trimming with trimTD
%Really I'm not even sure this is a valid thing to do, not knowing what makes only a few indices NaN

n = numel(extractfield(trial_data,idx_start));

for i = 1:n
    if isnan(trial_data(i).(idx_start))
        trial_data(i).(idx_start) = 1;
    end
end




